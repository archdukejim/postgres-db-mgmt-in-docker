#!/bin/bash

# Configuration - Change this to match your container name
CONTAINER_NAME="postgres_db_1"
POSTGRES_USER="postgres"

# Helper function to prompt for missing values
get_input() {
    local var_name=$1
    local prompt=$2
    local is_password=$3
    
    if [ -z "${!var_name}" ]; then
        if [ "$is_password" = "true" ]; then
            read -rs -p "$prompt: " input
            echo "" # New line after hidden input
        else
            read -p "$prompt: " input
        fi
        eval "$var_name=\"$input\""
    fi
}

create_db_and_user() {
    get_input DB_NAME "Enter new database name"
    get_input NEW_USER "Enter new username"
    get_input NEW_PASS "Enter password for $NEW_USER" "true"

    echo "Creating database '$DB_NAME' and user '$NEW_USER'..."
    
    # 1. Create the User
    docker exec -u "$POSTGRES_USER" "$CONTAINER_NAME" psql -c "CREATE USER $NEW_USER WITH PASSWORD '$NEW_PASS';"
    
    # 2. Create the Database owned by that user
    docker exec -u "$POSTGRES_USER" "$CONTAINER_NAME" psql -c "CREATE DATABASE $DB_NAME OWNER $NEW_USER;"
    
    echo "Success: Database $DB_NAME created for $NEW_USER."
}

manage_permissions() {
    get_input TARGET_DB "Enter the existing database name"
    get_input TARGET_USER "Enter the username to add/modify"
    get_input ROLE_TYPE "Choose role (admin/readonly)"

    if [ "$ROLE_TYPE" == "admin" ]; then
        echo "Granting administrative privileges to $TARGET_USER on $TARGET_DB..."
        docker exec -u "$POSTGRES_USER" "$CONTAINER_NAME" psql -d "$TARGET_DB" -c "GRANT ALL PRIVILEGES ON DATABASE $TARGET_DB TO $TARGET_USER; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $TARGET_USER;"
    elif [ "$ROLE_TYPE" == "readonly" ]; then
        echo "Granting read-only privileges to $TARGET_USER on $TARGET_DB..."
        docker exec -u "$POSTGRES_USER" "$CONTAINER_NAME" psql -d "$TARGET_DB" -c "GRANT CONNECT ON DATABASE $TARGET_DB TO $TARGET_USER; GRANT USAGE ON SCHEMA public TO $TARGET_USER; GRANT SELECT ON ALL TABLES IN SCHEMA public TO $TARGET_USER;"
    else
        echo "Error: Invalid role type. Use 'admin' or 'readonly'."
        exit 1
    fi
}

# --- Main Script Logic ---
case "$1" in
    create)
        DB_NAME=$2 NEW_USER=$3 NEW_PASS=$4
        create_db_and_user
        ;;
    grant)
        TARGET_DB=$2 TARGET_USER=$3 ROLE_TYPE=$4
        manage_permissions
        ;;
    *)
        echo "Usage:"
        echo "  $0 create [db_name] [user] [password]"
        echo "  $0 grant [db_name] [user] [admin/readonly]"
        echo ""
        echo "Running without parameters will trigger interactive mode."
        read -p "What would you like to do? (create/grant): " ACTION
        if [ "$ACTION" == "create" ]; then create_db_and_user; 
        elif [ "$ACTION" == "grant" ]; then manage_permissions; 
        else echo "Invalid action."; fi
        ;;
esac
