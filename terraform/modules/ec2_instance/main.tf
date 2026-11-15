# A single EC2 instance on Amazon Linux 2023:
#   - security group: HTTP in from allowed_http_cidrs, all out; no SSH --
#     shell access is through SSM Session Manager
#   - IAM role with SSM access, plus read/write on an optional S3 bucket
#   - IMDSv2 only, encrypted gp3 root volume
#   - user_data installs nginx and serves a small status page
#
# instance_running = false stops the instance without destroying it.

data "aws_subnet" "this" {
  id = var.subnet_id
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-${var.architecture}"]
  }
}

# ---- Networking ----

resource "aws_security_group" "this" {
  name        = var.name
  description = "${var.name}: HTTP in, all out. No SSH; use SSM Session Manager."
  vpc_id      = data.aws_subnet.this.vpc_id

  tags = { Name = var.name }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each = toset(var.allowed_http_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "HTTP"
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ---- IAM ----

resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "bucket" {
  count = var.bucket_arn != null ? 1 : 0

  name = "bucket-access"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = var.bucket_arn
      },
      {
        Sid      = "ReadWriteObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "${var.bucket_arn}/*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
}

# ---- Instance ----

resource "aws_instance" "this" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    name        = var.name
    bucket_name = coalesce(var.bucket_name, "")
  })
  # cloud-init only runs user_data on first boot, so a changed script
  # needs a fresh instance to take effect.
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = { Name = var.name }

  lifecycle {
    # Don't replace the instance every time Amazon publishes a new AMI;
    # pick one up deliberately with `terraform apply -replace`.
    ignore_changes = [ami]
  }

  depends_on = [aws_iam_role_policy_attachment.ssm]
}

resource "aws_ec2_instance_state" "this" {
  instance_id = aws_instance.this.id
  state       = var.instance_running ? "running" : "stopped"
}
