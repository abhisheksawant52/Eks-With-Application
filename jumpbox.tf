# Use existing AWS Key Pair "Mindhacker"
data "aws_key_pair" "existing" {
  key_name = "Mindhacker"
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Jumpbox EC2 Instance
resource "aws_instance" "Abhishek-jumpbox" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public[0].id
  key_name                    = data.aws_key_pair.existing.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Jumpbox"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git curl unzip

              # Install kubectl (latest stable)
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

              # Install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install

              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

              # Create user Abhishek with password
              useradd Abhishek
              echo "Abhishek:Abhishek" | chpasswd
              usermod -aG wheel Abhishek

              # Enable password authentication for SSH
              sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd
              EOF
}