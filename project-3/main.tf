provider "aws" {
  region = "us-east-1"
  access_key = "<acces_key>"
  secret_key = "<security_key>"
}

#1. create VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod-vpc"
  }
}

#2. create Internet Gateway
resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.my-vpc.id
}

#3. create Route Table
resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }

  tags = {
    Name = "prod-route-table"
  }
}

#create variable
#any variable that isn't assigned a value, terraform prompts the user at runtime for the value
#we can assign values through a cmd line arg
#we can also use env variables from our OS
#the best way to do it is to create a seperate file to assign variables - terraform automatically searches for a file terraform.tfvars for variable assignments
variable "subnet_prefix" {
    description = "cidr block for subnet" #(optional)
    #defautt (optional - default value if we don't pass in a variable)
    #type (optional - constraints - can use the any value if we don't kno wthe type)
}


#4. create a Subnet
resource "aws_subnet" "my-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.subnet_prefix

  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

#5. associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}

#6. create Security Group to allow port 22, 80, 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

#7. create a Network Interface with an ip in the Subnet that was created in step 4
resource "aws_network_interface" "my-network-interface" {
  subnet_id       = aws_subnet.my-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

#8. assign an elastic ip to the network interface created in step 7
resource "aws_eip" "my-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.my-network-interface.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.my-gw]
}

#9. Create Ubuntu server and install/enable apache?
resource "aws_instance" "my-ubuntu-server" {
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "my-key-pair"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.my-network-interface.id
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install apache2 -y
            sudo systemctl start apache2
            sudo bash -c 'echo your very first web server > /var/www/html/index.html'
            EOF
  tags = {
    Name = "my-ubuntu"
  }
}