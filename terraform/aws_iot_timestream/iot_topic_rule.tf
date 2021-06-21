#resource "aws_iot_topic_rule" "rule" {
#  name        = "ToTimestreamRule2"
#  enabled     = true
#  sql         = "SELECT temp, humidity, pressure, color FROM 'dt2/sensor2/#'"
#  sql_version = "2016-03-23"
#
#  sns {
#    message_format = "RAW"
#    role_arn       = aws_iam_role.role.arn
#    target_arn     = aws_sns_topic.mytopic.arn
#  }
#
#  error_action {
#    sns {
#      message_format = "RAW"
#      role_arn       = aws_iam_role.role.arn
#      target_arn     = aws_sns_topic.myerrortopic.arn
#    }
#  }
#}
