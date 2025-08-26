# Create an EBS volume
resource "aws_ebs_volume" "app_volume" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp3"

  tags = {
    Name = "AppVolume"
  }
}

# Kubernetes Persistent Volume using EBS CSI
resource "kubernetes_persistent_volume" "app_pv" {
  metadata {
    name = "app-pv"
  }

  spec {
    capacity = {
      storage = "20Gi"
    }

    access_modes = ["ReadWriteOnce"]

    persistent_volume_source {
      csi {
        driver       = "ebs.csi.aws.com"
        volume_handle = aws_ebs_volume.app_volume.id
        fs_type      = "ext4"
      }
    }

    persistent_volume_reclaim_policy = "Retain"
  }
}