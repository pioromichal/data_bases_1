def get_all_employees(cursor):
    cursor.execute("""
        SELECT *
        FROM Employees
    """)
    return cursor.fetchall()

def get_all_employees_with_names(cursor):
    """
    Pobiera wszystkie rekordy z tabeli Employees z zamianą position_id i production_line_id 
    na nazwy stanowisk i linii produkcyjnych.
    """
    query = """
        SELECT 
            e.employee_id,
            e.name,
            e.surname,
            e.salary,
            e.birth_date,
            e.gender,
            p.position_name,
            pl.line_name
        FROM Employees e
        LEFT JOIN Positions p ON e.position_id = p.position_id
        LEFT JOIN Production_Lines pl ON e.production_line_id = pl.production_line_id
        ORDER BY e.employee_id
    """
    cursor.execute(query)
    return cursor.fetchall()


def add_employee(cursor, name, surname, salary, birth_date, gender, position_id, production_line_id):
    cursor.execute("""
        INSERT INTO employees (name, surname, salary, birth_date, gender, position_id, production_line_id)
        VALUES (:1, :2, :3, TO_DATE(:4, 'YYYY-MM-DD'), :5, :6, :7)
    """, (name, surname, salary, birth_date, gender, position_id, production_line_id))

def get_employee_by_id(cursor, employee_id):
    """Pobiera szczegóły pracownika na podstawie jego ID."""
    query = """
    SELECT employee_id, name, surname
    FROM Employees
    WHERE employee_id = :employee_id
    """
    cursor.execute(query, {'employee_id': employee_id})
    return cursor.fetchone()


def delete_employee(cursor, employee_id):
    """Usuwa pracownika na podstawie jego ID."""
    query = """
    DELETE FROM Employees
    WHERE employee_id = :employee_id
    """
    cursor.execute(query, {'employee_id': employee_id})