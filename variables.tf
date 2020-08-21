variable "dns_zone" {
  type        = string
  description = "Name of the DNS zone to use with this deployment."
}

variable "root_zone_name" {
  type        = string
  description = "CloudFlare Zone ID"
}

variable "root_zone_id" {
  type        = string
  description = "CloudFlare Zone ID"
}

variable "aws_assume_role_arn" {
  type        = string
  description = "ARN of the AWS role to assume when running this deployment."
}

