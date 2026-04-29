# Specify the backend configuration for storing Terraform state files in S3.
terraform {
  # backend "s3" {
  #   # The S3 bucket where the Terraform state file will be stored.
  #   bucket         = "three-tier-devsecops-project-bucket-s3-gajksdghkjasdg"
  #   
  #   # The AWS region where the S3 bucket and DynamoDB table are located.
  #   region         = "ap-southeast-1"
  #   
  #   # The key (path) within the S3 bucket for storing the state file.
  #   key            = "three-tier-devsecops-project-bucket-s3-gajksdghkjasdg/jenkins-server-terraform/terraform.tfstate"
  #   
  #   # The DynamoDB table used for state locking to prevent concurrent state changes.
  #   dynamodb_table = "lock-files"
  #   
  #   # Ensures the state file is encrypted at rest in the S3 bucket.
  #   encrypt        = true
  # }

  # Local backend configuration - state file will be stored locally
  backend "local" {
    path = "terraform.tfstate"
  }
}
