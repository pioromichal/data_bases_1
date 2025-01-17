from db.connection import get_connection
import db.queries as queries
from utils.table_display import display_table
from utils.input_validation import *
import cx_Oracle
from termcolor import colored

headers = ["ID", "Name", "Surname", "Salary", "Birth Date", "Gender", "Position Name", "Production Line Name"]

def list_employees():
    conn = get_connection()
    cursor = conn.cursor()
    employees = queries.get_all_employees_with_names(cursor)
    display_table("Employees", headers, employees)
    conn.close()

def create_employee():
    name = get_valid_input(
        "Enter name: ",
        validate_non_empty,
        "Invalid name"
    )
    surname = get_valid_input(
        "Enter surname: ",
        validate_non_empty,
        "Invalid surname"
    )
    salary = get_valid_input(
        "Enter salary (or leave empty): ",
        lambda x: validate_positive_number(x, allow_empty=True),
        "Invalid salary"
    )
    birth_date = get_valid_input(
        "Enter birth date (YYYY-MM-DD): ",
        lambda x: validate_date(x, "%Y-%m-%d"),
        "Invalid date format"
    )
    gender = get_valid_input(
        "Enter gender (M/F): ",
        lambda x: validate_choice(x, ['M', 'F']),
        "Invalid gender"
    )
    position_id = get_valid_input(
        "Enter position ID: ",
        lambda x: validate_positive_integer(x, allow_empty=False),
        "Invalid position ID"
    )
    production_line_id = get_valid_input(
        "Enter production line ID (or leave empty): ",
        lambda x: validate_positive_integer(x, allow_empty=True),
        "Invalid production line ID"
    )

    conn = get_connection()
    cursor = conn.cursor()

    try:
        queries.add_employee(cursor, name, surname, salary, birth_date, gender, position_id, production_line_id)
        conn.commit()
        print(colored("\nEmployee added successfully!", 'green'))
    except cx_Oracle.DatabaseError as e:
        error, = e.args
        print(colored("\nError adding employee:", error.message, 'red'))
    finally:
        conn.close()

def terminate_employee():
    employee_id = get_valid_input(
        "Enter employee ID to terminate: ",
        validate_positive_integer,
        "Invalid employee ID"
    )

    conn = get_connection()
    cursor = conn.cursor()

    try:
        # Sprawdzenie, czy pracownik istnieje
        employee = queries.get_employee_by_id(cursor, employee_id)
        if not employee:
            print(colored(f"\nEmployee with ID {employee_id} does not exist.", 'red'))
            return

        # Wyświetlenie szczegółów pracownika
        print(colored(f"\nEmployee details:\nID: {employee[0]}, Name: {employee[1]}, Surname: {employee[2]}", 'yellow'))

        # Potwierdzenie usunięcia
        confirm = input(colored("\nAre you sure you want to terminate this employee? (yes/no): ", 'cyan')).strip().lower()
        if confirm != 'yes':
            print(colored("\nOperation canceled.", 'green'))
            return

        # Usunięcie pracownika
        queries.delete_employee(cursor, employee_id)
        conn.commit()
        print(colored(f"\nEmployee with ID {employee_id} has been terminated successfully!", 'green'))

    except cx_Oracle.DatabaseError as e:
        error, = e.args
        print(colored("\nError terminating employee:", 'red'))
        print(colored(f"Details: {error.message}", 'red'))
    finally:
        conn.close()


def edit_employee():
    employee_id = get_valid_input(
        "Enter employee ID to edit: ",
        validate_positive_integer,
        "Invalid employee ID"
    )

    conn = get_connection()
    cursor = conn.cursor()

    try:
        # Sprawdzenie, czy pracownik istnieje
        employee = queries.get_employee_by_id(cursor, employee_id)
        if not employee:
            print(colored(f"\nEmployee with ID {employee_id} does not exist.", 'red'))
            return

        print(colored(f"\nEditing employee: ID: {employee[0]}, Name: {employee[1]}, Surname: {employee[2]}", 'yellow'))

        # Wybór pól do edycji
        name = get_valid_input(
            "Enter new name (or leave empty to keep current): ",
            lambda x: validate_non_empty(x) if x.strip() else None,
            "Invalid name"
        )

        surname = get_valid_input(
            "Enter new surname (or leave empty to keep current): ",
            lambda x: validate_non_empty(x) if x.strip() else None,
            "Invalid surname"
        )

        salary = get_valid_input(
            "Enter new salary (or leave empty to keep current): ",
            lambda x: validate_positive_number(x, allow_empty=True),
            "Invalid salary"
        )

        birth_date = get_valid_input(
            "Enter new birth date (YYYY-MM-DD) (or leave empty to keep current): ",
            lambda x: validate_date(x, "%Y-%m-%d") if x.strip() else None,
            "Invalid date format"
        )

        gender = get_valid_input(
            "Enter new gender (M/F) (or leave empty to keep current): ",
            lambda x: validate_choice(x, ['M', 'F']) if x.strip() else None,
            "Invalid gender"
        )

        position_id = get_valid_input(
            "Enter new position ID (or leave empty to keep current): ",
            lambda x: validate_positive_integer(x, allow_empty=True),
            "Invalid position ID"
        )

        production_line_id = get_valid_input(
            "Enter new production line ID (or leave empty to keep current): ",
            lambda x: validate_positive_integer(x, allow_empty=True),
            "Invalid production line ID"
        )

        # Wywołanie zapytania SQL do aktualizacji
        queries.update_employee(
            cursor, employee_id, name, surname, salary, birth_date, gender, position_id, production_line_id
        )
        conn.commit()

        print(colored("\nEmployee updated successfully!", 'green'))
    except cx_Oracle.DatabaseError as e:
        error, = e.args
        print(colored("\nError updating employee:", 'red'))
        print(colored(f"Details: {error.message}", 'red'))
    except ValueError as e:
        print(colored(f"\n{e}\n", 'red'))
    finally:
        conn.close()