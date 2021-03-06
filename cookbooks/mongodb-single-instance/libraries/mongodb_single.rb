#
# Cookbook Name:: mongodb
# Definition:: mongodb
#
# Copyright 2011, edelight GmbH
# Authors:
#       Markus Korn <markus.korn@edelight.de>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'json'

class Chef::ResourceDefinitionList::MongoDBSingle
  def self.configure_replicaset(node, mongod_single)
    require 'ostruct'
    p ">>>>>>>> replicasets"

    mongod_single['replicasets'].each do |replica|
        name = "rs_" + replica['name']

        primary = nil
        members = []
        replica["members"].each_with_index do |member, i|
          m = OpenStruct.new
          m.fqdn = node['fqdn']
          m.name = name + "-#{i}"
          mongodb = { "config" => { "port" => member["port"] } }
          ## options
          mongodb["replica_arbiter_only"] = true if member["opts"] &&  member["opts"]["arbiterOnly"]
          mongodb["replica_slave_delay"] =  member["opts"] &&  member["opts"]["slaveDelay"] ? member["opts"]["slaveDelay"] : 0
          mongodb["replica_tags"] =  member["opts"] &&  member["opts"]["replicaTags"] ? member["opts"]["replicaTags"] : {}
          mongodb["replica_votes"] =  member["opts"] &&  member["opts"]["votes"] ? member["opts"]["votes"] : 1
          mongodb["replica_build_indexes"] =  member["opts"] &&  member["opts"]["buildIndexes"] ? member["opts"]["buildIndexes"] : true
          mongodb["replica_priority"] =  member["opts"] &&  member["opts"]["priority"] ? member["opts"]["priority"] : 1

          m["mongodb"] = mongodb

          members << m
          primary = m if member['primary']
        end

      Chef::ResourceDefinitionList::MongoDB.configure_replicaset(primary, name, members)

    end

  end

  def self.configure_shards(node, mongod_single)
    require 'ostruct'
    p ">>>>>>>> shard"
    mongos = OpenStruct.new
    mongos.name = node.name
    mongos.fqdn = node["fqdn"]
    mongos.mongodb = {
      "config" => { "port" => mongod_single['mongos']['port'] }
    }

    shard_nodes = []
    mongod_single['replicasets'].each do |replica|
      name = replica['name']

      replica["members"].each_with_index do |member, i|
        n = {}
        n["fqdn"] = node["fqdn"]
        n["recipes"] = [ "mongodb::replicaset" ]
        mongodb = { "config" => { "port" => member["port"] } }
        mongodb["shard_name"] = name

        n["mongodb"] = mongodb

        shard_nodes << n
      end

      Chef::ResourceDefinitionList::MongoDB.configure_shards(mongos, shard_nodes)
    end

  end

  def self.configure_sharded_collections(node, mongod_single)
    require 'ostruct'
    p ">>>>>>>> shard collections"
    mongos = OpenStruct.new
    mongos.name = node.name
    mongos.fqdn = node["fqdn"]
    mongos.mongodb = {
      "config" => { "port" => mongod_single['mongos']['port'] }
    }

    collections = mongod_single['shard_collections']

    Chef::ResourceDefinitionList::MongoDB.configure_sharded_collections(mongos, collections)

  end

end
