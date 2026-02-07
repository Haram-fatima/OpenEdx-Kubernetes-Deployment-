#!/bin/bash
# Database Initialization Script for OpenEdX
# Assessment: Database initialization and configuration

echo "🔧 Initializing OpenEdX Databases..."

# MySQL Initialization
echo "🗄️  Setting up MySQL database..."
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS openedx;
CREATE USER IF NOT EXISTS 'openedx_user'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON openedx.* TO 'openedx_user'@'%';
FLUSH PRIVILEGES;
EOF

echo "✅ MySQL initialization complete"

# MongoDB Initialization
echo "📄 Setting up MongoDB collections..."
mongosh "mongodb+srv://$MONGODB_USER:$MONGODB_PASSWORD@$MONGODB_HOST/openedx" <<EOF
db.createCollection('courses');
db.createCollection('users');
db.createCollection('sessions');
EOF

echo "✅ MongoDB initialization complete"

echo "🎯 All databases initialized successfully!"
