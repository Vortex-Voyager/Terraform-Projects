# Configure Elastic IP's
resource "aws_eip" "eip-1a" {
  tags = merge(local.project-tag, { Name = "ElasticIP1-${local.project-tag["project"]}" })
}
resource "aws_eip" "eip-1b" {
  tags = merge(local.project-tag, { Name = "ElasticIP2-${local.project-tag["project"]}" })
}


# Configure NAT Gateway

resource "aws_nat_gateway" "nat-1a" {
  allocation_id = aws_eip.eip-1a.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags          = merge(local.project-tag, { Name = "NAT1-${local.project-tag["project"]}" })
  depends_on    = [aws_internet_gateway.igw]

}

resource "aws_nat_gateway" "nat-1b" {
  allocation_id = aws_eip.eip-1b.id
  subnet_id     = aws_subnet.public_subnet_2.id
  tags          = merge(local.project-tag, { Name = "NAT2-${local.project-tag["project"]}" })
  depends_on    = [aws_internet_gateway.igw]

}