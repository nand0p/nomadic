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

ui = true
#mlock = true
#disable_mlock = true
#license_path = "/etc/vault.d/vault.hclic"
