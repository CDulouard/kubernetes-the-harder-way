PACKER_DIRECTORY := justfile_directory() / "packer"
VAGRANT_DIRECTORY := justfile_directory() / "vagrant"

[no-cd]
packer-build dir:
    cd {{PACKER_DIRECTORY}}/{{dir}} && rm -rf build && PACKER_LOG=1 packer build .
