def get_all_employees(cursor):
    cursor.execute("""
        SELECT *
        FROM Employees
    """)
    return cursor.fetchall()

def add_employee(cursor, name, surname, salary, birth_date, gender, position_id, production_line_id):
    cursor.execute("""
        INSERT INTO employees (name, surname, salary, birth_date, gender, position_id, production_line_id)
        VALUES (:1, :2, :3, TO_DATE(:4, 'YYYY-MM-DD'), :5, :6, :7)
    """, (name, surname, salary, birth_date, gender, position_id, production_line_id))
