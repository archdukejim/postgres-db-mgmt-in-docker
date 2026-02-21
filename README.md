# Postgres Docker Manager

A lightweight Bash utility to manage databases and user permissions directly within a running PostgreSQL Docker container using `docker exec`.

## 🚀 Features
*   **Initial Setup**: Create a new database and a dedicated owner user in one command.
*   **Permission Management**: Quickly assign `admin` or `readonly` roles to users on existing databases.
*   **Hybrid Input**: Supports full command-line arguments for automation or interactive prompts for manual use.
*   **Secure**: Uses hidden input for passwords to keep them out of your terminal history.

## 📋 Prerequisites
*   [Docker](https://www.docker.com) must be installed and running.
*   A running PostgreSQL container (default name: `postgres_db_1`).
*   The `pg_hba.conf` inside your container must allow local connections (standard in the [Official Postgres Image](https://hub.docker.com)).

## 🛠 Setup
#### 1. Save the script code as `manage-db.sh`.
#### 2. Give the script execution permissions:
   ```bash
   chmod +x manage-db.sh
   ```
#### 3. *(Optional)* Open the script and update the CONTAINER_NAME variable to match your container's name.

## 📖 Usage
#### 1. Create a New Database & Owner
This creates a fresh user and a database where that user is the owner.
- **Argument Style:**
   ```bash
   ./manage-db.sh create my_new_db user_name my_password
   ```
- **Interactive Style:**
   ```bash
   ./manage-db.sh create
   ```
#### 2. Grant Permissions
Update access for a user on a specific database.
- **Argument Style:**
   ```bash
   ./manage-db.sh grant my_db user_name readonly
   ```
- **Interactive Style:**
   ```bash
   ./manage-db.sh grant
   ```

## Role Descriptions:

| **Role** | **Permissions Granted** |
| - | - |
| admin | Full control: `ALL PRIVILEGES` on database and all tables in public schema. |
| readonly | Safe access: `CONNECT`, `USAGE` on schema, and `SELECT` on all existing tables. |

## ⚠️ Important Notes
- **Existing Tables:** The `grant` function applies permissions to tables currently existing in the database.
- **Volume Persistence:** Changes made via this script are stored in your Docker volume. If you delete your volume, the databases will be lost.
- **Docker Names:** If your container was started via Docker Compose, the name might be `projectname_db_1`. Use `docker ps` to verify.