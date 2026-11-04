terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  bucket_name = "m324-semantic-mikeprobst"
}

# 1. Bucket erstellen
# Hinweis: aws_s3_bucket funktioniert im AWS Academy Lab nicht, weil eine
# Service Control Policy s3:GetBucketObjectLockConfiguration verbietet und der
# Provider diesen Aufruf nach dem Erstellen immer macht. Darum wird der Bucket
# hier ueber die AWS CLI erstellt - weiterhin automatisch bei "terraform apply".
resource "terraform_data" "bucket" {
  input = local.bucket_name

  provisioner "local-exec" {
    command = "aws s3api create-bucket --bucket ${self.input} --region us-east-1"
  }

  # Beim "terraform destroy" Bucket inkl. Inhalt loeschen
  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rb s3://${self.input} --force"
  }
}

# 2. Website-Hosting aktivieren
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = terraform_data.bucket.output

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# 3. Öffentlichen Zugriff erlauben (standardmässig blockiert)
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = terraform_data.bucket.output

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Policy: jeder darf die Dateien lesen
resource "aws_s3_bucket_policy" "frontend" {
  bucket     = terraform_data.bucket.output
  depends_on = [aws_s3_bucket_public_access_block.frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${terraform_data.bucket.output}/*"
      }
    ]
  })
}

# URL der Webseite ausgeben
output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"
}