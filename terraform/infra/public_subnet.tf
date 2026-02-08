resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.publicSubnet1_CIDR
  availability_zone       = var.publicSubnet1_AZ
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "Caprover-publicSubnet-1"
    Tier = "Public"
  })

  depends_on = [aws_vpc.main]
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "Caprover-publicRoute"
  })
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_route.id
}