##############################################
## EKS Cluster
##############################################

resource "aws_eks_cluster" "devops" {
  name     = "devops-cluster"
  role_arn = aws_iam_role.devops_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.public-subnet[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

##############################################
## EKS Node Group
##############################################

resource "aws_eks_node_group" "devops" {
  cluster_name    = aws_eks_cluster.devops.name
  node_group_name = "devops-node-group"
  node_role_arn   = aws_iam_role.devops_node_group_role.arn
  subnet_ids      = aws_subnet.public-subnet[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = var.eks_node_instance_types

  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = [aws_security_group.eks_node_sg.id]
  }
}

##############################################
## IAM Roles - EKS Cluster
##############################################

resource "aws_iam_role" "devops_cluster_role" {
  name = "devops-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "devops_cluster_role_policy" {
  role       = aws_iam_role.devops_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

##############################################
## IAM Roles - EKS Node Group
##############################################

resource "aws_iam_role" "devops_node_group_role" {
  name = "devops-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "devops_node_group_role_policy" {
  role       = aws_iam_role.devops_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "devops_node_group_cni_policy" {
  role       = aws_iam_role.devops_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "devops_node_group_registry_policy" {
  role       = aws_iam_role.devops_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

output "cluster_id" {
  value = aws_eks_cluster.devops.id
}

output "node_group_id" {
  value = aws_eks_node_group.devops.id
}