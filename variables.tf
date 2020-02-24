variable "aws_access_key" {
  description = "AWS access key" 
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key." 
  type        = string
}
variable "aws_region" {
  description = "The region of the bucket. (Examples are us-east-1, us-west-2, etc.)" 
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "The name of the bucket" 
  type        = string
}