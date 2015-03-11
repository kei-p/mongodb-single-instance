define :replicasets_setup,
     :action        => [:enable, :start],
     :notifies      => [] do

  ruby_block 'config_replicasets' do
    block do
      MongoDBSingle.configure_replicaset(node, node['mongod_single'])
    end
    action :run
  end

end
