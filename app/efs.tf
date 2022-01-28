resource "aws_efs_file_system" "nomadic_application" {

  #creation_token = "nomadic_application_001"
  # use random value by default

  throughput_mode = "bursting"

  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name = "nomadic_application_001"
  }
}
