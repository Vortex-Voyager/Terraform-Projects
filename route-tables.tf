# Configure Route Table for public subnet
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.myvpc.id

  tags = merge(local.project-tag, { Name = "myroutetable-webtier-${local.project-tag["project"]}" })
}


# Configure Route Table Association
resource "aws_route_table_association" "rta-public-1a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt-public.id
}
resource "aws_route_table_association" "rta-public-1b" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route" "routes-public" {
  route_table_id         = aws_route_table.rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Configure Route Table for Private subnet

resource "aws_route_table" "rt-private-1" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-1a.id
  }
  tags = merge(local.project-tag, { Name = "myroutetable-apptier-${local.project-tag["project"]}" })
}

resource "aws_route_table" "rt-private-2" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-1b.id
  }
  tags = merge(local.project-tag, { Name = "myroutetable-apptier-${local.project-tag["project"]}" })
}



# Configure Route Table Association
resource "aws_route_table_association" "rta-private-1a" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.rt-private-1.id


}

resource "aws_route_table_association" "rta-private-1b" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.rt-private-2.id
}

