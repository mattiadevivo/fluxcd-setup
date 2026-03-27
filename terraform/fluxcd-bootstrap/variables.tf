variable "github_repository" {
  type        = string
  description = "Repository used as source for FluxCD configuration"
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "Auth token to GitHub"
}
