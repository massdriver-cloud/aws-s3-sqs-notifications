resource "massdriver_artifact" "queue" {
  field                = "queue"
  provider_resource_id = aws_sqs_queue.main.arn
  name                 = "S3 to SQS event notifications"
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
          region = var.region
        }
      }
    }
  )
}
