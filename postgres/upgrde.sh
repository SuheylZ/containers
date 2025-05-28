#!/bin/bash

set -e

# Define directories
DATA_DIR="/var/data/postgres"
BACKUP_DIR="/var/data/postgres_backup"
PG15_DIR="/var/data/pg15"
PG17_DIR="/var/data/pg17"
UPGRADE_DIR="/var/data/pgupgrade"

# Step 1: Prepare directories
echo "Preparing directories..."
sudo mkdir -p "$PG15_DIR" "$PG17_DIR" "$UPGRADE_DIR" "$BACKUP_DIR"
sudo cp -r "$BACKUP_DIR"/. "$PG15_DIR/"
sudo chown -R 999:999 "$PG15_DIR" "$PG17_DIR" "$UPGRADE_DIR"

# Step 2: Run pg_upgrade
echo "Running pg_upgrade..."
docker-compose -f docker-compose.upgrade.yml run --rm pg_upgrade

# Step 3: Cleanup and restore data
echo "Cleaning up and restoring data..."
sudo rm -rf "$DATA_DIR"
sudo mv "$PG17_DIR" "$DATA_DIR"
sudo chown -R 999:999 "$DATA_DIR"

# Step 4: Adjust pg_hba.conf
echo "Adjusting pg_hba.conf..."
PG_HBA="$DATA_DIR/pg_hba.conf"
sudo sed -i '/^host\s\+all\s\+all\s\+127\.0\.0\.1\/32\s\+trust$/a host all all 0.0.0.0/0 md5' "$PG_HBA"

# Step 5: Start PostgreSQL and pgAdmin
echo "Starting PostgreSQL and pgAdmin..."
docker-compose -f docker-compose.pgsql.yml up -d

# Step 6: Reload PostgreSQL configuration
echo "Reloading PostgreSQL configuration..."
docker exec -it postgres psql -U postgres -c "SELECT pg_reload_conf();"

echo "PostgreSQL upgrade completed successfully."
