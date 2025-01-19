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


def start_service(cursor, machine_id, start_date, service_name, service_reason, performed_by):
    sql = """
    begin
        start_service(
            :machine_id,
            to_date(:start_date, 'YYYY-MM-DD'),
            :service_name,
            :service_reason,
            :performed_by
        );
    end;
    """
    cursor.execute(sql, {
        "machine_id": machine_id,
        "start_date": start_date,
        "service_name": service_name,
        "service_reason": service_reason,
        "performed_by": performed_by
    })


def complete_service(cursor, service_id, service_status, end_date):
    sql = """
    begin
        complete_service(
            :act_service_id,
            :new_service_status,
            to_date(:new_end_date, 'YYYY-MM-DD')
        );
    end;
    """
    cursor.execute(sql, {
        "act_service_id": service_id,
        "new_service_status": service_status,
        "new_end_date": end_date
    })    