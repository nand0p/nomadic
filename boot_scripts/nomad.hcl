data_dir   = "/opt/nomad/data"
bind_addr  = "0.0.0.0"
datacenter = "dc-aws-001"


server {
  enabled          = true
  bootstrap_expect = 3
  #license_path    = "/etc/nomad.d/nomad.hcl"

  server_join {
    retry_join = [
      "NOMADIC_ONE_IP:4648",
      "NOMADIC_TWO_IP:4648",
      "NOMADIC_THREE_IP:4648"
    ]
  }
}


client {
  enabled = true
  servers = ["127.0.0.1"]
}
