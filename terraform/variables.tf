variable "ecr_repo_name" {
    type = string
    default = "example-app"
}

variable git_repo_url {
  type        = string
  default     = "https://github.com/vladyslav-tripatkhi/react-redux-realworld-example-app.git"
  description = "description"
}