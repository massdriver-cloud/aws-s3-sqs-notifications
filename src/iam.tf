data "aws_iam_policy_document" "main" {
  statement {
    sid    = "Allow SNS to SendMessage to this queue"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.main.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["${var.bucket.data.infrastructure.arn}"]
    }
  }

  dynamic "statement" {
    for_each = length(var.queue.additional_access) > 0 ? [1] : []
    content {
      sid    = "Cross Account Access Policy for SQS Read"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.queue.additional_access
      }
      actions   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
      resources = [aws_sqs_queue.main.arn]
    }
  }
}

# Policy for subscribing via artifact
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
