#
# Cookbook Name:: mongo_on_single_server
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


configsvr_instance "configsvr" do
  port node['mongod_single']['configsvr']['port']
end
