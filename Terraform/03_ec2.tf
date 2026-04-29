
## Key Pair

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

## Jenkis Server
# AWS EC2 instance resource definition
resource "aws_instance" "ec2" {
  # Use the dynamically retrieved AMI ID from the AWS AMI data source
  ami                    = data.aws_ami.ami.image_id
  
  # Instance type for the EC2 instance, parameterized for flexibility
  instance_type          = var.instance_type  # parameterized for flexibility
  
  # The key pair name for SSH access to the instance
  key_name               = aws_key_pair.ec2_key_pair.key_name
  
  # Subnet ID where the EC2 instance will be launched (usually public subnet)
  subnet_id              = aws_subnet.public-subnet[0].id
  
  # Security group IDs to control inbound and outbound traffic
  vpc_security_group_ids = [aws_security_group.security-group.id]
  
  # IAM instance profile to attach policies to the EC2 instance
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  
  # Root block device configuration, setting the volume size to 30 GB
  root_block_device {
    volume_size = var.ebs_volume
  }
  
  # User data script executed on instance launch
  user_data = templatefile("./scripts/tools-install.sh", {})

  tags = {
    Name = "Jenkins-Master"
  }
}

## SonarCube Server
resource "aws_instance" "ec2_sonarcube" {
  # Use the dynamically retrieved AMI ID from the AWS AMI data source
  ami                    = data.aws_ami.ami.image_id
  
  # Instance type for the EC2 instance, parameterized for flexibility
  instance_type          = var.instance_type_nexus 
  
  # The key pair name for SSH access to the instance
  key_name               = aws_key_pair.ec2_key_pair.key_name
  
  # Subnet ID where the EC2 instance will be launched (usually public subnet)
  subnet_id              = aws_subnet.public-subnet[0].id
  
  # Security group IDs to control inbound and outbound traffic
  vpc_security_group_ids = [aws_security_group.security-group.id]
  
  # IAM instance profile to attach policies to the EC2 instance
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  
  # Root block device configuration, setting the volume size to 30 GB
  root_block_device {
    volume_size = var.ebs_volume
  }
  
  # User data script executed on instance launch
  user_data = templatefile("./scripts/tools-install-sonarcube.sh", {})

  tags = {
    Name = "Sonarcube"
  }
}


## Nexus Server
resource "aws_instance" "ec2_nexus" {
  # Use the dynamically retrieved AMI ID from the AWS AMI data source
  ami                    = data.aws_ami.ami.image_id
  
  # Instance type for the EC2 instance, parameterized for flexibility
  instance_type          = var.instance_type_nexus
  
  # The key pair name for SSH access to the instance
  key_name               = aws_key_pair.ec2_key_pair.key_name
  
  # Subnet ID where the EC2 instance will be launched (usually public subnet)
  subnet_id              = aws_subnet.public-subnet[0].id
  
  # Security group IDs to control inbound and outbound traffic
  vpc_security_group_ids = [aws_security_group.security-group.id]
  
  # IAM instance profile to attach policies to the EC2 instance
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  
  # Root block device configuration, setting the volume size to 30 GB
  root_block_device {
    volume_size = var.ebs_volume
  }
  
  # User data script executed on instance launch
  user_data = templatefile("./scripts/tools-install-nexus.sh", {})

  tags = {
    Name = "Nexus"
  }
}


# Outputs to access instance details after creation
output "Jenkins_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "Sonarcube_public_ip" {
  value = aws_instance.ec2_sonarcube.public_ip
}

output "Nexus_public_ip" {
  value = aws_instance.ec2_nexus.public_ip
}
