-- Create OpenEdX database
CREATE DATABASE IF NOT EXISTS openedx CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS edxapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS xqueue CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create database user with limited privileges (security best practice)
CREATE USER IF NOT EXISTS 'openedx_user'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON openedx.* TO 'openedx_user'@'%';
GRANT ALL PRIVILEGES ON edxapp.* TO 'openedx_user'@'%';
GRANT ALL PRIVILEGES ON xqueue.* TO 'openedx_user'@'%';

-- Create backup user
CREATE USER IF NOT EXISTS 'backup'@'%' IDENTIFIED BY '${BACKUP_PASSWORD}';
GRANT SELECT, RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'backup'@'%';

FLUSH PRIVILEGES;

-- Log initialization completion
SELECT 'OpenEdX MySQL database initialization completed successfully' AS Status;
