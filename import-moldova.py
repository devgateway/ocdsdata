import os
import psycopg2
import subprocess
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from psycopg2.extensions import parse_dsn

# Set environment variables
prefix_database_url = os.environ["PG_DATABASE_URL"]
scrape_db = os.environ["SCRAPE_DB"]
target_db = os.environ["TARGET_DB"]
old_db = os.environ["OLD_DB"]
pg_db = os.environ["PG_DB"]
pg_db_url = prefix_database_url + pg_db
target_db_url = prefix_database_url + target_db
old_db_url = prefix_database_url + old_db
scrape_db_url = prefix_database_url + scrape_db
extra_sql_file = "/app/dbscripts/cm/ocds-moldova-extra.sql"
os.environ["DATABASE_URL"] = prefix_database_url + scrape_db

def invoke_wait():
    """Invoke the wait script to wait for the database to be ready."""
    print("Invoking wait...", flush=True)
    process = subprocess.run("/wait", stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    print(process.stdout, flush=True)
    print(process.stderr, flush=True)
    return process.returncode

def invoke_scraper():
    """Invoke the scraper to import data into the database."""
    print("Invoking scraper...", flush=True)
    command = ["python", "ocdsdata.py", "import-scraper", "moldova", "moldova"]
    process = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    print(process.stdout, flush=True)
    print(process.stderr, flush=True)
    return process.returncode

def apply_extra_script():
    """Apply the extra script to the database."""
    print("Applying extra script...", flush=True)

    dsn_parameters = parse_dsn(pg_db_url)

    # Extract individual components
    host = dsn_parameters.get('host')
    port = dsn_parameters.get('port')
    password = dsn_parameters.get('password')
    user = dsn_parameters.get('user')

    os.environ["PGPASSWORD"] = password
    command = [
    'psql',
    '-h', host,
    '-p', port,
    '-U', user,
    '-d', scrape_db,
    '-f', extra_sql_file]
    
    process = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    print(process.stdout, flush=True)
    print(process.stderr, flush=True)
    return process.returncode

def test_scraped_data():
    print(f"Testing if new data has been fetched", flush=True)
    #Connect to the existing database
    existing_count = None
    with psycopg2.connect(target_db_url) as conn:
        cursor = conn.cursor()
        cursor.execute(f"SELECT count(*) from moldova.release;")
        existing_count = cursor.fetchone()[0]
        print(f"Existing database has {existing_count} releases", flush=True)
        cursor.close()
    #Connect to the scraped database
    scraped_count = None
    with psycopg2.connect(scrape_db_url) as conn:
        cursor = conn.cursor()
        cursor.execute(f"SELECT count(*) from moldova.release;")
        scraped_count = cursor.fetchone()[0]
        print(f"Scrape database has {scraped_count} releases", flush=True)
        cursor.close()
    #returns true if the scraped database has more releases than the existing database
    return scraped_count > existing_count

def cli():
    """CLI entrypoint."""
    # Invoke wait
    return_code = invoke_wait()
    if return_code != 0:
        print("Wait failed.", flush=True)
        return return_code
    
    drop_database(scrape_db)
    
    create_database(scrape_db)
   
    # Invoke the scraper
    return_code = invoke_scraper()
    if return_code != 0:
        print("Scraper failed to import data.", flush=True)
        return return_code
    print("Scraper finished successfully.", flush=True)

    if(test_scraped_data()):
        print("New data has been fetched", flush=True)
    else:
        print("No new data has been fetched", flush=True)
        return 0
     
    # Apply the extra script
    return_code = apply_extra_script()
    if return_code != 0:
        print("Failed to apply extra script.", flush=True)
        return return_code
    
    drop_database(old_db)
    
    rename_database(target_db, old_db)
    
    rename_database(scrape_db, target_db)

def rename_database(old_name, new_name):
    """Rename a database."""
    print(f"Renaming database {old_name} to {new_name}...", flush=True)
    # Connect to the default 'postgres' database to rename a different database
    with psycopg2.connect(pg_db_url) as conn:
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        # Terminate all connections to the old database
        cursor.execute(f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{old_name}';")
        # Rename the database
        cursor.execute(f"ALTER DATABASE {old_name} RENAME TO {new_name};")
        cursor.close()
    print(f"Database {old_name} renamed to {new_name} successfully.", flush=True)    

def drop_database(db_name):
    """Drop a database."""
    print(f"Dropping database {db_name}...", flush=True)
    conn = psycopg2.connect(pg_db_url)
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cursor = conn.cursor()
    # Terminate all connections to the old database
    cursor.execute(f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{db_name}';")
    # Drop the database
    cursor.execute(f"DROP DATABASE IF EXISTS {db_name};")
    cursor.close()
    conn.close()
    print(f"Database {db_name} dropped successfully.", flush=True)

def create_database(db_name):
    """Create a database."""
    print(f"Creating database {db_name}...", flush=True)
    conn = psycopg2.connect(pg_db_url)
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cursor = conn.cursor()
    cursor.execute(f"CREATE DATABASE {db_name};")
    cursor.close()
    conn.close()
    print(f"Database {db_name} created successfully.", flush=True)

if __name__ == "__main__":
    cli()
