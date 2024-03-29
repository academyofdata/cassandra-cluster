sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key A278B781FE4B2BDA
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key E91335D77E3E87CB
sudo apt-get update
sudo apt-get install --allow-unauthenticated -y cassandra cassandra-tools 
 

