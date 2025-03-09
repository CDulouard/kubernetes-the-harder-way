PACKER_DIRECTORY_PATH := justfile_directory() / "packer"
VAGRANT_DIRECTORY_PATH := justfile_directory() / "vagrant"

DEFAULT_BUILD_DIRECTORY_NAME := "build"

[no-cd]
packer-build dir:
    #!/bin/bash
    cd {{PACKER_DIRECTORY_PATH}}/{{dir}} && rm -rf build && PACKER_LOG=1 packer build .

[no-cd]
add-box dir:
    #!/bin/bash
    export working_directory="{{PACKER_DIRECTORY_PATH}}/{{dir}}/{{DEFAULT_BUILD_DIRECTORY_NAME}}"
    cd "$working_directory"
    box_file=$(ls **.box)
    box_name="${box_file%.*}"
    vagrant box add "local/$box_name" "file://${working_directory}/${box_file}"
