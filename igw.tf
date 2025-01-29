# Configure Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags   = merge(local.project-tag, { Name = "IGW-${local.project-tag["project"]}" })

}
