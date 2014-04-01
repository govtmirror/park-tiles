tbl_rendering=park_rendering_fields
file_tbl_rendering=`pwd`"/views/park_rendering.sql"

echo "******** Rendering Tasks ********"

echo "******** Create the rendering table ********"
sudo -u postgres psql -d $DATABASE_NAME -c "CREATE TABLE $tbl_rendering AS `cat $file_tbl_rendering`"
sudo -u postgres psql -d $DATABASE_NAME -c "ALTER TABLE "$tbl_rendering" ADD CONSTRAINT "$tbl_rendering"_pk PRIMARY KEY (park_name);"
echo "Table $tbl_rendering created"
