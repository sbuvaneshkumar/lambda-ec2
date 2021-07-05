resource "aws_vpc" "lambdatest-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"
  tags = {
    Name = "Lambda-Test-VPC"
  }
}

resource "aws_subnet" "lambdatest-pub-subnet" {
  vpc_id                  = aws_vpc.lambdatest-vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.public_subnet_az
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Lambda-Test-Pub-Subnet"
  }
}

resource "aws_subnet" "lambdatest-priv-subnet" {
  vpc_id                  = aws_vpc.lambdatest-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.private_subnet_az
  map_public_ip_on_launch = "false"
  tags = {
    Name = "Lambda-Test-Priv-Subnet"
  }
}

resource "aws_internet_gateway" "lambdatest-ig" {
  vpc_id = aws_vpc.lambdatest-vpc.id

  tags = {
    Name = "Lambda-Test-InternetGateway"
  }
}

resource "aws_route_table" "pub-route-table" {
  vpc_id = aws_vpc.lambdatest-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lambdatest-ig.id
  }

  tags = {
    Name = "Lambda-Test-Pub-Route-Table"
  }
}

resource "aws_route_table_association" "lambdatest-route-table" {
  subnet_id      = aws_subnet.lambdatest-pub-subnet.id
  route_table_id = aws_route_table.pub-route-table.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.lambdatest-pub-subnet.id
  tags = {
    "Name" = "Lambda-Test-NatGateway"
  }
}

resource "aws_route_table" "priv-route-table" {
  vpc_id = aws_vpc.lambdatest-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "priv-route-table" {
  subnet_id      = aws_subnet.lambdatest-priv-subnet.id
  route_table_id = aws_route_table.priv-route-table.id
}
