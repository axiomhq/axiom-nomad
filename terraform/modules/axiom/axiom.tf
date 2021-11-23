data "aws_vpc" "main" {
  default = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
  acl    = "private"
}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/templates/bucket_policy.tpl")}"
  vars     = {
    bucket = var.bucket
  }
}

resource "aws_iam_user" "bucket_user" {
  name = "${var.bucket}-user"
}

resource "aws_iam_access_key" "bucket_access_key" {
  user = aws_iam_user.bucket_user.name
}

resource "aws_iam_user_policy" "bucket_policy" {
  name   = "${var.bucket}-bucket-policy"
  user   = aws_iam_user.bucket_user.name
  policy = data.template_file.bucket_policy.rendered
}

resource "random_password" "postgres" {
  length           = 16
  special          = true
  override_special = "_-"
}

resource "aws_security_group" "postgres" {
  name        = "${var.name}-postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "Postgres from everywhere"
    from_port        = 5432
    to_port          = 5432
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
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 8
  engine                 = "postgres"
  engine_version         = "13"
  instance_class         = "db.t3.medium"
  name                   = "axiom"
  username               = "axiom"
  password               = random_password.postgres.result
  skip_final_snapshot    = true
  publicly_accessible    = true
  apply_immediately      = true
  vpc_security_group_ids = [aws_security_group.postgres.id]
}

output "postgres_url" {
  value = "postgres://axiom:${nonsensitive(random_password.postgres.result)}@${aws_db_instance.postgres.address}/axiom"
}

output "storage" {
  value = "s3://${aws_s3_bucket.bucket.id}/axiomdb?access_key=${urlencode(aws_iam_access_key.bucket_access_key.id)}&secret_key=${urlencode(nonsensitive(aws_iam_access_key.bucket_access_key.secret))}&region=${var.region}"
}