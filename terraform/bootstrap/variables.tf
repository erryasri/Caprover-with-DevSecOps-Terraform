### Global Variables ###

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

### S3 Bucket Variables ###

variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}