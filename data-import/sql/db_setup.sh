DATABASE_NAME=data_import

# Convert the SQlite File
rm -f ../data/Park_Attributes.csv
ogr2ogr -f "CSV" ../data/Park_Attributes.csv ../data/Park_Attributes.sqlite
rm -f ../data/Park_Attributes_utf8.csv
iconv -f iso-8859-1 -t utf-8 ../data/Park_Attributes.csv > ../data/Park_Attributes_utf8.csv
rm ../data/Park_Attributes.csv

# Create the Database
sudo -u postgres dropdb $DATABASE_NAME
sudo -u postgres createdb -E UTF8 $DATABASE_NAME
sudo -u postgres createlang -d $DATABASE_NAME plpgsql
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE EXTENSION postgis_topology;"

# Add the SQlite File
sudo -u postgres psql -d $DATABASE_NAME -c 'CREATE TABLE park_attributes (alphacode varchar, pointtopol smallint, alpha char(4), designation varchar, name varchar, display_name varchar, display_designation varchar, display_concatenated varchar, display_state varchar, display_blurb varchar, display_url varchar, display_address varchar, display_phone varchar, display_climate varchar);'
sudo -u postgres psql -d $DATABASE_NAME -c "COPY park_attributes FROM '`pwd`/../data/Park_Attributes_utf8.csv' DELIMITER ',' CSV HEADER;"

# There's a weird UTF error with one record
#sudo -u postgres psql -d $DATABASE_NAME -c "UPDATE park_attributes SET display_climate = regexp_replace(display_climate, 'â' || U&'\0080' || U&'\0099', '&deg;', 'g') WHERE display_climate like '%â' || U&'\0080' || U&'\0099' || '%';"

# Add the regions geojson file
ogr2ogr -f "PostgreSQL" PG:"host=localhost user=postgres password=postgres dbname=data_import" ../data/nps-regions.geojson

# Add the wsd-all-parks  geojson file
# http://gis.stackexchange.com/questions/16340/alternatives-to-ogr2ogr-for-loading-large-geojson-files-to-postgis
rm -f ../data/wsd-parks-chunks-*
split -l 100 ../data/wsd-all-parks.geojson  ../data/wsd-parks-chunks-
echo '{"type":"FeatureCollection","features":[' > ../data/head
echo ']}' > ../data/tail
for f in ../data/wsd-parks-chunks-* ; do cat ../data/head $f ../data/tail > $f.json && rm -f $f ; done
for f in ../data/wsd-parks-chunks-*.json ; do ogr2ogr -f "PostgreSQL" PG:"host=localhost user=postgres password=postgres dbname=data_import" $f -append; done
