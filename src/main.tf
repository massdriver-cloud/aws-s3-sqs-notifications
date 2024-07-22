resource "aws_sqs_queue" "main" {
  name = var.md_metadata.name_prefix
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.url

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.main.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.bucket.data.infrastructure.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "main" {
  bucket = var.bucket.data.infrastructure.arn

  queue {
    queue_arn = aws_sqs_queue.main.arn
    events    = ["s3:ObjectCreated:*"]
    # filter_prefix = "uploads/"
    # filter_suffix = ".txt"
  }
}

resource "aws_iam_policy" "subscribe" {
  name        = "${var.md_metadata.name_prefix}-subscribe"
  description = "SQS subscribe policy: ${var.md_metadata.name_prefix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
      Effect   = "Allow"
      Resource = aws_sqs_queue.main.arn
    }]
  })
}
