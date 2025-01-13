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

def update_employee(cursor, employee_id, name=None, surname=None, salary=None, birth_date=None, gender=None, position_id=None, production_line_id=None):
    """Aktualizuje dane pracownika na podstawie podanych pól."""
    fields = []
    params = {'employee_id': employee_id}

    if name is not None:
        fields.append("name = :name")
        params['name'] = name

    if surname is not None:
        fields.append("surname = :surname")
        params['surname'] = surname

    if salary is not None:
        fields.append("salary = :salary")
        params['salary'] = salary

    if birth_date is not None:
        fields.append("birth_date = TO_DATE(:birth_date, 'YYYY-MM-DD')")
        params['birth_date'] = birth_date

    if gender is not None:
        fields.append("gender = :gender")
        params['gender'] = gender

    if position_id is not None:
        fields.append("position_id = :position_id")
        params['position_id'] = position_id

    if production_line_id is not None:
        fields.append("production_line_id = :production_line_id")
        params['production_line_id'] = production_line_id

    if not fields:
        raise ValueError("No fields to update")

    query = f"""
    UPDATE Employees
    SET {', '.join(fields)}
    WHERE employee_id = :employee_id
    """
    cursor.execute(query, params)
