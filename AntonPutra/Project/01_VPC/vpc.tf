# locals {
#   env         = "staging"
#   region      = "us-east-1"
#   zone1       = "us-east-1a"
#   zone2       = "us-east-1b"
#   eks_name    = "demo"
#   eks_version = "1.29"

# }
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${local.env}-main"
  }
}
# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${local.env}-igw"
  }
}
# subnets
resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.zone1
  cidr_block        = "10.0.0.0/19"

  tags = {
    Name                                                   = "${local.env}-private-${local.zone1}"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}
resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.zone2
  cidr_block        = "10.0.32.0/19"

  tags = {
    Name                                                   = "${local.env}-private-${local.zone2}"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}
resource "aws_subnet" "public_zone1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.zone1
  cidr_block        = "10.0.64.0/19"

  tags = {
    Name                                                   = "${local.env}-public-${local.zone1}"
    "kubernetes.io/role/internal-nlb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local-eks_name}" = "owned"
  }
}
resource "aws_subnet" "public_zone2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = local.zone2
  cidr_block        = "10.0.96.0/19"

  tags = {
    Name                                                   = "${local.env}-public-${local.zone2}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${local.env}-${local-eks_name}" = "owned"
  }
}

# nat gateway
# publicip for nat-gw
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${local.env}-nat"
  }
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id
  tags = {
    Name = "${local.env}-nat-gw"
  }
  depends_on = [aws_internet_gateway.igw]
}

# private and public route tables and association
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${local.env}-private"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.env}-public"
  }
}

resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}