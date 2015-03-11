# mongos

## replicaset
```
rsconf = {
    _id: "rs0",
    members: [
        { _id: 0, host: "<hostname>:27017" },
        { _id: 1, host: "<hostname>:27017" },        
        { _id: 2, host: "<hostname>:27017" }
    ]
}
rs.initiate(cfg)
```

* configure_replicaset(node, name, members)

```
node:  member
{
    	“fqdn”: "192.168.0.1"
	mongodb:{
		config:{
			port: 20000,
		} 
		replica_arbiter_only: true,  
		replica_build_indexes: true,
		replica_hidden: true,
		replica_slave_delay: 0.0,
		replica_priority: 0, 
		replica_tags: {},
		votes: 1
	}
}

name: string

members: 
[
    {
    	“fqdn”: "192.168.0.1"
    	mongodb:{
    		config:{
    			port: 20000,
    		} 
    		replica_arbiter_only: true,  
    		replica_build_indexes: true,
    		replica_hidden: true,
    		replica_slave_delay: 0.0,
    		replica_priority: 0, 
    		replica_tags: {},
    		votes: 1
    	}
    }
]
```

## shardの追加
```
db.runCommand( { addShard: "repl0/mongodb3.example.net:27327"} )
```

* configure_shards(node, shard_nodes)

```
node:
{
    	fqdn: "192.168.0.1"
	mongodb:{
		config:{
			port: 20000,
		} 
	}
}

shard_nodes: 
[
{
	fqdn:"192.168.0.1"
	mongodb:{
		config:{
			port: 20000,
		} 
		shard_name
		recipes: [  mongodb::replicaset ] // ごまかし
	}
}
]
```

## shardCollectionsの追加
```
db.runCommand( { shardCollection: "records.people", key: { zipcode: 1 } } )
```

* configure_sharded_colections(node, sharded_collections)

```
node:
{
	“fqdn”
	mongodb:{
		config:{
			port: 20000,
		} 
	}
}

shaded_collections:
{
      "test.addressbook": "name",
      "mydatabase.calendar": "date"
}
```




