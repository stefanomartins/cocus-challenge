resource "aws_key_pair" "cocus_key" {
  key_name   = "cocus-challenge-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdH4cBkgHWQh7eXqYX3bzqJ0mKDOitDPKD3r2UnRG4lq6+tgmpC9GN4q/kGFkoem/BrHrmzz74LIuvotxh//cmAFmsDhct0gOsm5cusmNQ9Jg2kKWCyusfy/CCreQ3HDZqXEgrGsOCakm4Ku/fpwCWROuZhf9oUFuoVVoyyPZANcaK37iJOjAdHrQE020Z0oUw1J1ARB1bgIGO5vPCDYKQT3aHBfhrxh5MSXxqfXpgwIPRc1yd2AIUpcHIDzz0f1mFHTIB1QpOJ0hCtRD4zahNLCF2uz14rrpa+pUImJ/Os03UG75uQRfjsC3NTY+QSSYNu4vjYVIwrQR0uaFumVwV cocus-challenge"
}

data "aws_ami" "amazon_linux_image" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "webserver" {
  ami           = data.aws_ami.amazon_linux_image.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.cocus_key.id

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.awslab_subnet_public.id
  vpc_security_group_ids      = [aws_security_group.webserver_sg.id]

  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "dbserver" {
  ami           = data.aws_ami.amazon_linux_image.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.cocus_key.id

  subnet_id              = aws_subnet.awslab_subnet_private.id
  vpc_security_group_ids = [aws_security_group.dbserver_sg.id]

  tags = {
    Name = "dbserver"
  }
}

