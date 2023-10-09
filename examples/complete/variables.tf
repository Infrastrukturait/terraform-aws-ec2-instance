variable "region" {
  type        = string
  default     = ""
  description = <<-EOT
    AWS [Region](https://aws.amazon.com/about-aws/global-infrastructure/) to apply example resources.
    The region must be set. Can be set by this variable, also et with either the `AWS_REGION` or `AWS_DEFAULT_REGION` environment variables,
    or via a shared config file parameter region if profile is used.
  EOT
}

variable "name" {
  type        = string
  description = "Name of EC2 instance"
}
