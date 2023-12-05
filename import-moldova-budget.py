import requests
import os
import psycopg2

#budget_db = os.environ["BUDGET_DB"]
#prefix_database_url = os.environ["PG_DATABASE_URL"]
#budget_db_url = prefix_database_url + budget_db
#budget_db_url = "postgresql://superset:superset@localhost:5433/budget_moldova"

def check_file_exists(id, revision_id):
     with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()
        cursor.execute(f"SELECT count(*) from files where id = '{id}' and revision_id = '{revision_id}';")
        existing_count = cursor.fetchone()[0]
        cursor.close()
        return existing_count > 0
    
def save_file(resource, content):
    with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()
        query = ("INSERT INTO files (id, resource_group_id, cache_last_updated, revision_timestamp, size, state, hash, description, format, last_modified, url_type," 
                       " mimetype, cache_url, name, created, url, webstore_url, mimetype_inner, \"position\", revision_id, resource_type, content) " 
                       " VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);")
        data_tuple = (
            resource["id"],
            resource["resource_group_id"],
            resource["cache_last_updated"],
            resource["revision_timestamp"],
            resource["size"],
            resource["state"],
            resource["hash"],
            resource["description"],
            resource["format"],
            resource["last_modified"],
            resource["url_type"],
            resource["mimetype"],
            resource["cache_url"],
            resource["name"],
            resource["created"],
            resource["url"],
            resource["webstore_url"],
            resource["mimetype_inner"],
            resource["position"],
            resource["revision_id"],
            resource["resource_type"],
            psycopg2.Binary(content)
    )
        cursor.execute(query, data_tuple)
        conn.commit()
        cursor.close()
        print(f"Saved {resource['name']}")   

def download_ckan_package(base_url, package_id):
    """
    Download all the resources for a specific package from a CKAN repository.

    :param base_url: URL of the CKAN repository
    :param package_id: ID of the package to download
    """
    # Constructing the API endpoint for package details
    package_api_url = f"{base_url}/api/3/action/package_show?id={package_id}"

    # Sending a request to the CKAN API to get package details
    response = requests.get(package_api_url)
    if response.status_code == 200:
        package_details = response.json()

        # Check if the request was successful and has data
        if package_details['success']:
            resources = package_details['result']['resources']

            # Download each resource in the package
            for resource in resources:
                url = resource['url']
                name = resource['name']
                id = resource['id']
                revision_id = resource['revision_id']
                
                if(check_file_exists(id, revision_id)):
                    print(f"File {name} already exists")
                    continue
                
                print(f"Downloading {name} from {url}")

                # Sending a request to download the resource
                resource_response = requests.get(url)
                if resource_response.status_code == 200:
                    print(f"Downloaded {name}")
                    save_file(resource, resource_response.content)
                else:
                    print(f"Failed to download {resource_name}")

        else:
            print("Failed to retrieve package details.")
    else:
        print("Failed to connect to the CKAN API.")

# Example usage
download_ckan_package("https://data.gov.md/ckan", "15969-date-privind-executarea-bugetelor-autoritatilor-publice-locale")
