def get_all_employees(cursor):
    cursor.execute("""
        SELECT *
        FROM Employees
    """)
    return cursor.fetchall()

def get_all_employees_with_names(cursor):
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
    query = """
    SELECT employee_id, name, surname
    FROM Employees
    WHERE employee_id = :employee_id
    """
    cursor.execute(query, {'employee_id': employee_id})
    return cursor.fetchone()


def delete_employee(cursor, employee_id):
    query = """
    DELETE FROM Employees
    WHERE employee_id = :employee_id
    """
    cursor.execute(query, {'employee_id': employee_id})

def update_employee(cursor, employee_id, name=None, surname=None, salary=None, birth_date=None, gender=None, position_id=None, production_line_id=None):
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


def get_all_services(cursor):
    cursor.execute("""
        SELECT *
        FROM SERVICES
    """)
    return cursor.fetchall()


def generate_machine_query(filter_status=None, filter_type=None, sort_by="MACHINE_NAME", sort_order="ASC"):
    query = """
    SELECT
        m.machine_id,
        m.machine_name,
        mt.type_name AS machine_type,
        m.status AS machine_status,
        pl.line_name AS production_line,
        e.name AS performed_by,
        COUNT(s.service_id) AS num_services,
        MAX(s.start_date) AS last_service_date
    FROM
        Machines m
        JOIN Machine_Types mt ON m.machine_type_id = mt.machine_type_id
        LEFT JOIN Production_Lines pl ON m.production_line_id = pl.production_line_id
        LEFT JOIN Services s ON m.machine_id = s.machine_id
        LEFT JOIN Employees e ON s.performed_by = e.employee_id
    """

    where_conditions = []

    if filter_status:
        where_conditions.append(f"m.status = '{filter_status}'")

    if filter_type:
        where_conditions.append(f"upper(mt.type_name) = '{filter_type}'")

    if where_conditions:
        query += " WHERE " + " AND ".join(where_conditions)

    query += """
    GROUP BY
        m.machine_id, m.machine_name, mt.type_name, m.status, pl.line_name, e.name
    """

    query += f" ORDER BY {sort_by} {sort_order}"
    return query