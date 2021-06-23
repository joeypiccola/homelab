resource "aws_iam_role" "role" {
  name = "new_iot2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "iot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_policy_for_lambda" {
  name = "aws-iot-role2"
  role = aws_iam_role.role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "timestream:WriteRecords"
            ],
            "Resource": "${aws_timestreamwrite_table.example.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "timestream:DescribeEndpoints"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_group" "group" {
  name = "GrafanaTimestreamAccessRO2"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonTimestreamReadOnlyAccess"
}

resource "aws_iam_user" "grafana" {
  name = "grafana2"
}

resource "aws_iam_access_key" "lb" {
  user    = aws_iam_user.grafana.name
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"
  users = [
    aws_iam_user.grafana.name
  ]
  group = aws_iam_group.group.name
}
