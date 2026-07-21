data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type   # t3.micro — free-tier eligible
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.app_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.app.name

  # Free tier gives 30GB EBS total across all volumes — keep this modest.
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    environment   = var.environment
    db_secret_arn = var.db_secret_arn
  })

  tags = { Name = "${var.environment}-app" }
}

# Elastic IP so the address doesn't change on stop/start — free while
# attached to a running instance; AWS charges only if it's allocated but
# NOT attached, so don't release an instance without also releasing this.
resource "aws_eip" "app" {
  instance = aws_instance.app.id
  domain   = "vpc"
  tags     = { Name = "${var.environment}-app-eip" }
}