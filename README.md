# Deploying a Three-Tier Architecture on AWS Using Terraform


Overview

This project demonstrates the deployment of a scalable, secure three-tier architecture on AWS using Terraform. The architecture comprises the following components:

VPC: Public and private subnets for web, application, and database tiers.

Networking: Internet Gateway and NAT Gateways for managing external and internal communications.

Load Balancing: Application Load Balancer (ALB) for traffic distribution.

Auto Scaling: Auto Scaling Groups (ASG) to dynamically manage EC2 instances based on demand.

Database: MySQL RDS database instance for persistent data storage.

Prerequisites

Before using this Terraform code, ensure the following:

Tools:

Terraform >= 1.5.0

AWS CLI installed and configured

IDE/Text Editor (e.g., VSCode)

AWS Account:

Access to an AWS account

IAM role or user with permissions to manage VPC, EC2, RDS, and ALB

Network Configuration:

CIDR ranges for subnets



Steps to Execute

Clone the Repository:

 git clone <repository-url> cd <repository-directory>
 
Initialize Terraform:

 terraform init
 
Validate the Configuration:

 terraform validate
 
Plan the Deployment:

 terraform plan
 
Apply the Configuration:

 terraform apply
 
Confirm the prompt by typing yes.

Verify Resources in AWS Console: Check the VPC, subnets, NAT gateways, ALB, EC2 instances, and RDS database in the AWS Management Console.

Access the Application: Use the DNS name of the Application Load Balancer to verify the deployment.
