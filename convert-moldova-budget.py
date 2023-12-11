import psycopg2
import io
import openpyxl

# budget_db = os.environ["BUDGET_DB"]
# prefix_database_url = os.environ["PG_DATABASE_URL"]
# budget_db_url = prefix_database_url + budget_db
budget_db_url = "postgresql://superset:superset@localhost:5433/budget_moldova"


def get_file_content_and_id(resource_id, revision_id):
    """
    Get the content of a specific file from a CKAN repository.
    :param resource_id: ID of the file to get
    :param revision_id: Revision ID of the file to get
    """
    with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()
        cursor.execute(
            f"SELECT id, content from files where resource_id = %s and revision_id = %s;", (resource_id, revision_id))
        row = cursor.fetchone()
        id = row[0]
        content = row[1]
        cursor.close()
        return (content, id)


def save_budget_line(region, org1, eco_k, approved, adjusted, executed, budget_category_id, budget_entity_id, file_id, file_row_no):
    with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()
        query = ("INSERT INTO budget_lines (region, org1, eco_k, approved, adjusted, executed, budget_category_id, budget_entity_id, file_id, file_row_no) "
                 " VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);")
        data_tuple = (
            region, org1, eco_k, approved, adjusted, executed, budget_category_id, budget_entity_id, file_id, file_row_no
        )
        cursor.execute(query, data_tuple)
        conn.commit()
        cursor.close()


def ensure_saved_entity(name, parent_id):
    with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()
        if parent_id is None:
            cursor.execute(
                f"SELECT id from budget_entities where name = %s and parent_id is null;", (name,))
        else:
            cursor.execute(
                f"SELECT id from budget_entities where name = %s and parent_id = %s;", (name, parent_id))
        response = cursor.fetchone()
        cursor.close()
        if response is None:
            with psycopg2.connect(budget_db_url) as conn:
                cursor = conn.cursor()
                query = ("INSERT INTO budget_entities (name, parent_id) "
                         " VALUES (%s, %s) RETURNING id;")
                data_tuple = (
                    name,
                    parent_id
                )
                cursor.execute(query, data_tuple)
                insert_id = cursor.fetchone()[0]
                conn.commit()
                cursor.close()
                print(f"Saved Entity {name} with parent {parent_id}")
                return insert_id
        else:
            return response[0]


def ensure_saved_category(name, parent_id):
    """
    Ensure that a category exists in the database.
    :param name: Name of the category
    :param parent_id: ID of the parent category
    :return: ID of the category
    """
    with psycopg2.connect(budget_db_url) as conn:
        cursor = conn.cursor()

        if parent_id is None:
            cursor.execute(
                f"SELECT id from budget_categories where name = %s and parent_id is null;", (name,))
        else:
            cursor.execute(
                f"SELECT id from budget_categories where name = %s and parent_id = %s;", (name, parent_id))

        response = cursor.fetchone()
        cursor.close()
        if response is None:
            with psycopg2.connect(budget_db_url) as conn:
                cursor = conn.cursor()
                query = ("INSERT INTO budget_categories (name, parent_id) "
                         " VALUES (%s, %s) RETURNING id;")
                data_tuple = (
                    name,
                    parent_id
                )
                cursor.execute(query, data_tuple)
                insert_id = cursor.fetchone()[0]
                conn.commit()
                cursor.close()
                print(f"Saved Category {name} with parent {parent_id}")
                return insert_id
        else:
            return response[0]


def check_raion(region, org1, eco_k, approved, adjusted, executed):
    return region != None and org1 == None and eco_k == None and approved == None and adjusted == None and executed == None


def check_lpa(region, org1, eco_k, approved, adjusted, executed):
    return region != None and org1 != None and eco_k == None and approved == None and adjusted == None and executed == None


def check_parent_category(region, org1, eco_k, approved, adjusted, executed):
    return region != None and org1 != None and eco_k == None and (approved != None or adjusted != None or executed != None)


def relevant_logical_row(row):
    return (row[1], row[2], row[7], row[8], row[9], row[10])


def convert_file(resource_id, revision_id):
    """
    Convert a specific file from a CKAN repository to a PostgreSQL table.
    :param id: ID of the file to convert
    :param revision_id: Revision ID of the file to convert
    """
    (content, file_id) = get_file_content_and_id(resource_id, revision_id)
    excel_file = io.BytesIO(content)
    workbook = openpyxl.load_workbook(excel_file)

    # Access the desired sheet and cells in the workbook
    sheet = workbook.active
    raion_id = None
    lpa_id = None
    parent_category_id = None
    for row_id, row in enumerate(sheet.iter_rows(values_only=True), start=1):
        if (row_id < 8):
            continue

        # print("Row ID:", row_id)
        # print("Row Data:", row)

        # trim the spaces from the strings within row array
        row = [s.strip() if isinstance(s, str) and s.strip() !=
               "" else None if isinstance(s, str) else s for s in row]

        is_raion = check_raion(*relevant_logical_row(row))
        is_lpa = check_lpa(*relevant_logical_row(row))
        if is_raion and is_lpa:
            print("Error: both raion and lpa")
            exit(1)

        if is_raion:
            raion_id = ensure_saved_entity(row[0], None)
            continue
        if is_lpa:
            lpa_id = ensure_saved_entity(row[0], raion_id)
            continue

        if raion_id == None or lpa_id == None:
            continue

        is_parent_category = check_parent_category(*relevant_logical_row(row))
        if is_parent_category:
            parent_category_id = ensure_saved_category(row[0], None)
            continue

        budget_category_id = ensure_saved_category(row[0], parent_category_id)

        save_budget_line(*relevant_logical_row(row),
                         budget_category_id, lpa_id, file_id, row_id)


convert_file("a9928ad8-c530-4043-8f42-2cbf878bb49f",
             "9def6e3d-c80b-465b-b800-8674feff4774")
