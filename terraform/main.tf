resource "random_pet" "nomad" {
  length = 1
}

provider "aws" {
  region = var.region
}

module "axiom" {
  source = "./modules/axiom"

  name   = "${var.name}-${random_pet.nomad.id}"
  region = var.region
  bucket = var.bucket
}

module "hashistack" {
  source = "./modules/hashistack"

  name                   = "${var.name}-${random_pet.nomad.id}"
  region                 = var.region
  ami                    = var.ami
  server_instance_type   = var.server_instance_type
  client_instance_type   = var.client_instance_type
  key_name               = var.key_name
  server_count           = var.server_count
  client_count           = var.client_count
  retry_join             = var.retry_join
  nomad_binary           = var.nomad_binary
  root_block_device_size = var.root_block_device_size
  allowlist_ip           = var.allowlist_ip
}
