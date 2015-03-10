
define :mongos_instance,
       :configdb => "",
       :action        => [:enable, :start],
       :notifies      => [] do

  provider = 'mongos'

  require 'ostruct'

  new_resource = OpenStruct.new

  new_resource.name                       = params[:name]
  new_resource.replicaset                 = params[:replicaset]
  new_resource.service_action             = params[:action]
  new_resource.service_notifies           = params[:notifies]

  new_resource.dbconfig_file_template     = node['mongodb']['dbconfig_file_template']
  identifier = params[:identifier]
  name = identifier ? 'mongos-%s' % identifier : 'mongos'
  new_resource.dbconfig_file              = '/etc/%s.conf' % name

  config = {}
  config['port'] = params[:port]
  config['logpath'] = '/var/log/mongodb/%s.log' % name
  config['pidfilepath'] = '/var/run/mongodb/%s.pid' % name
  config['configdb'] = params[:configdb]
  config['fork'] = true
  new_resource.config = config

  new_resource.logpath = config['logpath']

  new_resource.sysconfig_file             = node['mongodb']['sysconfig_file']
  new_resource.sysconfig_file_template    = node['mongodb']['sysconfig_file_template']

  new_resource.is_mongos                  = true

  new_resource.bind_ip                    = node['mongodb']['config']['bind_ip']
  new_resource.cluster_name               = node['mongodb']['cluster_name']
  new_resource.init_dir                   = node['mongodb']['init_dir']
  new_resource.init_script_template       = node['mongodb']['init_script_template']
  new_resource.mongodb_group              = node['mongodb']['group']
  new_resource.mongodb_user               = node['mongodb']['user']
  new_resource.replicaset_name            = node['mongodb']['config']['replSet']
  new_resource.root_group                 = node['mongodb']['root_group']
  new_resource.sysconfig_file             = node['mongodb']['sysconfig_file']
  new_resource.sysconfig_vars             = node['mongodb']['sysconfig']
  new_resource.template_cookbook          = node['mongodb']['template_cookbook']
  new_resource.ulimit                     = node['mongodb']['ulimit']
  new_resource.reload_action              = node['mongodb']['reload_action']

  if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
    new_resource.init_file = File.join(node['mongodb']['init_dir'], "%s.conf" % name  )
    mode = '0644'
  else
    new_resource.init_file = File.join(node['mongodb']['init_dir'], name)
    mode = '0755'
  end

  # default file
  template new_resource.sysconfig_file do
    cookbook new_resource.template_cookbook
    source new_resource.sysconfig_file_template
    group new_resource.root_group
    owner 'root'
    mode '0644'
    variables(
      :sysconfig => {
        DAEMON: '/usr/bin/mongos',
        DAEMON_USER: new_resource.user,
        DAEMON_OPTS: " --config #{new_resource.dbconfig_file}",
        CONFIGFILE: new_resource.dbconfig_file,
        ENABLE_MONGODB: "yes"
      }
    )
    notifies new_resource.reload_action, "service[#{new_resource.name}]"
  end

  # config file
  template new_resource.dbconfig_file do
    cookbook new_resource.template_cookbook
    source new_resource.dbconfig_file_template
    group new_resource.root_group
    owner 'root'
    variables(
      :config => new_resource.config
    )
    helpers MongoDBConfigHelpers
    mode '0644'
    notifies new_resource.reload_action, "service[#{new_resource.name}]"
  end

  # log dir [make sure it exists]
  if new_resource.logpath
    directory File.dirname(new_resource.logpath) do
      owner new_resource.mongodb_user
      group new_resource.mongodb_group
      mode '0755'
      action :create
      recursive true
    end
  end

  # Reload systemctl for RHEL 7+ after modifying the init file.
  execute 'mongodb-systemctl-daemon-reload' do
    command 'systemctl daemon-reload'
    action :nothing
  end

  # init script
  template new_resource.init_file do
    cookbook new_resource.template_cookbook
    source new_resource.init_script_template
    group new_resource.root_group
    owner 'root'
    mode mode
    variables(
      :provides =>       provider,
      :dbconfig_file  => new_resource.dbconfig_file,
      :sysconfig_file => new_resource.sysconfig_file,
      :ulimit =>         new_resource.ulimit,
      :bind_ip =>        new_resource.bind_ip,
      :port =>           new_resource.port
    )
    notifies new_resource.reload_action, "service[#{new_resource.name}]"

    if(platform_family?('rhel') && node['platform_version'].to_i >= 7)
      notifies :run, 'execute[mongodb-systemctl-daemon-reload]', :immediately
    end
  end

  # service
  service new_resource.name do
    provider Chef::Provider::Service::Upstart if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
    supports :status => true, :restart => true
    action new_resource.service_action
    new_resource.service_notifies.each do |service_notify|
      notifies :run, service_notify
    end
    notifies :create, 'ruby_block[config_replicaset]', :immediately
    notifies :create, 'ruby_block[config_sharding]', :immediately
    # we don't care about a running mongodb service in these cases, all we need is stopping it
    ignore_failure true if new_resource.name == 'mongodb'
  end

  # replicaset
  ruby_block 'config_replicaset' do
    block do
      MongoDBSingle.configure_replicaset(node, node['mongod_single'])
    end
    action :nothing
  end

  #shading
  ruby_block 'config_sharding' do
    block do
      MongoDBSingle.configure_shards(node, node['mongod_single'])
      MongoDBSingle.configure_sharded_collections(node, node['mongod_single'])
    end
    action :nothing
  end


end
