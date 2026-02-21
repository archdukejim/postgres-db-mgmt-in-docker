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
1. Save the script code as `manage-db.sh`.
2. Give the script execution permissions:
   ```bash
   chmod +x manage-db.sh
