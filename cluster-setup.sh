
#execute this with a line similar with 
#wget -qO- https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/cluster-setup.sh | bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee -a /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-engine
sudo apt-get install -y python-pip
sudo pip install docker-compose
#add current user to docker group
sudo usermod -a -G docker `whoami`
#force reload of user groups
exec sudo su -l `whoami` 
wget https://raw.githubusercontent.com/academyofdata/cassandra-cluster/master/docker-compose.yml
#directory to persist node01 data between restarts
mkdir ./data
docker-compose up -d

