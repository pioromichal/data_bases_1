from db.connection import get_connection
from db.queries import get_all_employees, add_employee
from utils.table_display import display_table

def list_employees():
    conn = get_connection()
    cursor = conn.cursor()
    employees = get_all_employees(cursor)
    display_table(["ID", "Name", "Surname", "Salary", "Birth Date", "Gender"], employees)
    conn.close()

def create_employee():
    name = input("Enter name: ")
    surname = input("Enter surname: ")
    salary = float(input("Enter salary: "))
    birth_date = input("Enter birth date (YYYY-MM-DD): ")
    gender = input("Enter gender (M/F): ")
    position_id = int(input("Enter position ID: "))
    
    conn = get_connection()
    cursor = conn.cursor()
    add_employee(cursor, name, surname, salary, birth_date, gender, position_id)
    conn.commit()
    print("Employee added successfully!")
    conn.close()
