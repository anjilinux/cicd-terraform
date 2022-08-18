provider "aws" {

  region = "us-east-1"
  access_key= "AKIAW4NAFJ43RDCBPSOQ"
  secret_key= "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"
}

resource "aws_vpc" "hp" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
 enable_dns_hostnames  = true

  tags = {
    Name = "hp"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.hp.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.hp.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "sub2"
  }
}

resource "aws_subnet" "sub3" {
  vpc_id                  = aws_vpc.hp.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub4" {
  cidr_block              = "10.0.4.0/24"
  vpc_id                  = aws_vpc.hp.id
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hp.id
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.hp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "art1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "art2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "art3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.rt.id
}


resource "aws_route_table_association" "art4" {
  subnet_id      = aws_subnet.sub4.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.hp.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

}

