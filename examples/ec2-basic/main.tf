data "aws_vpc" "default" {
  count   = var.vpc_id == null ? 1 : 0
  default = true
}

data "aws_subnets" "default" {
  count = var.subnet_id == null ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id != null ? var.vpc_id : data.aws_vpc.default[0].id]
  }
}

locals {
  vpc_id    = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default[0].id
  subnet_id = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default[0].ids[0]
}

module "ec2" {
  source = "../../modules/ec2"

  name          = var.instance_name
  instance_type = var.instance_type
  vpc_id        = local.vpc_id
  subnet_id     = local.subnet_id

  associate_public_ip_address = true

  create_security_group = true
  security_group_ingress_rules = [
    {
      description = "Allow inbound HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl enable --now nginx
              echo "<h1>Welcome to AWS Terraform Modules - EC2 Basic Demo</h1>" > /usr/share/nginx/html/index.html
              EOF

  root_volume_size = 20
  root_volume_type = "gp3"

  tags = {
    Role = "web-demo"
  }
}
