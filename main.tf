#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "tfseclint" {
  bucket = "tfstategithubactions123"
}

resource "aws_s3_bucket_ownership_controls" "tfseclint" {
  bucket = aws_s3_bucket.tfseclint.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tfseclint" {
  depends_on = [aws_s3_bucket_ownership_controls.tfseclint]

  bucket = aws_s3_bucket.tfseclint.id
  acl    = "private"
}

# resource "aws_s3_bucket_public_access_block" "tfseclint" {
#   bucket = aws_s3_bucket.tfseclint.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

resource "aws_s3_bucket_versioning" "versioning_tfseclint" {
  bucket = aws_s3_bucket.tfseclint.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "tfseclintkey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfseclint" {
  bucket = aws_s3_bucket.tfseclint.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfseclintkey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}