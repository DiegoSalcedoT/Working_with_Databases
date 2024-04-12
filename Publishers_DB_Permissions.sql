-- check the superuser
SELECT rolname, rolsuper
FROM pg_roles
WHERE rolsuper = True;

-- check the permissions of a role
SELECT *
FROM pg_roles
WHERE rolsuper = True;

-- check the name of the current role
SELECT current_role;

CREATE ROLE abc_open_data WITH NOSUPERUSER;

CREATE ROLE publishers WITH NOSUPERUSER ROLE abc_open_data;

SELECT *
FROM pg_roles
WHERE rolname = 'abc_open_data';

GRANT USAGE ON SCHEMA analytics TO publishers;

GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO publishers;

SELECT * FROM information_schema.table_privileges
WHERE grantee = 'publishers';

SET ROLE abc_open_data;

SELECT * FROM analytics.downloads limit 10;

SET ROLE ccuser;

SELECT *
FROM directory.datasets LIMIT 10;

GRANT USAGE ON SCHEMA directory TO publishers;

GRANT SELECT (id, create_date, hosting_path, publisher, src_size) ON directory.datasets TO publishers;

SET ROLE abc_open_data;

SELECT id, publisher, hosting_path 
FROM directory.datasets
LIMIT 10;

SET ROLE ccuser;

CREATE POLICY privacy ON analytics.downloads
FOR SELECT TO publishers USING (owner = current_user);

ALTER TABLE analytics.downloads ENABLE ROW LEVEL SECURITY;

SELECT * FROM analytics.downloads limit 10;

SET ROLE abc_open_data;

SELECT * FROM analytics.downloads limit 10;

SET ROLE ccuser;
