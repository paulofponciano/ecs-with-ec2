########################################################################################################################
## VPC
########################################################################################################################

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name     = "${var.namespace}_VPC_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## Internet Gateway for egress/ingress connections to resources in the public subnets
########################################################################################################################

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name     = "${var.namespace}_InternetGateway_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## This resource returns a list of all AZ available in the region configured in the AWS
########################################################################################################################

data "aws_availability_zones" "available" {}

########################################################################################################################
## Public Subnets (one public subnet per AZ)
########################################################################################################################

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true

  tags = {
    Name     = "${var.namespace}_PublicSubnet_${count.index}_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## Route Table with egress route to the internet
########################################################################################################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name     = "${var.namespace}_PublicRouteTable_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## Associate Route Table with Public Subnets
########################################################################################################################

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

########################################################################################################################
## Main Route Table
########################################################################################################################

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = aws_vpc.default.id
  route_table_id = aws_route_table.public.id
}

########################################################################################################################
## One Elastic IP per AZ (one for each NAT Gateway in each AZ)
########################################################################################################################

resource "aws_eip" "nat_gateway" {
  count  = var.az_count
  domain = "vpc"

  tags = {
    Name     = "${var.namespace}_EIP_${count.index}_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## One NAT Gateway per AZ
########################################################################################################################

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gateway[count.index].id

  tags = {
    Name     = "${var.namespace}_NATGateway_${count.index}_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## One private subnet per AZ
########################################################################################################################

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.default.id

  tags = {
    Name     = "${var.namespace}_PrivateSubnet_${count.index}_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## Route to the internet using the NAT Gateway
########################################################################################################################

resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name     = "${var.namespace}_PrivateRouteTable_${count.index}_${var.environment}"
    Project = var.project
    Terraform = true
  }
}

########################################################################################################################
## Associate Route Table with Private Subnets
########################################################################################################################

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

