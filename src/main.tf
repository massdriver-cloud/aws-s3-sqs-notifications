resource "aws_sqs_queue" "main" {
  name = var.md_metadata.name_prefix
}

resource "aws_s3_bucket_notification" "main" {
  bucket = element(split("/", var.bucket.data.infrastructure.arn), 1)

  queue {
    queue_arn = aws_sqs_queue.main.arn
    events    = ["s3:ObjectCreated:*"]
    # filter_prefix = "uploads/"
    # filter_suffix = ".txt"
  }
}
