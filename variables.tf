
variable "vpc-cidr-block" {
  default     = "10.0.0.0/16"
  description = "Cidr Block of VPC"
}

variable "az" {
  default     = ["us-east-1a", "us-east-1b"]
  description = "Availablity Zones"
}

variable "publicsubnet-cidr" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Cidr Block of webtier Subnets"
}


variable "privatesubnet-cidr" {
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "Cidr Block of apptier Subnets "
}


variable "dbsubnet-cidr" {
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
  description = "Cidr Block of database Subnets "
}

variable "ec2type" {
  default     = "t2.micro"
  description = "instance type"
}


locals {
  project-tag = {
    project = "aws_terraform_project"
  }
}
