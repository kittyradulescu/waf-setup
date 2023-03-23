# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Output variable definitions

output "waf_arn" {
  value       = aws_wafv2_web_acl.api-waf.arn
  description = "waf arn"
}

