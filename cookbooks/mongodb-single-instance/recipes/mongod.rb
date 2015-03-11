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

node['mongod_single']['replicasets'].each do |replica|
  replica['members'].each_with_index do |member, i|

    rplc_name = "rs_" + replica["name"]
    id = rplc_name + "-#{i}"

    mongod_instance "mongod-#{id}" do
      port member['port']
      replicaset_name rplc_name
      opts member['opts']
      identifier id
    end

  end
end

