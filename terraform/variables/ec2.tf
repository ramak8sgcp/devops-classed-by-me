resource "aws_instance" "terraform-1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_terraform.id]

  tags = {
    Name = "terraform"
  }
}

resource "aws_security_group" "allow_ssh_terraform" {
    name        =  "allow-ssh"  #allow_ssh is already ther in my account
    description = "Allo port number 22 for SSH access"

    #usually we allow everything in egress
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]    #allow from everyone
    ipv6_cidr_blocks = ["::/0"]
  }
  tags  = {
    Name = "allow_demo"
  }
}
