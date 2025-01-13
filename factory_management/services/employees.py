from db.connection import get_connection
from db.queries import *
from utils.table_display import display_table
from utils.input_validation import *
import cx_Oracle
from termcolor import colored

headers = ["ID", "Name", "Surname", "Salary", "Birth Date", "Gender", "Position Name", "Production Line Name"]

def list_employees():
    conn = get_connection()
    cursor = conn.cursor()
    employees = get_all_employees_with_names(cursor)
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
        add_employee(cursor, name, surname, salary, birth_date, gender, position_id, production_line_id)
        conn.commit()
        print(colored("\nEmployee added successfully!", 'green'))
    except cx_Oracle.DatabaseError as e:
        error, = e.args
        print(colored("\nError adding employee:", error.message, 'red'))
    finally:
        conn.close()