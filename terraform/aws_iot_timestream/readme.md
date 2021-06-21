# aws_iot_timestream

This module is a work in progress. Current functionally in `aws_iot_topic_rule` is not yet built, see [issue #19904](https://github.com/hashicorp/terraform-provider-aws/issues/19904).

Use this module to create an AWS IoT Core MQTT topic that forwards messages to AWS Timestream.

```hcl
module "aws_iot_timestream" {
  iot_rule_sql          = "SELECT temperature, humidity, pressure FROM 'home/sensors/#'"
  timestream_database   = "home_metrics"
  timestream_table      = "environmentals"
  timestream_dimensions = [
    {
      'location' = 'garage'
    },
    {
      'sensor_type' = 'bme280'
    }
  ]
}
```

## grafana

To visualize the Timestream data in Grafana you'll need to install the [Amazon Timestream Grafana Plugin](https://grafana.com/grafana/plugins/grafana-timestream-datasource/).

### datasource

WIP.

### query format

`SELECT * FROM $__database.$__table WHERE measure_name='temperature'`

`SELECT * FROM $__database.$__table WHERE measure_name='humidity'`

`SELECT * FROM $__database.$__table WHERE measure_name='pressure'`
