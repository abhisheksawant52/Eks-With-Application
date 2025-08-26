# EKS MediaWiki Deployment Project

This project provisions a **production-ready AWS EKS cluster** with a **jumpbox**, **persistent storage**, **external load balancer**, and deploys **MediaWiki** with **MariaDB** using Terraform and Kubernetes.

---

## Project Overview

| Component           | Description |
|--------------------|-------------|
| **VPC**             | Custom VPC with public and private subnets for EKS and jumpbox. |
| **Jumpbox EC2**     | Public EC2 instance with full internet access for cluster management; pre-installed latest `kubectl`, `helm`, and AWS CLI. |
| **EKS Cluster**     | Kubernetes cluster in private subnets with external access enabled. |
| **Node Group**      | Managed Node Group with scalable `t3.medium` instances, 50GB disk, and proper IAM roles. |
| **Persistent Storage** | EBS volumes attached to Kubernetes Persistent Volumes (using AWS CSI). |
| **Load Balancer**   | External NLB exposing MediaWiki to the internet. |
| **Applications**    | MediaWiki (PHP application) and MariaDB (database). |

---

## Pre-requisites

- Terraform >= 1.5  
- AWS CLI >= 2.x  
- SSH key pair for jumpbox  
- Kubectl installed locally (optional, jumpbox also works)  

---

## Setup Instructions

### 1. Configure AWS CLI
```bash
aws configure
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Plan Terraform Deployment
```bash
terraform plan
```

### 4. Apply Terraform Deployment
```bash
terraform apply
```

This will create:  
- VPC, subnets, NAT, Internet Gateway  
- EKS cluster + node group  
- Jumpbox EC2 instance  
- EBS volumes and PV  
- External load balancer ready for applications  

---

## Jumpbox User Information

When the infrastructure is provisioned, the Terraform script also creates a **jumpbox EC2 instance** with a pre-configured user:

- **Username:** `Abhishek`  
- **Password:** `Abhishek`  
- **Privileges:** sudo enabled (part of `wheel` group)  
- **Tools Installed:**  
  - `kubectl` (latest stable)  
  - `helm` (latest stable)  
  - `awscli v2`  
  - `git`, `curl`, `unzip`  

### Connecting to the Jumpbox

You can connect in two ways:

**Using SSH key (recommended):**
```bash
ssh -i ~/.ssh/id_rsa ec2-user@<jumpbox_public_ip>


### 5. Configure Kubernetes Provider
```bash
aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster
```

### 6. Deploy Applications

**MariaDB**
```bash
kubectl apply -f mediawiki/mariadb-deployment.yaml
```

**MediaWiki**
```bash
kubectl apply -f mediawiki/mediawiki-deployment.yaml
```

### 7. Access MediaWiki
```bash
kubectl get svc mediawiki
```

Open the EXTERNAL-IP in your browser to access MediaWiki.

---

## Features

- Jumpbox with latest tools (`kubectl`, `helm`, `AWS CLI`).  
- Fully internet-accessible MediaWiki using NLB.  
- Persistent database storage via EBS + CSI driver.  
- Scalable node group to handle application load.  
- IaC-managed environment using Terraform.  

---

## References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)  
- [EKS Terraform Docs](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)  
- [Kubernetes EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)  
- [MediaWiki Docker Image](https://hub.docker.com/_/mediawiki)  
- [MariaDB Docker Image](https://hub.docker.com/_/mariadb)  