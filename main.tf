locals  {
  s3_bucket_name = ["${var.bucket_name}", "${var.bucket_name}-stage"]
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region  # e.g. eu-west-1
}

resource "aws_iam_user" "bucket_user" {
   count = length(local.s3_bucket_name)
   name =  "${local.s3_bucket_name[count.index]}-user"
}

resource "aws_iam_access_key" "bucket_user" {
   count = length(local.s3_bucket_name)
   user =   element(aws_iam_user.bucket_user.*.name, count.index)
}

resource "aws_iam_user_policy" "bucket_user" {
    count =length(local.s3_bucket_name)
    name = "${local.s3_bucket_name[count.index]}-policy"
    user = element(aws_iam_user.bucket_user.*.name, count.index)
    policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name[count.index]}",
                "arn:aws:s3:::${local.s3_bucket_name[count.index]}/*"
            ]
        },
        {
            "Effect": "Deny",
            "NotAction": "s3:*",
            "NotResource": [
                "arn:aws:s3:::${local.s3_bucket_name[count.index]}",
                "arn:aws:s3:::${local.s3_bucket_name[count.index]}/*"
            ]
        }
   ]
}
EOF
}


# create log buckets
resource "aws_s3_bucket" "log_bucket" {
  count         =length(local.s3_bucket_name)
  bucket        = "${local.s3_bucket_name[count.index]}-logs"
  acl           = "log-delivery-write"
  force_destroy = "true"  
  cors_rule {
        allowed_headers = ["Authorization"]
        allowed_methods = ["GET"]
        allowed_origins = ["*"]
        max_age_seconds = 3000
    }
}

resource "aws_s3_bucket" "aws_bucket" {
  count         = length(local.s3_bucket_name)
  bucket        = local.s3_bucket_name[count.index]
  acl           = "private"
  cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT","POST","GET"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000
    }
     logging {
    target_bucket = element(aws_s3_bucket.log_bucket.*.id, count.index)
  }
 
  force_destroy = "true"
  versioning {
    enabled = true
  }
# Bucket policy
 policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${element(aws_iam_user.bucket_user.*.arn, count.index)}" 
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
           "Resource": [
                "arn:aws:s3:::${local.s3_bucket_name[count.index]}",
                "arn:aws:s3:::${local.s3_bucket_name[count.index]}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalArn": "${element(aws_iam_user.bucket_user.*.arn, count.index)}"
                }
            }
        }       
    ]
}
EOF
}


