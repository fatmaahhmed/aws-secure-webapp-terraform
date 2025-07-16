provider "aws" {
  region = "us-east-2"
}
module "remote_state" {
  source              = "./modules/remote_state"
  bucket_name         = "fatma-terraform-state-2025"
  dynamodb_table_name = "terraform-locks"
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "secure-webapp-vpc"
}
module "subnet" {
  source                = "./modules/subnet"
  vpc_id                = module.vpc.vpc_id
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                   = ["us-east-2a", "us-east-2b"]
}
module "igw" {
  source             = "./modules/igw"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnet.public_subnet_ids
  name               = "secure-webapp"
}
module "nat" {
  source              = "./modules/nat"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.subnet.public_subnet_ids[0] # نختار واحدة فقط
  private_subnet_ids  = module.subnet.private_subnet_ids
  name                = "secure-webapp"
}
resource "aws_security_group" "proxy_sg" {
  name        = "proxy-sg"
  description = "Allow HTTP/HTTPS from the internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # public internet
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "proxy-sg"
  }
}
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow HTTP from proxies only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy_sg.id] # Only from proxy SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg"
  }
}
resource "aws_security_group" "ssh_sg" {
  name        = "ssh-access"
  description = "Allow SSH only from my IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}
module "alb_proxy" {
  source             = "./modules/alb"
  name               = "proxy"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.subnet.public_subnet_ids
  security_group_id  = aws_security_group.proxy_sg.id  # ALB محتاج SG واحدة بس
  internal           = false
}

module "alb_backend" {
  source             = "./modules/alb"
  name               = "backend"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.subnet.private_subnet_ids
  security_group_id  = aws_security_group.backend_sg.id
  internal           = true
}

module "ec2_proxy" {
  source             = "./modules/ec2"
  name               = "proxy"
  ami_id             = data.aws_ami.ubuntu.id
  subnet_ids         = module.subnet.public_subnet_ids
  security_group_ids = [                          # ← دي بقت list
    aws_security_group.proxy_sg.id,
    aws_security_group.ssh_sg.id
  ]
  key_name           = "id_rsa"
  user_data          = file("scripts/install-nginx.sh")
  instance_count     = 2
  attach_to_alb      = true
  target_group_arn   = module.alb_proxy.target_group_arn
}

module "ec2_backend" {
  source             = "./modules/ec2"
  name               = "backend"
  ami_id             = data.aws_ami.ubuntu.id
  subnet_ids         = module.subnet.private_subnet_ids
  security_group_ids = [
    aws_security_group.backend_sg.id,
    aws_security_group.ssh_sg.id
  ]
  key_name           = "id_rsa"
  user_data = templatefile("${path.module}/scripts/install-nginx.tpl", {
    backend_alb_dns = module.alb_backend.alb_dns_name
  })

  instance_count     = 2
  attach_to_alb      = true
  target_group_arn   = module.alb_backend.target_group_arn
  
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}



