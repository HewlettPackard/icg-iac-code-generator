

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  # region = var.region_name
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}



resource "aws_instance" "OracleDB" {

  instance_type = "t2.nano"
  key_name = "dbCredentials"
  
  tags = {
    "Name" = "concrete_oracleDB"
  }
}


#VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "concrete_vpc"
  }
}


# Subnet
resource "aws_subnet" "subnet1_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.100.1.0/24"
  map_public_ip_on_launch  = false
  tags = {
    Name = "subnet1"
  }
}
# Subnet
resource "aws_subnet" "subnet2_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.100.2.0/24"
  map_public_ip_on_launch  = false
  tags = {
    Name = "subnet2"
  }
}
# Subnet
resource "aws_subnet" "subnet3_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.100.3.0/24"
  map_public_ip_on_launch  = false
  tags = {
    Name = "subnet3"
  }
}




resource "aws_launch_template" "elasticsearch_asg" {
  name_prefix   = "asg1_"
  image_id= "ami-040182628d683524a"
  instance_type = "t2.nano" 
}

resource "aws_autoscaling_group" "elasticsearch_asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.subnet1_subnet.id]
  launch_template {
    id      = aws_launch_template.elasticsearch_asg.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "edi_asg" {
  name_prefix   = "asg2_"
  image_id= "ami-Od89299d2f7cOf49b"
  instance_type = "t2.nano" 
}

resource "aws_autoscaling_group" "edi_asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.subnet3_subnet.id]
  launch_template {
    id      = aws_launch_template.edi_asg.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "gestaut_asg" {
  name_prefix   = "asg3_"
  image_id= "ami-012e54b30d5c6bc9d"
  instance_type = "t2.nano" 
}

resource "aws_autoscaling_group" "gestaut_asg" {
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.subnet2_subnet.id]
  launch_template {
    id      = aws_launch_template.gestaut_asg.id
    version = "$Latest"
  }
}


resource "aws_key_pair" "dbCredentials" {
  key_name   = "dbCredentials"
  public_key = "AKIAUW2K4WS3DFRYCEX4"
}


resource "aws_key_pair" "ESKeyName" {
  key_name   = "ESKeyName"
  public_key = "AKIAUW2K4WS3DFRYCEX4"
}


resource "aws_key_pair" "EdiKeyName" {
  key_name   = "EdiKeyName"
  public_key = "AKIAUW2K4WS3DFRYCEX4"
}


resource "aws_key_pair" "GestautKeyName" {
  key_name   = "GestautKeyName"
  public_key = "AKIAUW2K4WS3DFRYCEX4"
}

