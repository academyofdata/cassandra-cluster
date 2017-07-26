# Run a Cassandra node in a Docker container
run a standalone container with the following command (_replace /persistent/local/storage with an existing local path_)

```
docker run -d -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 -v /persistent/local/storage:/var/lib/cassandra --name csnd cassandra:2.2
```

# Simulate a Cassandra cluster with 3 Docker containers

On a "fresh" Debian based system run the following command

```
wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/cluster-setup.sh| bash -s
```

