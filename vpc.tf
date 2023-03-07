data "aws_availability_zones" "working" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "subnet_public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_1_cidr_block
  availability_zone       = data.aws_availability_zones.working.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-1"
  }
}

resource "aws_subnet" "subnet_public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_2_cidr_block
  availability_zone       = data.aws_availability_zones.working.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "2nd RT for ${var.project_name}"
  }
}

resource "aws_route_table_association" "route-public-1" {
  subnet_id      = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "route-public-2" {
  subnet_id      = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.public_rt.id
}