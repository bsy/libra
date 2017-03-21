# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

VM_NAME = "libra_vm"
MEMORY_SIZE_MB = 4096
NUMBER_OF_CPUS = 2

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define "libra_box" do |libra_box|
    libra_box.vm.provider "virtualbox" do |v|
      v.name = VM_NAME
      v.customize ["modifyvm", :id, "--memory", MEMORY_SIZE_MB]
      v.customize ["modifyvm", :id, "--cpus", NUMBER_OF_CPUS]
    end
    libra_box.vm.network :forwarded_port, guest: 5432, host: 45432
    libra_box.vm.network :forwarded_port, guest: 4000, host: 4000
    libra_box.vm.provision :shell, :path => "scripts/vagrant_provision.sh"
  end
end
