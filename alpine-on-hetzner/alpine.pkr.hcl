# Please see default.json for default values for these
variable "hostname" {}

locals {
  timestamp   = formatdate("YYYYMMDD-hhmmss", timestamp())
  snapshot_id = sha1(uuidv4())
}

source "hcloud" "alpine" {
  location     = "fsn1"
  server_type  = "cx11"
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
    playbook_file   = "playbook.yml"
    extra_arguments = ["--extra-vars", "@config.json"]
  }
}
