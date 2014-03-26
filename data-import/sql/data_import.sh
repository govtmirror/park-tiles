DATABASE_NAME=data_import

file_tbl_aggregated="./npmap_all_parks.sql"
file_tbl_aggregated_updates="./npmap_all_parks_updates.sql"
file_post_import="./tm2_post_import.sql"
file_empty_to_null="./empty_to_null.sql"
tbl_park_attributes=park_attributes
tbl_nps_regions=nps_regions
tbl_nps_boundary=irma_nps_boundaries
tbl_wsd_parks_poly=wsd_polys
tbl_wsd_parks_points=wsd_points
tbl_aggregated=npmap_all_parks
tbl_nps_visitors=park_visitors
func_f_empty_to_null=f_empty_to_null

psql_conn="host=localhost user=postgres password=postgres dbname=$DATABASE_NAME"


# Create the Database
echo "******** Create the Database ********"
sudo -u postgres dropdb $DATABASE_NAME
sudo -u postgres createdb -E UTF8 $DATABASE_NAME
sudo -u postgres createlang -d $DATABASE_NAME plpgsql
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE EXTENSION postgis;"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE EXTENSION postgis_topology;"

# Add the Park Attributes File
echo "******** Add the Park Attributes File ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/Park_Attributes_Cleaned.sqlite -nln $tbl_park_attributes
sudo -u postgres psql -d $DATABASE_NAME -c "ALTER TABLE "$tbl_park_attributes" ADD UNIQUE (alphacode);"
echo "Table $tbl_park_attributes created"

# Clean up the park attributes table
echo "******** Cleaning the Park Attributes File ********"
sudo -u postgres psql -d $DATABASE_NAME -f $file_empty_to_null
sudo -u postgres psql -d $DATABASE_NAME -c "SELECT * FROM "$func_f_empty_to_null"('"$tbl_park_attributes"');"
sudo -u postgres psql -d $DATABASE_NAME -c "DROP FUNCTION "$func_f_empty_to_null"(regclass);"
echo "Table $tbl_park_attributes cleaned"

# Add the regions geojson file
echo "******** Add the regions geojson file ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/nps-regions.geojson -nln $tbl_nps_regions -nlt MULTIPOLYGON -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX "$tbl_nps_regions"_gist ON $tbl_nps_regions USING GIST (wkb_geometry);"
echo "Table $tbl_nps_regions created"

# Add the wsd-all-parks
echo "******** Add the wsd-all-parks (polys) ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/WSD_Parks/WSDParks.gdb "ZoomLevel13Polys" -nln $tbl_wsd_parks_poly -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX "$tbl_wsd_parks_poly"_gist ON $tbl_wsd_parks_poly USING GIST (wkb_geometry);"
echo "Table $tbl_wsd_parks_poly created"

echo "******** Add the wsd-all-parks (points) ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/WSD_Parks/WSDParks.gdb "ZoomLevel4Points" -nln $tbl_wsd_parks_points -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX "$tbl_wsd_parks_points"_gist ON $tbl_wsd_parks_points USING GIST (wkb_geometry);"
echo "Table $tbl_wsd_parks_points created"

# Add the nps_boundary
echo "******** Add the nps_boundary ********"
ogr2ogr -f "PostgreSQL" PG:"$psql_conn" ../data/nps_boundary/nps_boundary.shp -nln $tbl_nps_boundary -nlt MULTIPOLYGON -t_srs EPSG:3857
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE INDEX "$tbl_nps_boundary"_gist ON $tbl_nps_boundary USING GIST (wkb_geometry);"
echo "Table $tbl_nps_boundary created"

# Add the Park Visitor Counts
# data_import.sh
echo "******** Add the nps_visitors boundary ********"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE TABLE $tbl_nps_visitors (name varchar, visitors numeric);"
sudo -u postgres psql -d $DATABASE_NAME -c "COPY $tbl_nps_visitors FROM '../data/park_visitors.csv' DELIMITER ',' CSV;"
echo "Table $tbl_nps_visitors created"


# Add the aggregated table
echo "******** Add the aggregated table ********"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE TABLE $tbl_aggregated AS `cat $file_tbl_aggregated`"
sudo -u postgres psql -d $DATABASE_NAME -c "ALTER TABLE "$tbl_aggregated" ADD CONSTRAINT "$tbl_aggregated"_pk PRIMARY KEY (unit_code);"
echo "Table $tbl_aggregated created"

# Run the park inset script
echo "******** Run the park inset script ********"
sudo -u postgres psql -d $DATABASE_NAME -f $file_post_import
echo "Park Inset Script Complete"
