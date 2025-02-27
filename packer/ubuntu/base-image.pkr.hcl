packer {
  required_plugins {
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}
# Install mkisofs

source "qemu" "template" {
  vm_name   = "example-base-image-vm"
  cpus      = "2"
  memory    = "2048"
  disk_size = "20G"

  iso_url      = "https://cloud-images.ubuntu.com/jammy/20250225/jammy-server-cloudimg-amd64.img"
  iso_checksum = "sha256:7926d10e67a226a19028b9aa3977d7f99a23aef9b5ab326ae0ea142204a04c0d"

  communicator            = "ssh"
  ssh_timeout             = "1h"
  ssh_username            = "ubuntu"
  # ssh_port                = 8324
  skip_nat_mapping        = false
  pause_before_connecting = "5s"
  ssh_private_key_file    = "~/.ssh/id_rsa"

  output_directory = "output"

  boot_wait = "1m"

  accelerator = "kvm"

  format           = "qcow2"
  use_backing_file = false
  disk_image       = true
  disk_compression = true

  headless            = true
  use_default_display = false
  vnc_bind_address    = "127.0.0.1"

  cd_files = ["cloud-init/user-data", "cloud-init/meta-data", "cloud-init/network-config"]
  cd_label = "cidata"

  qemuargs = [
    ["-serial", "mon:stdio"],
  ]

  shutdown_command  = "sudo shutdown -P now"
}

build {
  sources = ["source.qemu.template"]

  # wait for cloud-init to successfully finish
  provisioner "shell" {
    inline = [
      "cloud-init status --wait > /dev/null 2>&1",
      "echo 'hello world' > test"
    ]
  }

  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
    user = "ubuntu"
    extra_arguments = [
      "-e",
      "ansible_python_interpreter=/usr/bin/python3"
    #   "-u ubuntu"
    ]
  }
}
