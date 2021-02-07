terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    access_key = var.acc
    secret_key = var.sec
    region = "us-east-2"
}

# Create a VPC
resource "aws_key_pair" "vib_aws" {
  key_name   = "vib_aws"
  public_key = file(var.key_p)
}
output "AWS_Link" {
  //value = concat([aws_instance.ubuntu.public_dns,""],[":8080/spring-mvc-example",""])
  value=format("Access the AWS hosted app from here: %s%s", aws_instance.vib_aws.public_dns, ":8080/spring-mvc-example")
}
resource "aws_instance" "vib_aws" {
  key_name      = aws_key_pair.vib_aws.key_name
  ami           = "ami-0a0ad6b70e61be944"
  instance_type = "t2.micro"

  tags = {
    Name = "vib_aws"
  }

  /*vpc_security_group_ids = [
    aws_security_group.vib_aws.id
  ]*/

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_p2)
    host        = self.public_ip
  }
  
  
  user_data = <<-EOF
  #!bin/bash
  sudo amazon-linux-extras install tomcat8.5 
  sudo systemctl enable tomcat
  sudo systemctl start tomcat
  cd /usr/share/tomcat/webapps/
  sudo cp /tmp/spring-mvc-example.war /usr/share/tomcat/webapps/spring-mvc-example.war
  EOF
  
  provisioner "file" {
    source      = "/var/lib/jenkins/workspace/vib_assign/target/spring-mvc-example.war"
    destination = "/tmp/spring-mvc-example.war"
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_p2)
    host        = self.public_ip
  }
  }
  
}

variable "acc" {
  type = string
}

variable "sec" {
  type = string
}

variable "key_p" {
  type = string
}


variable "key_p2" {
  type = string
}
