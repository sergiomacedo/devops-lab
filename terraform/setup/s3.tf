resource "aws_s3_bucket" "tf_states" {
  bucket              = "my_company_terraform_states"
  object_lock_enabled = true

  tags = {
    Name = "S3 Remote Terraform State Store"
  }

}

# Server-Side Encryption Configuration (replaces the deprecated block)
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_states" {
  bucket = aws_s3_bucket.tf_states.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_versioning" "bucket_versioning_tf_states" {
  bucket = aws_s3_bucket.tf_states.id
  # Versioning may be enabled for disaster recovery
  versioning_configuration {
    status = "Disabled"
  }
}
