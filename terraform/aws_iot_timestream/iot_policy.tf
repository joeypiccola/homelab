# create the policy
resource "aws_iot_policy" "pubsub" {
  name = "test_thing_pol2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iot:Connect"
        ],
        "Resource" : [
          "arn:aws:iot:us-east-1:152781741662:client/$${iot:Connection.Thing.ThingName}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iot:Publish"
        ],
        "Resource" : [
          "arn:aws:iot:us-east-1:152781741662:topic/home/sensors/*"
        ]
      }
    ]
  })
}

# attach the cert to the policy
resource "aws_iot_policy_attachment" "att" {
  policy = aws_iot_policy.pubsub.name
  target = aws_iot_certificate.cert.arn
}
