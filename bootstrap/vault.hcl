ui = true
api_addr = "http://localhost:8200"
cluster_addr = "http://nomadic:8200"

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

seal "awskms" {
  region = "us-east-1"
  kms_key_id = "VAULT_KMS_ID"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

#mlock = true
#disable_mlock = true
#license_path = "/etc/vault.d/vault.hclic"
