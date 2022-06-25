provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "Hillel"
      Lesson    = "27"
      Terraform = "True"
    }
  }
}

provider "aws" {
    alias = "aws-west"
    region = "us-west-1"

    default_tags {
        tags = {
        Project   = "Hillel"
        Lesson    = "27"
        Terraform = "True"
        }
    }
}

locals {
    registry_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com"
    alb_name = "example-alb"
}

resource "aws_ecr_repository" "example_app" {
    name = var.ecr_repo_name
    image_scanning_configuration {
        scan_on_push = true
    }

#     provisioner "local-exec" {
#         command =<<EOF
# git clone ${var.git_repo_url} /tmp/example && cd /tmp/example && docker build  --platform linux/amd64 -t ${local.registry_url}/${var.ecr_repo_name} . && cd $OLDPWD
# aws ecr get-login-password | docker login --username AWS --password-stdin ${local.registry_url}
# docker push ${local.registry_url}/${var.ecr_repo_name}
# rm -rf /tmp/example
#         EOF
#     }
}

output "repo_name" {
  value = local.registry_url
  sensitive = false
}
