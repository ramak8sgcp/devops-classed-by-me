variable "ami_id" {
  type        = string
  default = "ami-09c813fb71547fc4f "
  description = " This is the AMI ID of devops-practice which is RHEL-9"
}

variable "instance_type" {
    type = string 
    default = "t3.micro"
}

variable "tags" {
    type = map
    default = {
        Name = "mysql"
        project = "expense"
        Component = "backend"
        Environment = "Dev"
        Terraform = "true"
    }
}