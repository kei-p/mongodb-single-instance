#
# Cookbook Name:: mongo_on_single_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mongodb::install'
include_recipe 'mongodb::mongo_gem'

configsvr_instance "configsvr" do
  port node['mongod_single']['configsvr']['port']
end

node['mongod_single']['replicasets'].each do |replica|
  replica['members'].each_with_index do |member, i|

    id = "rs_" + replica['name'] + "-#{i}"

    mongod_instance "mongod-#{id}" do
      port member['port']
      opts member['opts']
      identifier id
    end

  end
end

mongos_instance "mongos" do
  port node['mongod_single']['mongos']['port']
  configdb "localhost:#{node['mongod_single']['configsvr']['port']}"
end
