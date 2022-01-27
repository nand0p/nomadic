datacenter = "dc-001"

data_dir = "/opt/consul"

client_addr = "0.0.0.0"

ui = true

server = true

bind_addr = "0.0.0.0"

bootstrap_expect=3

encrypt = "CONSUL_ENCRYPTION_KEY"

retry_join = [
  "NOMADIC_ONE_IP",
  "NOMADIC_TWO_IP",
  "NOMADIC_THREE_IP"
]
 
#license_path = "/etc/consul.d/consul.hclic"
