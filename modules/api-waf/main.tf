# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Terraform configuration

resource "aws_wafv2_web_acl" "api-waf" {
  name        = "${var.waf_name}-waf"
  description = "WAF"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "my-api-aws-managed-rules-common-rule-set"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "my-api-aws-managed-rules-common-rule-set"
      sampled_requests_enabled   = true
    }
   }

   visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.waf_name}-waf"
    sampled_requests_enabled   = true
  }
}

resource "aws_api_gateway_rest_api" "my-api-gateway" {
  name = "my-api-gateway"
}

resource "aws_api_gateway_deployment" "my-api-gateway" {
  rest_api_id = aws_api_gateway_rest_api.my-api-gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.my-api-gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "test" {
  rest_api_id   = aws_api_gateway_rest_api.my-api-gateway.id
  deployment_id = aws_api_gateway_deployment.my-api-gateway.id
  stage_name    = "test"
}

resource "aws_wafv2_web_acl_association" "api-waf" {
  resource_arn = aws_api_gateway_stage.test.arn
  web_acl_arn  = aws_wafv2_web_acl.api-waf.arn
}