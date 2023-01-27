###### Create vpc ############# 
resource "aws_vpc" "main-vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = var.Prod_Vpc
  }
}

######## Create subnet #############
resource "aws_subnet" "main-subnet" {
  for_each = var.AZ_LIST
 
  availability_zone_id = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.main-vpc.id

  tags = {
    Name = "${var.basename}-subnet-${each.key}"
  }
}
########## internet gateway ###########
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.main-vpc.id

    tags = {
        Name = "internet_gateway"
    }
} 

########## route table ##########
resource "aws_route_table" "route_1" {
  vpc_id = aws_vpc.main-vpc.id

  route = []

  tags = {
    Name = "my_route_table"
  }
}
######## route association using meta arguments #######
resource "aws_route_table_association" "route_association" {
  for_each       = aws_subnet.main-subnet
  route_table_id = aws_route_table.route_1.id
  subnet_id      = each.value.id
}

######## specify route only ############
resource "aws_route" "route_only" {
  route_table_id            = aws_route_table.route_1.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                =  aws_internet_gateway.my_igw.id
  depends_on                = [aws_route_table.route_1]
}

resource "aws_security_group" "mysg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      =  ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "security_1"
  }
}


resource "aws_instance" "aws_make" {
        for_each = aws_subnet.main-subnet
        ami = var.ami
        instance_type = "t2.micro"
        key_name      = "awscert"
        subnet_id      = each.value.id
        vpc_security_group_ids      = [aws_security_group.mysg.id]
        associate_public_ip_address = true

        user_data     = file("install_apache.sh")
        tags = { 
     Name = "${var.instance_name}-server_name-${each.key}"
         
  }
}