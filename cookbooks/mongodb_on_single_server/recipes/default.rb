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

mongod_instance node['mongodb']['instance_name'] do
  mongodb_type 'mongod'
  port 27300
  identifier 'sh0'
  replicaset   node
  enable_rest  node['mongodb']['config']['rest']
  smallfiles   node['mongodb']['config']['smallfiles']
end

mongod_instance node['mongodb']['instance_name'] do
  mongodb_type 'mongod'
  port 27301
  identifier 'sh1'
  replicaset   node
  enable_rest  node['mongodb']['config']['rest']
  smallfiles   node['mongodb']['config']['smallfiles']
end

mongod_instance node['mongodb']['instance_name'] do
  mongodb_type 'mongod'
  port 27302
  identifier 'sh2'
  replicaset   node
  enable_rest  node['mongodb']['config']['rest']
  smallfiles   node['mongodb']['config']['smallfiles']
end