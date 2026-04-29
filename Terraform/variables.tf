# Core Configuration

variable "region" {
  description = "The AWS region to create resources in."
  default     = "ap-southeast-1"
}

# Networking Configuration

variable "vpc_name" {
  description = "The name of the VPC."
  default     = "devops-vpc"
}

variable "igw_name" {
  description = "The name of the Internet Gateway."
  default     = "devops-igw"
}

variable "subnet_name" {
  description = "The name of the subnet."
  default     = "devops-subnet"
}

variable "route_table_name" {
  description = "The name of the route table."
  default     = "devops-route-table"
}

# Security

variable "security_group_name" {
  description = "The name of the security group."
  default     = "devops-sg"
}

# Instance Configuration

variable "instance_name" {
  description = "The name of the EC2 instance."
  default     = "devops-server"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t3.small"
}

variable "instance_type_nexus" {
  description = "Type of Nexus EC2 instance"
  default     = "c7i-flex.large"
}

variable "ebs_volume" {
  description = "EBS Volume Size"
  default     = 30
}


# Key Pair

variable "key_name" {
  description = "The name of the SSH key pair to access the instance."
  default     = "elvin-poc-keypair"
}

# IAM Role

variable "iam_role_name" {
  description = "The IAM role name for jenkins instance."
  default     = "jenkins-server-iam-role"
}

#eks

variable "eks_node_instance_types" {
  default = ["t3.small"]
}