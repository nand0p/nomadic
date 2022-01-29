ui = true

#license_path = "/etc/vault.d/vault.hclic"

#mlock = true

#disable_mlock = true

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault"
}

seal "awskms" {
  region = "us-east-1"
  kms_key_id = "VAULT_KMS_ID"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}

#listener "tcp" {
#  address       = "0.0.0.0:8200"
#  tls_enable    = 0
#  tls_cert_file = "/opt/vault/tls/tls.crt"
#  tls_key_file  = "/opt/vault/tls/tls.key"
#}

telemetry {
  statsite_address = "127.0.0.1:8125"
  disable_hostname = true
}
