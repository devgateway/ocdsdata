import os
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def cli():
    database_url = os.environ["PG_DATABASE_URL"]
    create_database(database_url, 'ocdsdata')
    rename_database(database_url, 'ocdsdata', 'ocdsdata_old')

def rename_database(database_url, old_name, new_name):
    # Connect to the default 'postgres' database to rename a different database
    with psycopg2.connect(database_url) as conn:
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        # Terminate all connections to the old database
        cursor.execute(f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{old_name}';")
        # Rename the database
        cursor.execute(f"ALTER DATABASE {old_name} RENAME TO {new_name};")
        cursor.close()
    print(f"Database {old_name} renamed to {new_name} successfully.")    

# Function to create a new database
def create_database(database_url, db_name):
    conn = psycopg2.connect(database_url)
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cursor = conn.cursor()
    cursor.execute(f"CREATE DATABASE {db_name};")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    cli()
