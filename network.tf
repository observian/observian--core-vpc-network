
resource "aws_vpc" "base-app" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name                                            = "${var.application}-${var.env}-vpc"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}



### AZ 1
resource "aws_subnet" "base-app-public-alpha" {
  vpc_id            = aws_vpc.base-app.id
  cidr_block        = var.public_alpha_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-alpha")

  tags = {
    Name                                            = "${var.application}-${var.env}-public-alpha",
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared",
    "kubernetes.io/role/elb"                        = 1,
    Environment = var.env
  }
}

resource "aws_subnet" "base-app-private-alpha" {
  vpc_id            = aws_vpc.base-app.id
  cidr_block        = var.private_alpha_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-alpha")

  tags = {
    Name                                            = "${var.application}-${var.env}-private-alpha",
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

### AZ 2
resource "aws_subnet" "base-app-public-bravo" {
  vpc_id            = aws_vpc.base-app.id
  cidr_block        = var.public_bravo_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-bravo")

  tags = {
    Name                                            = "${var.application}-${var.env}-public-bravo",
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared",
    "kubernetes.io/role/elb"                        = 1
  }
}

resource "aws_subnet" "base-app-private-bravo" {
  vpc_id            = aws_vpc.base-app.id
  cidr_block        = var.private_bravo_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-bravo")

  tags = {
    Name                                            = "${var.application}-${var.env}-private-bravo",
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "base-app-igw" {
  vpc_id = aws_vpc.base-app.id
  tags = {
    Name = "${var.application}-${var.env}-igw"
  }
}
resource "aws_eip" "elastic-ip-alpha" {
  vpc = true
}

resource "aws_eip" "elastic-ip-bravo" {
  vpc = true
}

resource "aws_nat_gateway" "base-app-alpha-nat" {

  subnet_id     = aws_subnet.base-app-public-alpha.id
  allocation_id = aws_eip.elastic-ip-alpha.id
  depends_on    = [aws_internet_gateway.base-app-igw]
  tags = {
    Name = "${var.application}-${var.env}-alpha-nat"
  }
}

resource "aws_nat_gateway" "base-app-bravo-nat" {

  subnet_id     = aws_subnet.base-app-public-bravo.id
  allocation_id = aws_eip.elastic-ip-bravo.id
  depends_on    = [aws_internet_gateway.base-app-igw]
  tags = {
    Name = "${var.application}-${var.env}-bravo-nat"
  }
}

## Route Tables ##
resource "aws_route_table" "base-app-rt-private-alpha" {
  vpc_id = aws_vpc.base-app.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.base-app-alpha-nat.id
  }

}

resource "aws_route_table_association" "base-app-rta-private-alpha" {
  subnet_id      = aws_subnet.base-app-private-alpha.id
  route_table_id = aws_route_table.base-app-rt-private-alpha.id
}

resource "aws_route_table" "base-app-rt-private-bravo" {
  vpc_id = aws_vpc.base-app.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.base-app-bravo-nat.id
  }

}

resource "aws_route_table_association" "base-app-rta-private-bravo" {
  subnet_id      = aws_subnet.base-app-private-bravo.id
  route_table_id = aws_route_table.base-app-rt-private-bravo.id
}

resource "aws_route_table" "base-app-rt-public-alpha" {
  vpc_id = aws_vpc.base-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base-app-igw.id
  }
}

resource "aws_route_table_association" "base-app-rta-public-alpha" {
  subnet_id      = aws_subnet.base-app-public-alpha.id
  route_table_id = aws_route_table.base-app-rt-public-alpha.id
}

resource "aws_route_table" "base-app-rt-public-bravo" {
  vpc_id = aws_vpc.base-app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base-app-igw.id
  }
}

resource "aws_route_table_association" "base-app-rta-public-bravo" {
  subnet_id      = aws_subnet.base-app-public-bravo.id
  route_table_id = aws_route_table.base-app-rt-public-bravo.id
}
