# Create SNS Topic
module "sns_alerts" {
  source  = "terraform-aws-modules/sns/aws"
  name = "ecs-topic"
  subscriptions = [
    { protocol = "email", endpoint = "renatalit@yahoo.com" },
    { protocol = "email", endpoint = "d.tsitavets@gmail.com" }
  ]
  display_name = "ECS Alerts Topic"
}