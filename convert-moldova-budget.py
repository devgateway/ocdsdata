import requests
import os
import psycopg2
import io
import openpyxl

#budget_db = os.environ["BUDGET_DB"]
#prefix_database_url = os.environ["PG_DATABASE_URL"]
#budget_db_url = prefix_database_url + budget_db
budget_db_url = "postgresql://superset:superset@localhost:5433/budget_moldova"

def get_file_content(id, revision_id):
     with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()
        cursor.execute(f"SELECT content from files where id = '{id}' and revision_id = '{revision_id}';")
        content = cursor.fetchone()[0]
        cursor.close()
        return content
    


def convert_file(id, revision_id):
    """
    Convert the file content from the Moldova budget dataset to OCDS.
    """
    content = get_file_content(id, revision_id)
    excel_file = io.BytesIO(content)
    workbook = openpyxl.load_workbook(excel_file)

    # Access the desired sheet and cells in the workbook
    sheet = workbook.active
    for row in sheet.iter_rows(values_only=True):
        # Process each row
        # Example: print(row) or insert into another PostgreSQL table
        print(row)
        
convert_file("a9928ad8-c530-4043-8f42-2cbf878bb49f", "9def6e3d-c80b-465b-b800-8674feff4774")
