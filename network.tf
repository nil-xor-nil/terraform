# プロバイダー指定　AWSの東京リージョンを使用することを定義
provider "aws" {
  region = "ap-northeast-1"
}

# VPC作成
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform-handson-vpc"
  }
}

# インターネットゲートウェイ作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "terraform-handson-igw"
  }
}

# パブリックサブネットa作成 
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "terraform-handson-public-subnet-a"
  }
}

# パブリックサブネットc作成
resource "aws_subnet" "public_subnet_c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "terraform-handson-public-subnet-c"
  }
}

# プライベートサブネットa作成
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "terraform-handson-private-subnet-a"
  }
}

# プライベートサブネットc作成
resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "terraform-handson-private-subnet-c"
  }
}

# パブリックルートテーブル作成
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-handson-public-rt"
  }
}

# プライベートルートテーブル作成
resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "terraform-handson-private-rt"
  }
}

# パブリックルートテーブルa関連付け
resource "aws_route_table_association" "route_table_association_public_a" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.public_subnet_a.id
}

# パブリックルートテーブルc関連付け
resource "aws_route_table_association" "route_table_association_public_c" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.public_subnet_c.id
}

# プライベートルートテーブルa関連付け
resource "aws_route_table_association" "route_table_association_private_a" {
  route_table_id = aws_route_table.route_table_private.id
  subnet_id      = aws_subnet.private_subnet_a.id
}

# プライベートルートテーブルc関連付け
resource "aws_route_table_association" "route_table_association_private_c" {
  route_table_id = aws_route_table.route_table_private.id
  subnet_id      = aws_subnet.private_subnet_c.id
}
