

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
  instance_type = ""
  vpc_security_group_ids = [ aws_security_group.elbsg_security_group.id ] 
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
  instance_type = ""
  vpc_security_group_ids = [ aws_security_group.checkmk_security_group.id ] 
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
  instance_type = ""
  vpc_security_group_ids = [ aws_security_group.sg_security_group.id ] 
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


resource "aws_key_pair" "EdiKeyName" {
  key_name   = "EdiKeyName"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvKu6io1ZkuL4kgMqBaK0QkfcX+HetLTgyUtNTjpdUYY/eBy6jyUWqLTLBcl8Iu7+YMgPKFS5LSMXXZVI5od5sadqvgmVGajkdsg9Zo5WqNxjShf/U1In8ozzNNxTYREM8KLfAAObfaVks6nYCjwc6kFenn4qY6VIlmPYcyzhxWqhknol1A8rDsa6AljvUfwo3G9jUZbUa+s4I2wMs6sN8EziXejePYMzEfEd9pI+4AsQAEJgc9LORXEhhYjDYYTFjEe/GkygBRS5wLsk7UU6Vj/8yq4f3WJPvXRy+1OFViq/NLl5HJ/+1slfhqGPUrDSWqRsUHbXfc3bC5ZSBYMa7"
}


resource "aws_key_pair" "GestautKeyName" {
  key_name   = "GestautKeyName"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr2xijLqtHXO+agwcxxfgaFAXvlsUB0Dr+Ovd/qV4kqLMC6HZ4t9N1HWk3WHJ+9Xfob1aIgOe047ABIL7Q6Q3Nw2ZBAIaqVkim2t9FNNvzHGvEq0kkhQF+CydBgYsMrfi5aVJrBtHidL0BdoWHpjlMHicP4udZomX3Ke4php8HLye8Amjog2susXsEad3z8S/l8ibkFBJD2BpiRVu5NYHrbhhqS6ACJ/xe3PnxlBH3jrOtQLRqvFRniWOdVfS+DFTuN8AirF9VK/ALmH+igIWeP4W2Jbh4T7buqR6sh5tXxBkAkDOHKpsZgjp1ogJz2imkvOTMeUIYdCmTOfRzSTm9"
}


resource "aws_key_pair" "ESKeyName" {
  key_name   = "ESKeyName"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCK1aFgilnXIherX2jIcZnmVAK7LUVD39K70u7tcJ61YvcSLA6u2vEYoeV99bDF5iAUVF1a3vyraeOhNG4V6KtLunsBYmDe1c+OoMXAb7oXVntkUOGnywTV4xy9S3diCc1YKDwp0yfK9/bebZM/5Quv/dX0EDTYIzTuEc+YpNU/Yipgp/doZI0fonzkMTiU12GbgSiErqtXPQ4tH1Makntj+U5OOp1wsNFRIr0yjJGuE+RDKxyNaa+eMjB0TB+SyKmJm1xUE1N9aoa11cj3IZ43x75TLIffSZOYGgaOsmT81qTpBNnPyf/qui0WzlgQwBSau0opFw/4cBCmOFSxHYYJ"
}



# CREATING SECURITY_GROUP
resource "aws_security_group" "sg_security_group" {
  name        = "sg"
  vpc_id      = aws_vpc.vpc.id   
  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0", ]
  } 
  egress {
    from_port   = 80
    to_port     = 80
    protocol = "TCP"
    cidr_blocks = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", ]
  } 
  egress {
    from_port   = 9200
    to_port     = 9200
    protocol = "TCP"
    cidr_blocks = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", ]
  } 
  egress {
    from_port   = 6556
    to_port     = 6556
    protocol = "TCP"
    cidr_blocks = ["54.217.119.81/32", ]
  } 
  egress {
    from_port   = 22
    to_port     = 22
    protocol = "TCP"
    cidr_blocks = ["213.96.27.139/32", "37.187.173.88/32", "51.89.40.59/32", "195.53.242.200/32", ]
  }  
}





# CREATING SECURITY_GROUP
resource "aws_security_group" "dbsg_security_group" {
  name        = "dbsg"
  vpc_id      = aws_vpc.vpc.id   
  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0", ]
  } 
  egress {
    from_port   = 1521
    to_port     = 1521
    protocol = "TCP"
    cidr_blocks = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", "84.124.78.66/32", ]
  } 
}





# CREATING SECURITY_GROUP
resource "aws_security_group" "elbsg_security_group" {
  name        = "elbsg"
  vpc_id      = aws_vpc.vpc.id   
  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0", ]
  } 
  egress {
    from_port   = 80
    to_port     = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0", "::/0", ]
  } 
  egress {
    from_port   = 443
    to_port     = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0", "::/0", ]
  } 
  egress {
    from_port   = 9200
    to_port     = 9200
    protocol = "TCP"
    cidr_blocks = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", ]
  }  
}





# CREATING SECURITY_GROUP
resource "aws_security_group" "checkmk_security_group" {
  name        = "checkmk"
  vpc_id      = aws_vpc.vpc.id   
  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0", ]
  } 
  egress {
    from_port   = 80
    to_port     = 80
    protocol = "TCP"
    cidr_blocks = ["84.124.78.66/32", ]
  } 
  egress {
    from_port   = 443
    to_port     = 443
    protocol = "TCP"
    cidr_blocks = ["84.124.78.66/32", ]
  } 
  egress {
    from_port   = 22
    to_port     = 22
    protocol = "TCP"
    cidr_blocks = ["84.124.78.66/32", ]
  }  
}



