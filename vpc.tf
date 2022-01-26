resource "aws_vpc" "nomadic" {
  count      = var.nomadic_vpc_id == "" ? 1 : 0
  cidr_block = var.nomadic_vpc_cidr
  tags       = var.tags
}

resource "aws_subnet" "nomadic_one" {
  count             = var.nomadic_subnet_id_one == "" ? 1 : 0
  vpc_id            = aws_vpc.nomadic[0].id
  cidr_block        = var.nomadic_subnet_cidr_one
  availability_zone = var.nomadic_availability_zone_one
  tags              = var.tags
}

resource "aws_subnet" "nomadic_two" {
  count             = var.nomadic_subnet_id_two == "" ? 1 : 0
  vpc_id            = aws_vpc.nomadic[0].id
  cidr_block        = var.nomadic_subnet_cidr_two
  availability_zone = var.nomadic_availability_zone_two
  tags              = var.tags
}

resource "aws_subnet" "nomadic_three" {
  count             = var.nomadic_subnet_id_three == "" ? 1 : 0
  vpc_id            = aws_vpc.nomadic[0].id
  cidr_block        = var.nomadic_subnet_cidr_three
  availability_zone = var.nomadic_availability_zone_three
  tags              = var.tags
}

resource "aws_internet_gateway" "nomadic" {
  count  = var.nomadic_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.nomadic[0].id
  tags   = var.tags
}

resource "aws_eip" "nomadic_one" {
  vpc        = true
  instance   = aws_instance.nomadic_one.id
  depends_on = [aws_internet_gateway.nomadic]
  tags       = var.tags
}

resource "aws_eip" "nomadic_two" {
  vpc        = true
  instance   = aws_instance.nomadic_two.id
  depends_on = [aws_internet_gateway.nomadic]
  tags       = var.tags
}

resource "aws_eip" "nomadic_three" {
  vpc        = true
  instance   = aws_instance.nomadic_three.id
  depends_on = [aws_internet_gateway.nomadic]
  tags       = var.tags
}

resource "aws_route_table" "nomadic" {
  count  = var.nomadic_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.nomadic[0].id
  tags   = var.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nomadic[0].id
  }
}

resource "aws_route_table_association" "nomadic_one" {
  count          = var.nomadic_subnet_id_one == "" ? 1 : 0
  subnet_id      = local.subnet_id_one
  route_table_id = aws_route_table.nomadic[0].id
}

resource "aws_route_table_association" "nomadic_two" {
  count          = var.nomadic_subnet_id_two == "" ? 1 : 0
  subnet_id      = local.subnet_id_two
  route_table_id = aws_route_table.nomadic[0].id
}

resource "aws_route_table_association" "nomadic_three" {
  count          = var.nomadic_subnet_id_three == "" ? 1 : 0
  subnet_id      = local.subnet_id_three
  route_table_id = aws_route_table.nomadic[0].id
}
