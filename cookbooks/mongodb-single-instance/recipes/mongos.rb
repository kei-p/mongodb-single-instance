# Cookbook Name:: mongo_on_single_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

mongos_instance "mongos" do
  port node['mongod_single']['mongos']['port']
  configdb "localhost:#{node['mongod_single']['configsvr']['port']}"
end
