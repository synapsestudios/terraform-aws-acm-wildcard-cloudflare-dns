##########################
# AWS Provider - us-east-1
##########################
provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

##########################
# AWS Provider - us-west-2
##########################
provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
}

##################################################################
# ACM - Wildcard SSL Certifcate for Environment (US-EAST-1 Region)
##################################################################
resource "aws_acm_certificate" "us_east_1" {
  domain_name               = "*.${var.dns_zone}"
  subject_alternative_names = [var.dns_zone]
  validation_method         = "DNS"
  provider                  = aws.us-east-1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "us_east_1" {
  certificate_arn         = aws_acm_certificate.us_east_1.arn
  validation_record_fqdns = [cloudflare_record.validation.hostname]
  provider                = aws.us-east-1
}

##################################################################
# ACM - Wildcard SSL Certifcate for Environment (US-WEST-2 Region)
##################################################################
resource "aws_acm_certificate" "us_west_2" {
  domain_name               = "*.${var.dns_zone}"
  subject_alternative_names = [var.dns_zone]
  validation_method         = "DNS"
  provider                  = aws.us-west-2

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "us_west_2" {
  certificate_arn         = aws_acm_certificate.us_west_2.arn
  validation_record_fqdns = [cloudflare_record.validation.hostname]
  provider                = aws.us-west-2
}

##################################
# CloudFlare DNS Validation Record
##################################
resource "cloudflare_record" "validation" {
  zone_id = var.root_zone_id
  name    = trim(aws_acm_certificate.us_east_1.domain_validation_options.0.resource_record_name, ".")
  value   = trim(aws_acm_certificate.us_east_1.domain_validation_options.0.resource_record_value, ".")
  type    = "CNAME"
  ttl     = 120
}
