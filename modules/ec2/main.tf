data "aws_ami" "amazon_linux_2023" {
  count       = var.ami_id == null ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_key_pair" "this" {
  count      = var.public_key != null ? 1 : 0
  key_name   = "${var.name}-keypair"
  public_key = var.public_key

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.name}-sg"
  description = "Security Group for ${var.name} EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress_rules
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress_rules
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      security_groups = egress.value.security_groups
    }
  }

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-sg"
      ManagedBy = "Terraform"
    }
  )
}

locals {
  security_group_ids = compact(concat(
    var.create_security_group ? [aws_security_group.this[0].id] : [],
    var.existing_security_group_ids
  ))
  ami_id   = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux_2023[0].id
  key_name = var.public_key != null ? aws_key_pair.this[0].key_name : var.key_name
}

resource "aws_instance" "this" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = local.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = local.key_name
  user_data                   = var.user_data
  monitoring                  = var.enable_detailed_monitoring

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    kms_key_id            = var.root_kms_key_id
    delete_on_termination = true

    tags = merge(
      var.tags,
      {
        Name = "${var.name}-root-ebs"
      }
    )
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.enable_imds_v2 ? "required" : "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tags = merge(
    var.tags,
    {
      Name      = var.name
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_ebs_volume" "additional" {
  count             = var.enable_additional_ebs_volume ? 1 : 0
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.additional_ebs_volume_size
  type              = var.additional_ebs_volume_type
  encrypted         = true
  kms_key_id        = var.additional_ebs_kms_key_id

  tags = merge(
    var.tags,
    {
      Name      = "${var.name}-ebs-data"
      ManagedBy = "Terraform"
    }
  )
}

resource "aws_volume_attachment" "this" {
  count       = var.enable_additional_ebs_volume ? 1 : 0
  device_name = var.additional_ebs_device_name
  volume_id   = aws_ebs_volume.additional[0].id
  instance_id = aws_instance.this.id
}
