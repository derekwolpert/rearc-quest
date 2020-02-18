# Creates a vpc to utilize in delivering this project, and defines the allocation
# for ip addresses based on the given CIDR block.

resource "aws_vpc" "rearc-quest-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Data block below is used to access the aws availability zones for ones selected
# region (e.g. us-east-1a, us-west-2b, etc.). Availability zone names are needed
# to configure subnet resources.

data "aws_availability_zones" "rearc-quest-available-zones" {
  state = "available"
}

# Assigns separate ip address allocation for each availability zones.

resource "aws_subnet" "rearc-quest-subnet-1" {
  vpc_id = aws_vpc.rearc-quest-vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = data.aws_availability_zones.rearc-quest-available-zones.names[0]
}

resource "aws_subnet" "rearc-quest-subnet-2" {
  vpc_id = aws_vpc.rearc-quest-vpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = data.aws_availability_zones.rearc-quest-available-zones.names[1]
}

resource "aws_subnet" "rearc-quest-subnet-3" {
  vpc_id = aws_vpc.rearc-quest-vpc.id
  cidr_block = "10.0.32.0/20"
  availability_zone = data.aws_availability_zones.rearc-quest-available-zones.names[2]
}

# Internet gateway creates a logical connection between vpc and the public facing
# internet.

resource "aws_internet_gateway" "rearc-quest-internet-gateway" {
  vpc_id = aws_vpc.rearc-quest-vpc.id
}

# Route table controls where information from a subnet and/or gateway are directed.

resource "aws_default_route_table" "rearc-quest-route-table" {

  default_route_table_id = aws_vpc.rearc-quest-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rearc-quest-internet-gateway.id
  }
}