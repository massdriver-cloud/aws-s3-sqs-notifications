resource "massdriver_artifact" "queue" {
  field    = "queue"
  name     = "S3 to SQS event notifications"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          arn = aws_sqs_queue.main.arn
        }
        security = {
          iam = {
            subscribe = {
              policy_arn = aws_iam_policy.subscribe.arn
            }
          }
        }
      }
      specs = {
        aws = {
          region = var.bucket.specs.aws.region
        }
      }
    }
  )
}
