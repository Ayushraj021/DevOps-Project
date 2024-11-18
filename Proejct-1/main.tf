provider "aws" {
region = "ap-south-1"
}

resource "aws_instance" "one" {
ami = "ami-0327f51db613d7bd2"
instance_type = "t2.medium"
count = 4
vpc_security_group_ids = ["sg-0b20ea9c881f8aade"]
tags = {
    Name = var.instance_name[count.index]
}
}

variable "instance_name"{
    default = ["jenkins", "nexus", "tomcat", "monitor"]
}