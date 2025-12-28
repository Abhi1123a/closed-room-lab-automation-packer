packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = ">= 1.0.0"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
  }
}


source "vmware-iso" "rocky9" {
    vm_name        = var.vm_name
    iso_url        = var.iso_path
    iso_checksum   = "none"

    communicator   = "ssh"
    ssh_username   = var.ssh_username
    ssh_password   = var.ssh_password
    ssh_timeout    = "30m"

    disk_size      = 40000
    memory         = 4096
    cpus           = 2

    network        = "hostonly"

    cd_files       = ["ks.cfg"]
    cd_label       = "OEMDRV"

    boot_wait = "5s"
    boot_command = [
      "<esc><wait3>",
      "<tab>",
      " inst.ks=cdrom:/ks.cfg<enter>"
    ]

    shutdown_command = "sudo shutdown -h now"
}

build {
    sources = ["source.vmware-iso.rocky9"]
    
    # Ensure destination exists inside VM
    provisioner "shell" {
        inline = [
            "sudo mkdir -p /opt/ansible"
        ]
    }

    # Copy Ansible content from Windows → VM
    provisioner "file" {
        source      = "ansible/"
        destination = "/opt/ansible"
    }

    # Run Ansible locally inside the VM
    provisioner "ansible-local" {
        playbook_file = "ansible/playbooks/site.yml"
        command       = "ANSIBLE_FORCE_COLOR=1 ansible-playbook"
    }
}
