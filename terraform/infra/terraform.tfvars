### Global Variables ###

region = "ap-southeast-5"
tags = {
  "Project"   = "Caprover-with-DevSecOps-Terraform"
  "ManagedBy" = "Terraform"
}

### VPC Variables ###

vpc_cidr = "172.31.0.0/16"

publicSubnet1_CIDR = "172.31.0.0/20"
publicSubnet1_AZ   = "ap-southeast-5a"

### E2C Variables ###

instance_type    = "t3.medium"
ec2_ami          = "ami-0474eefc99186cb7d"
root_volume_size = 40