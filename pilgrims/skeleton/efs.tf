resource "aws_efs_file_system" "skeleton_application" {
  count           = var.efs_enable ? 1 : 0
  throughput_mode = "bursting"
  encrypted       = true


  # use random value by default
  #creation_token = "skeleton_application_001"

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name = local.tags
  }
}
