#!/bin/bash
ODIR="/tmp"
mkdir /data 2>>/dev/null
if [ -d "/data" ]; then
        ODIR="/data"
fi
# use wget to download the files
wget https://raw.githubusercontent.com/academyofdata/inputs/master/movies.csv -O $ODIR/movies.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/ratings2.csv -O $ODIR/ratings_s.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/ratings.csv.gz -O $ODIR/ratings.csv.gz
gunzip -f $ODIR/ratings.csv.gz
wget https://raw.githubusercontent.com/academyofdata/inputs/master/users.csv -O $ODIR/users.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata.csv -O $ODIR/weatherdata.csv
wget https://raw.githubusercontent.com/academyofdata/inputs/master/weatherdata-ext.csv -O $ODIR/weatherdata-ext.csv
