# Tools

## Just

Most of the CLI tasks of the project are automated using [just](https://just.systems/man/en/).
It provides useful commands written in the `justfile` at the root of the project. You can list the available commands
by running `just --list` in a terminal.

## Packer

### Install

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
packer plugins install github.com/hashicorp/vmware
packer plugins install github.com/hashicorp/vagrant
sudo apt-get install open-vm-tools
```

## Vagrant

### Install

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

### Setup vmware plugin

```bash
vagrant plugin install vagrant-vmware-desktop
vagrant plugin update vagrant-vmware-desktop

# Download deb from https://developer.hashicorp.com/vagrant/install/vmware
sudo dpkg -i vagrant-vmware-utility_1.0.23-1_amd64.deb
sudo vmware-modconfig --console --install-all
```

### Fix the vmware utility service

Edit service file `sudo vim /usr/lib/systemd/system/vagrant-vmware-utility.service` and add
`-license-override professional` at the end of `ExecStart` line.

example:

```
[Unit]
Description=Vagrant VMware Utility
After=network.target

[Service]
Type=simple
ExecStart=/opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility api -config-file=/opt/vagrant-vmware-desktop/config/service.hcl -license-override professional
Restart=on-abort

[Install]
WantedBy=multi-user.target
```
restart the service:

```bash
sudo systemctl daemon-reload
sudo systemctl restart vagrant-vmware-utility
```

### Usage

```bash
vagrant up --provider vmware_desktop
vagrant destroy --provider vmware_desktop
```
