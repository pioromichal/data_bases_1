from db.connection import get_connection
from db.queries import get_all_employees, add_employee
from utils.table_display import display_table
from utils.input_validation import *
from datetime import datetime
import cx_Oracle

def list_employees():
    conn = get_connection()
    cursor = conn.cursor()
    employees = get_all_employees(cursor)
    display_table(["ID", "Name", "Surname", "Salary", "Birth Date", "Gender", "Position ID", "Production line ID"], employees)
    conn.close()

def create_employee():
    name = get_valid_input(
        "Enter name: ", 
        validate_non_empty, 
        "Invalid name. Please try again."
    )
    surname = get_valid_input(
        "Enter surname: ", 
        lambda x: x.strip() if x.strip() else ValueError("Surname cannot be empty"), 
        "Invalid surname. Please try again."
    )
    salary = get_valid_input(
        "Enter salary: ", 
        lambda x: float(x) if float(x) > 0 else ValueError("Salary must be positive"), 
        "Invalid salary. Please enter a positive number."
    )
    birth_date = get_valid_input(
        "Enter birth date (YYYY-MM-DD): ", 
        lambda x: datetime.strptime(x, "%Y-%m-%d"), 
        "Invalid date format. Please use YYYY-MM-DD."
    ).strftime("%Y-%m-%d")
    gender = get_valid_input(
        "Enter gender (M/F): ", 
        lambda x: x.upper() if x.upper() in ('M', 'F') else ValueError("Invalid gender"), 
        "Invalid gender. Please enter M or F."
    )
    position_id = get_valid_input(
        "Enter position ID: ", 
        lambda x: int(x) if int(x) > 0 else ValueError("Position ID must be positive"), 
        "Invalid position ID. Please enter a positive integer."
    )
    production_line_id = get_valid_input(
        "Enter production line ID: ", 
        lambda x: int(x) if int(x) > 0 else ValueError("Production line ID must be positive"), 
        "Invalid production line ID. Please enter a positive integer."
    )

    # Połączenie z bazą danych
    conn = get_connection()
    cursor = conn.cursor()

    try:
        add_employee(cursor, name, surname, salary, birth_date, gender, position_id, production_line_id)
        conn.commit()
        print("\nEmployee added successfully!")
    except cx_Oracle.DatabaseError as e:
        error, = e.args
        print("\nError adding employee:", error.message)
        # print("Debug: ", name, surname, salary, birth_date, gender, position_id, production_line_id)
    finally:
        conn.close()