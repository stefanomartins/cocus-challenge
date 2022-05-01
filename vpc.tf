resource "aws_vpc" "awslab_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "awslab-vpc"
  }
}

resource "aws_internet_gateway" "awslab_ig" {
  vpc_id = aws_vpc.awslab_vpc.id

  tags = {
    Name = "awslab_internet_gateway"
  }
}

resource "aws_subnet" "awslab_subnet_public" {
  vpc_id     = aws_vpc.awslab_vpc.id
  cidr_block = "172.16.1.0/24"

  tags = {
    Name = "awslab-subnet-public"
  }
}

resource "aws_subnet" "awslab_subnet_private" {
  vpc_id     = aws_vpc.awslab_vpc.id
  cidr_block = "172.16.2.0/24"

  tags = {
    Name = "awslab-subnet-private"
  }
}

resource "aws_route_table" "aws_subnet_public_rt" {
  vpc_id = aws_vpc.awslab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awslab_ig.id
  }

  tags = {
    Name = "cocus-public"
  }
}

resource "aws_route_table_association" "subnet_public_rta" {
  subnet_id      = aws_subnet.awslab_subnet_public.id
  route_table_id = aws_route_table.aws_subnet_public_rt.id
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-ports"
  description = "COCUS AWS Lab Webserver Ports"
  vpc_id      = aws_vpc.awslab_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Output traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "dbserver_sg" {
  name        = "database-ports"
  description = "COCUS AWS Lab Database Ports"
  vpc_id      = aws_vpc.awslab_vpc.id

  ingress {
    description = "ICMP"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.awslab_subnet_public.cidr_block]
  }

  egress {
    description = "Output traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

