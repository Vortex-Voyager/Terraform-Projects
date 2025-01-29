# Configure the AWS VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc-cidr-block
  tags       = merge(local.project-tag, { Name = "myVPC-${local.project-tag["project"]}" })
}


# Configure Public Subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.publicsubnet-cidr[0]
  availability_zone       = var.az[0]
  map_public_ip_on_launch = true
  tags                    = merge(local.project-tag, { Name = "mywebsubnet1-${local.project-tag["project"]}" })
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.publicsubnet-cidr[1]
  availability_zone       = var.az[1]
  map_public_ip_on_launch = true
  tags                    = merge(local.project-tag, { Name = "mywebsubnet2-${local.project-tag["project"]}" })
}


# Configure Private Subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.privatesubnet-cidr[0]
  availability_zone = var.az[0]
  tags              = merge(local.project-tag, { Name = "myappsubnet1-${local.project-tag["project"]}" })
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.privatesubnet-cidr[1]
  availability_zone = var.az[1]
  tags              = merge(local.project-tag, { Name = "myappsubnet2-${local.project-tag["project"]}" })
}

# Configure Private Subnet for Database
resource "aws_subnet" "private_subnet_for_DB_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.dbsubnet-cidr[0]
  availability_zone       = var.az[0]
  map_public_ip_on_launch = false
  tags                    = merge(local.project-tag, { Name = "mydbsubnet1-${local.project-tag["project"]}" })
}

resource "aws_subnet" "private_subnet_for_DB_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.dbsubnet-cidr[1]
  availability_zone       = var.az[1]
  map_public_ip_on_launch = false
  tags                    = merge(local.project-tag, { Name = "mydbsubnet2-${local.project-tag["project"]}" })
}





# Provision Web Tier
data "aws_ssm_parameter" "latest_amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


# Launch Template and Auto Scaling Group
resource "aws_launch_template" "launch_template-webtier" {
  name_prefix            = "launch_template-webtier"
  image_id               = data.aws_ssm_parameter.latest_amazon_linux.value
  instance_type          = var.ec2type
  user_data              = filebase64("userdata.sh")
  vpc_security_group_ids = [aws_security_group.sg-for-alb.id]
  tags                   = merge(local.project-tag, { Name = "launchtemplate-web-${local.project-tag["project"]}" })



}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1

  launch_template {
    id      = aws_launch_template.launch_template-webtier.id
    version = "$Latest"
  }


  target_group_arns = [aws_lb_target_group.alb-tg.arn]
  depends_on        = [aws_launch_template.launch_template-webtier]
}



# Application tier



resource "aws_launch_template" "launch_template-apptier" {
  name_prefix            = "launch_template-apptier"
  image_id               = data.aws_ssm_parameter.latest_amazon_linux.value
  instance_type          = var.ec2type
  vpc_security_group_ids = [aws_security_group.apptier-sg.id]
  user_data              = filebase64("userdata-script.sh")
  tags                   = merge(local.project-tag, { Name = "launchtemplate-app-${local.project-tag["project"]}" })
}

resource "aws_autoscaling_group" "asg-apptier" {

  desired_capacity = 2
  max_size         = 2
  min_size         = 1

  launch_template {
    id      = aws_launch_template.launch_template-apptier.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  depends_on          = [aws_launch_template.launch_template-apptier]
}



#Database tier

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet_for_DB_1.id, aws_subnet.private_subnet_for_DB_2.id]
  tags       = merge(local.project-tag, { Name = "myDBsubnetgroup-${local.project-tag["project"]}" })

}

resource "aws_db_instance" "Database" {
  allocated_storage      = 10
  db_name                = "mydb"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "username"
  password               = "password"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.databasetier-sg.id]
  multi_az               = true
  tags                   = merge(local.project-tag, { Name = "mydatabase-${local.project-tag["project"]}" })
  depends_on             = [aws_db_subnet_group.db_subnet_group]

}



