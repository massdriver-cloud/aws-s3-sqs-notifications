resource "aws_sqs_queue" "main" {
  name = var.md_metadata.name_prefix
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id
  policy    = data.aws_iam_policy_document.main.json
}

resource "aws_s3_bucket_notification" "main" {
  bucket = element(
    reverse(
      split(":", var.bucket.data.infrastructure.arn)
    ),
  0)

  queue {
    queue_arn = aws_sqs_queue.main.arn
    events    = ["s3:ObjectCreated:*"]
    # filter_prefix = "uploads/"
    # filter_suffix = ".txt"
  }
}
