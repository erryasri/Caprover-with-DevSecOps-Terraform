### Global Variables ###

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

### VPC Variables ###

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "publicSubnet1_CIDR" {
  description = "CIDR block for the public subnet 1"
  type        = string
}

variable "publicSubnet1_AZ" {
  description = "Available zone for public subnet 1"
  type        = string
}

### EC2 Variables ###

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "root_volume_size" {
  description = "Size of root EBS volume in GB"
  type        = number
}