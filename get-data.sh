#!/bin/bash
ODIR="/tmp"
sudo mkdir /data 2>>/dev/null
if [ -d "/data" ]; then
        ODIR="/data"
fi
# use wget to download the files
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/movies.csv -O $ODIR/movies.csv
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/ratings2.csv -O $ODIR/ratings_s.csv
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/ratings.csv.gz -O $ODIR/ratings.csv.gz
sudo wget https://raw.githubusercontent.com/academyofdata/data/master/trx.csv.gz -O $ODIR/trx.csv.gz

sudo gunzip -f $ODIR/ratings.csv.gz
sudo gunzip -f $ODIR/trx.csv.gz
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/users.csv -O $ODIR/users.csv
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata.csv -O $ODIR/weatherdata.csv
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata-ext.csv -O $ODIR/weatherdata-ext.csv
sudo wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata-ext.csv -O $ODIR/weatherdata-ext.csv
