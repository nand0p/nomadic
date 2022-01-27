server {
  enabled = true
  bootstrap_expect = 3
  server_join {
    retry_join = [
      "{{ NOMADIC_ONE_IP }}:4648",
      "{{ NOMADIC_TWO_IP }}:4648",
      "{{ NOMADIC_THREE_IP }}:4648"
    ]
  }
}

client {
  enabled = true
}

consul {
  address = "localhost:8500"
}
