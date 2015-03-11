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
        "recipe[mongodb-single-instance::mongod]",
        "recipe[mongodb-single-instance::replica]",
        "recipe[mongodb-single-instance::configsvr]",
        "recipe[mongodb-single-instance::mongos]"
      ]
      chef.json = {
        mongod_single: {
          mongos: {
            port: 27100,
            chunkSize: 1
          },
          configsvr: {
            port: 27101
          },
          replicasets: [
            {
              name: "sh0",
              members: [
                { port: 27200, opts: { arbiterOnly: true } },
                { port: 27201, primary: true },
                { port: 27202 },
                { port: 27203 }
              ]
            },
            {
              name: "sh1",
              members: [
                { port: 27210, opts: { arbiterOnly: true } },
                { port: 27211, primary: true },
                { port: 27212 },
                { port: 27213 }
              ]
            },
            {
              name: "sh2",
              members: [
                { port: 27220, opts: { arbiterOnly: true } },
                { port: 27221, primary: true },
                { port: 27222 },
                { port: 27223 }
              ]
            }
          ],
          shard_collections: {
            "test.addressbook" => "name",
            "mydatabase.calendar" => "date"
          }
        }
      }
    end
  end

  # config.vm.define :mongo_config do |server|
  #   server.vm.network "private_network", ip: "192.168.33.100"
  #   server.vm.provision "chef_solo" do |chef|
  #     chef.cookbooks_path = %w[./berks-cookbooks ./cookbooks]
  #     chef.roles_path = "roles"
  #     chef.run_list = [
  #       "recipe[mongodb::configserver]"
  #     ]
  #     chef.json = {
  #       mongodb: {
  #         cluster_name: "cluster",
  #       }
  #     }
  #   end
  # end
  #
  # config.vm.define :mongos do |server|
  #   server.vm.network "private_network", ip: "192.168.33.110"
  #   server.vm.provision "chef_solo" do |chef|
  #     chef.cookbooks_path = %w[./berks-cookbooks ./cookbooks]
  #     chef.roles_path = "roles"
  #     chef.run_list = [
  #       "recipe[mongodb::mongos]",
  #     ]
  #     chef.json = {
  #       mongodb: {
  #         cluster_name: "cluster",
  #         replica_aribiter_only: true,
  #         shareded_collections: {},
  #         config: {
  #           configdb: {}
  #         },
  #         auto_configure: {
  #           replicaset: false,
  #           sharding: false
  #         }
  #       }
  #     }
  #   end
  # end
  #
  # (1..9).each do |i|
  #   name = "mongod%d" % i
  #   ip = "192.168.33.%d" % (110 + i)
  #   config.vm.define name.to_sym do |server|
  #     server.vm.network "private_network", ip: ip
  #     server.vm.provision "chef_solo" do |chef|
  #       chef.cookbooks_path = %w[./berks-cookbooks ./cookbooks]
  #       chef.roles_path = "roles"
  #       chef.run_list = [
  #         "recipe[mongodb::shard]",
  #         "recipe[mongodb::replicaset]"
  #       ]
  #       chef.json = {
  #         mongodb: {
  #           cluster_name: "cluster",
  #         }
  #       }
  #     end
  #   end
  # end


end
