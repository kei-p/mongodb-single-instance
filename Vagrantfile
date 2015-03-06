# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opscode-centos-6.5"
  config.omnibus.chef_version = :latest


  config.vm.define :mongo_shading_and_replica do |server|
    server.vm.network "private_network", ip: "192.168.33.10"
    server.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = %w[./berks-cookbooks ./cookbooks]
      chef.roles_path = "roles"
      chef.run_list = [
        "recipe[mongodb::shard]",
        "recipe[mongodb::replicaset]"
      ]
    end
  end

end
