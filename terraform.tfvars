tags = {
  CICD = "manual"
}

stack_name = "nomadic"
environment = "production"
aws_profile = "nomadic"
aws_region = "us-east-1"
timestamp = "January2022"
root_volume_type = "standard"
root_volume_size = "20"
nomadic_instance_size = "t3a.nano"
key_name = "nomadic"
dns_hosted_zone_id = "Z03644112ITLCJM3OXQB0"
allow_public_ip = true
trusted_cidrs = [
  "69.113.180.153/32",
  "65.78.22.167/32"
]

nomadic_vpc_cidr = "192.168.212.0/22"
nomadic_subnet_cidr_one = "192.168.212.0/24"
nomadic_subnet_cidr_two = "192.168.213.0/24"
nomadic_subnet_cidr_three = "192.168.214.0/24"

nomadic_cluster_ip_one = "192.168.212.99"
nomadic_cluster_ip_two = "192.168.213.99"
nomadic_cluster_ip_three = "192.168.214.99"

nomadic_availability_zone_one = "us-east-1a"
nomadic_availability_zone_two = "us-east-1f"
nomadic_availability_zone_three = "us-east-1c"

# following below must be set empty to force resource creation
# otherwise, these can be set to existing values
nomadic_vpc_id = ""
nomadic_subnet_id_one = ""
nomadic_subnet_id_two = ""
nomadic_subnet_id_three = ""
nomadic_instance_profile_name = ""
nomadic_security_group_id = ""
nomadic_ami_id = ""
