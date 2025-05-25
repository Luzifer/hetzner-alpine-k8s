# Please see default.json for default values for these
variable "hostname" {}

packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }

    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

locals {
  timestamp   = formatdate("YYYYMMDD-hhmmss", timestamp())
  snapshot_id = sha1(uuidv4())
}

source "hcloud" "alpine" {
  location     = "fsn1"
  server_type  = "cpx11"
  image        = "ubuntu-20.04"
  rescue       = "linux64"
  ssh_username = "root"
}

build {
  name = "alpine"

  source "source.hcloud.alpine" {
    snapshot_name = "${var.hostname}-${local.timestamp}"
    snapshot_labels = {
      "alpine.pius.dev/timestamp"   = local.timestamp
      "alpine.pius.dev/snapshot-id" = local.snapshot_id
    }
  }

  provisioner "ansible" {
    extra_arguments = [
      "--scp-extra-args", "'-O'", # Required for OpenSSH >=9 (https://github.com/hashicorp/packer-plugin-ansible/issues/110)
      "--extra-vars", "@config.json",
    ]
    playbook_file   = "playbook.yml"
    user = "root"
  }
}
