#!/bin/bash
#just to be safe, try to install wget if not already installed
apt-get update
apt-get install -y wget
#now use wget to download the files
wget https://raw.githubusercontent.com/academyofdata/inputs/master/movies.csv -O /tmp/movies.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/ratings2.csv -O /tmp/ratings_s.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/ratings.csv.gz -O /tmp/ratings.csv.gz
gunzip /tmp/ratings.csv.gz
wget https://raw.githubusercontent.com/academyofdata/inputs/master/users.csv -O /tmp/users.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata.csv -O /tmp/weatherdata.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata-ext.csv -O /tmp/weatherdata-ext.csv
