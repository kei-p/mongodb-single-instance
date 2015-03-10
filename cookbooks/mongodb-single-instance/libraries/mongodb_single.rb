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
  def self.configure_replicaset(mongod_single)
    require 'ostruct'

    p ">>>>>>>> replica"

    # Chef::ResourceDefinitionList::MongoDB.configure_replicaset(nil,nil,nil)
  end

  def self.configure_shards(mongod_single)
    require 'ostruct'
    p ">>>>>>>> shard"
  end

  def self.configure_sharded_collections(mongod_single)
    require 'ostruct'
    p ">>>>>>>> shard collections"
  end

end
