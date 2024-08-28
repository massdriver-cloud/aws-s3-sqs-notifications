## AWS S3 to SQS Notifications

Amazon S3 (Simple Storage Service) is an object storage service offering industry-leading scalability, data availability, security, and performance. SQS (Simple Queue Service) is a fully managed message queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications. This setup allows you to send S3 event notifications directly to an SQS queue, providing a reliable messaging layer between your S3 bucket and downstream services.

### Design Decisions

- **Event Notifications:** S3 bucket events trigger messages to be sent to an SQS queue. This allows for asynchronous processing of S3 events.
- **IAM Policies:** IAM policies are configured to allow S3 to send messages to SQS and optionally provide cross-account access.
- **Flexibility:** Optional filtering criteria for event prefixes and suffixes can be specified for more granular control over which S3 events trigger notifications.
  
### Runbook

#### S3 Event Notifications Not Triggering SQS Messages

If you're experiencing issues where S3 events are not sending messages to the SQS queue, follow these steps:

Check if the bucket has proper event notification configuration:

```sh
aws s3api get-bucket-notification-configuration --bucket <your-bucket-name>
```
You should see SQS configurations listed under the `QueueConfigurations` section.

Validate that the SQS queue is receiving messages:

```sh
aws sqs receive-message --queue-url <your-sqs-queue-url>
```
Expect messages if the S3 events are properly triggering and sending to SQS.

#### IAM Permission Issues

Verify the IAM policy attached to the SQS queue to ensure it allows S3 to send messages:

Check the policy document:

```sh
aws sqs get-queue-attributes --queue-url <your-sqs-queue-url> --attribute-name Policy
```
The policy should allow the `s3.amazonaws.com` principal to perform `SendMessage` action.

#### SQS Message Reading Issues

If you're unable to read messages from the SQS queue:

Ensure your receiving role/user has the correct IAM permissions:

```sh
aws sqs get-queue-attributes --queue-url <your-sqs-queue-url> --attribute-name Policy
```
Confirm actions like `sqs:ReceiveMessage`, `sqs:DeleteMessage`, and `sqs:GetQueueAttributes` are allowed.

Check the IAM role/user inline/bound policies for proper permissions. Adjust if necessary using:

```sh
aws iam attach-role-policy --role-name <your-role-name> --policy-arn <appropriate-policy-arn>
```

#### Cross-Account Access Issues

If other accounts need to receive SQS messages, ensure cross-account policies are correctly set up:

Verify policy document has correct cross-account roles:

```sh
aws sqs get-queue-attributes --queue-url <your-sqs-queue-url> --attribute-name Policy
```
Check for the existence and accuracy of `AWS` principals in the policy document.

---

End of guide.

