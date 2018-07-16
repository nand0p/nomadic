data_dir = "/home/ec2-user/nomad-data"

server {
  enabled = true
  bootstrap_expect = 3
}

client {
  enabled = false
}

consul {
  address = "localhost:8500"
}
