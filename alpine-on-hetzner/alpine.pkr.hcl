# Please see default.json for default values for these
variable "apk_tools_url" {}
variable "apk_tools_arch" {}
variable "apk_tools_version" {}
variable "apk_tools_checksum" {}

variable "alpine_mirror" {}
variable "alpine_repositories" {}
variable "alpine_repository_keys" {}

variable "boot_size" {}
variable "root_size" {}
variable "hostname" {}
variable "dhcp_interfaces" {}

variable "packages" {}
variable "services" {}
variable "nameservers" {}
variable "extlinux_modules" {}
variable "kernel_features" {}
variable "kernel_modules" {}
variable "default_kernel_opts" {}
variable "sysctl" {}
variable "chroot_commands" {}

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
