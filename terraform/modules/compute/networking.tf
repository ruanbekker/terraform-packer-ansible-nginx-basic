data "aws_vpc" "default" {
  default = true
  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "az" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.aws_region]
  }
}

data "aws_subnet" "subnet_1" {
  availability_zone = data.aws_availability_zones.az.names[0]
  vpc_id = data.aws_vpc.default.id
  tags = {
    Tier = var.network_tier
  }
}

data "aws_subnet" "subnet_2" {
  availability_zone = data.aws_availability_zones.az.names[1]
  vpc_id = data.aws_vpc.default.id
  tags = {
    Tier = var.network_tier
  }
}

data "aws_subnet" "subnet_3" {
  availability_zone = data.aws_availability_zones.az.names[2]
  vpc_id = data.aws_vpc.default.id
  tags = {
    Tier = var.network_tier
  }
}

resource "random_shuffle" "subnet_id" {
  input        = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id, data.aws_subnet.subnet_3.id]
  result_count = 1
}
