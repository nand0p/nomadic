storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "VAULT_KMS_ID"
}

listener "tcp" {
  address       = "127.0.0.1:8200"
  cluster_addr  = "127.0.0.1:8201"
  tls_disable   = false
  tls_cert_file = "/opt/vault/tls/tls.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
}

ui            = true
disable_mlock = false
api_addr      = "http://127.0.0.1:8200"
cluster_addr  = "http://127.0.0.1:8201"
#license_path = "/etc/vault.d/vault.hclic"
