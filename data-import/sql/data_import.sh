DATABASE_NAME=data_import

file_tbl_aggregated="./npmap_all_parks.sql"
file_tbl_aggregated_updates="./npmap_all_parks_updates.sql"
file_post_import="./tm2_post_import.sql"
tbl_park_attributes=park_attributes
tbl_nps_regions=nps_regions
tbl_nps_boundary=irma_nps_boundaries
tbl_wsd_parks_poly=wsd_polys
tbl_wsd_parks_points=wsd_points
tbl_aggregated=npmap_all_parks

psql_conn="host=localhost user=postgres password=postgres dbname=$DATABASE_NAME"

# Convert the SQlite File
echo "******** Convert the SQlite File ********"
rm -f ../data/Park_Attributes.csv
ogr2ogr -f "CSV" ../data/Park_Attributes.csv ../data/Park_Attributes.sqlite
rm -f ../data/Park_Attributes_utf8.csv
iconv -f iso-8859-1 -t utf-8 ../data/Park_Attributes.csv > ../data/Park_Attributes_utf8.csv
rm ../data/Park_Attributes.csv

# Create the Database
echo "******** Create the Database ********"
sudo -u postgres dropdb $DATABASE_NAME
sudo -u postgres createdb -E UTF8 $DATABASE_NAME
sudo -u postgres createlang -d $DATABASE_NAME plpgsql
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE EXTENSION postgis_topology;"

# Add the Park Attributes File
echo "******** Add the Park Attributes File ********"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE TABLE $tbl_park_attributes (alphacode varchar, pointtopol smallint, alpha char(4), designation varchar, name varchar, display_name varchar, display_designation varchar, display_concatenated varchar, display_state varchar, display_blurb varchar, display_url varchar, display_address varchar, display_phone varchar, display_climate varchar);"
sudo -u postgres psql -d $DATABASE_NAME -c "COPY $tbl_park_attributes FROM '`pwd`/../data/Park_Attributes_utf8.csv' DELIMITER ',' CSV HEADER;"
rm ../data/Park_Attributes_utf8.csv
echo "Table $tbl_aggregated created"

# There's a weird UTF error with one record
#sudo -u postgres psql -d $DATABASE_NAME -c "UPDATE park_attributes SET display_climate = regexp_replace(display_climate, 'â' || U&'\0080' || U&'\0099', '&deg;', 'g') WHERE display_climate like '%â' || U&'\0080' || U&'\0099' || '%';"

# Add the regions geojson file
echo "******** Add the regions geojson file ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/nps-regions.geojson -nln $tbl_nps_regions -nlt MULTIPOLYGON -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX $tbl_nps_regions_gist ON $tbl_nps_regions USING GIST (wkb_geometry);"
echo "Table $tbl_nps_regions created"

# Add the wsd-all-parks
echo "******** Add the wsd-all-parks (polys) ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/WSD_Parks/WSDParks.gdb "ZoomLevel13Polys" -nln $tbl_wsd_parks_poly -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX $tbl_wsd_parks_poly_gist ON $tbl_wsd_parks_poly USING GIST (wkb_geometry);"
echo "Table $tbl_wsd_parks_poly created"

echo "******** Add the wsd-all-parks (points) ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/WSD_Parks/WSDParks.gdb "ZoomLevel4Points" -nln $tbl_wsd_parks_points -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX $tbl_wsd_parks_points_gist ON $tbl_wsd_parks_points USING GIST (wkb_geometry);"
echo "Table $tbl_wsd_parks_points created"

# Add the nps_boundary
echo "******** Add the nps_boundary ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/nps_boundary/nps_boundary.shp -nln $tbl_nps_boundary -nlt MULTIPOLYGON -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX $tbl_nps_boundary_gist ON $tbl_nps_boundary USING GIST (wkb_geometry);"
echo "Table $tbl_nps_boundary created"

# Add the aggregated table
echo "******** Add the aggregated table ********"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE TABLE $tbl_aggregated AS `cat $file_tbl_aggregated`"
sudo -u postgres psql -d $DATABASE_NAME -c "ALTER TABLE "$tbl_aggregated"_inset ADD CONSTRAINT "$tbl_aggregated"_pk PRIMARY KEY (unit_code);"
echo "Table $tbl_aggregated created"

# Run the park inset script
echo "******** Run the park inset script ********"
sudo -u postgres psql -d $DATABASE_NAME -f $file_post_import
echo "Park Inset Script Complete"
