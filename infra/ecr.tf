module "ecr" {
  source                          = "terraform-aws-modules/ecr/aws"
  repository_name                 = "team2-accenture/groupwork"
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus   = "tagged",
          tagPrefixList = ["v"],
          countType   = "imageCountMoreThan",
          countNumber = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}