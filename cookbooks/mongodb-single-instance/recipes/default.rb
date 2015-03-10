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

configsvr_instance node['mongodb']['instance_name'] do
  port 27200
end

mongod_instance node['mongodb']['instance_name'] do
  port 27300
  identifier 'sh0'
end

mongod_instance node['mongodb']['instance_name'] do
  port 27301
  identifier 'sh1'
end

mongod_instance node['mongodb']['instance_name'] do
  port 27302
  identifier 'sh2'
end
