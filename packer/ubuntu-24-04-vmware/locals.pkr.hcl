locals {
  output_directory = "${path.root}/build"
  vagrant_box_name = "ubuntu-24-04-vmware.box"
  username         = "vagrant"
  password         = "vagrant"
  disk_size        = 20480
  memory           = 4096
  cpus             = 4
}
