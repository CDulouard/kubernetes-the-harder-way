source "vmware-iso" "ubuntu" {
  output_directory = local.output_directory
  iso_url          = "https://releases.ubuntu.com/24.04.2/ubuntu-24.04.2-live-server-amd64.iso"
  iso_checksum     = "sha256:d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
  headless         = true

  disk_size = local.disk_size
  memory    = local.memory
  cpus      = local.cpus

  shutdown_command = "echo '${local.password}' | sudo -S shutdown -P now"

  boot_wait               = "1m"
  pause_before_connecting = "30s"
  ssh_wait_timeout        = "5m"
  ssh_timeout             = "5m"
  ssh_read_write_timeout  = "5m"
  shutdown_timeout        = "2m"

  ssh_username           = local.username
  ssh_password           = local.password
  ssh_handshake_attempts = 1000

  boot_command = [
    "<enter><wait><enter><wait><enter><wait><enter><wait><enter><wait30><enter><wait><enter><wait><down><down><down><down><down><enter><wait><enter><wait><down><enter>",
    "${local.username}",
    "<enter>",
    "${local.username}",
    "<enter>",
    "${local.username}",
    "<enter>",
    "${local.password}",
    "<enter>",
    "${local.password}",
    "<enter>",
    "<enter><wait>",
    "<enter><wait>",
    "<enter><wait><down><down><enter><wait>",
    "<tab><enter><wait2m>",
    "<tab><tab><enter><wait20>",
    "<enter>"
  ]
}

build {
  sources = [
    "source.vmware-iso.ubuntu"
  ]

  provisioner "shell" {
    execute_command = "echo '${local.password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    script          = "./scripts/update.sh"
  }

  provisioner "shell" {
    execute_command = "echo '${local.password}' | sudo -S env {{ .Vars }} {{ .Path }}"
    script          = "./scripts/install.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "${local.output_directory}/${local.vagrant_box_name}"
    provider_override   = "vmware"
  }
}
