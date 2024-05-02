-- Table size
SELECT pg_size_pretty(pg_table_size('sensors.observations'));

-- Size of each index
SELECT 
  pg_size_pretty(pg_total_relation_size('sensors.observations_pkey')) as idx_1_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_location_id_datetime_idx')) as idx_2_size;

-- Indexes size
SELECT pg_size_pretty(pg_indexes_size('sensors.observations'));

-- All sizes table
SELECT 
  pg_size_pretty(pg_table_size('sensors.observations')) as table_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_pkey')) as idx_1_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_location_id_datetime_idx')) as idx_2_size,
  pg_size_pretty(pg_indexes_size('sensors.observations')) as indexes_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations')) as total_size;

-- Checking the table before update
SELECT *
FROM sensors.observations
ORDER BY id
LIMIT 10;

-- Updating distance values
UPDATE sensors.observations
SET distance = (distance * 3.281)
WHERE TRUE;

-- Checking the table after update
SELECT *
FROM sensors.observations
ORDER BY id
LIMIT 10;

-- Checking the sizes after update
SELECT 
  pg_size_pretty(pg_table_size('sensors.observations')) as table_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_pkey')) as idx_1_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_location_id_datetime_idx')) as idx_2_size,
  pg_size_pretty(pg_indexes_size('sensors.observations')) as indexes_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations')) as total_size;

-- Vacuuming the table
VACUUM sensors.observations;

-- Getting table size
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size;

-- Rows count before added information
SELECT COUNT(*) AS count_before_software_update
FROM sensors.observations
LIMIT 10;

-- Adding information
\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './additional_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

-- Rows count after added information
SELECT COUNT(*) AS count_after_software_update
FROM sensors.observations
LIMIT 10;

-- Getting table size after adding rows and vacuum
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size_vacuumed_and_updated;

-- Full vacuuming the table
VACUUM FULL sensors.observations;

-- Getting table size after full vacuum
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size_full_vacuumed;

-- Deletion of locations greater than 24
DELETE FROM sensors.observations
WHERE location_id > 24;

-- Getting table size after deletion
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size_after_deletion;

-- Truncating the table
TRUNCATE sensors.observations;

-- Adding informatio to the table (10000 rows)
\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './original_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

-- Adding additional 1000 rows
\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './additional_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

-- Getting table size after deletion
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size_after_adding_new_info;

-- Table's sizes after VACUUM FULL and TRUNCATE
SELECT 
  pg_size_pretty(pg_table_size('sensors.observations')) as table_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_pkey')) as idx_1_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_location_id_datetime_idx')) as idx_2_size,
  pg_size_pretty(pg_indexes_size('sensors.observations')) as indexes_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations')) as total_size;
