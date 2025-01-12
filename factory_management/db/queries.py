def get_all_employees(cursor):
    cursor.execute("""
        SELECT employee_id, name, surname, salary, birth_date, gender
        FROM Employees
    """)
    return cursor.fetchall()

def add_employee(cursor, name, surname, salary, birth_date, gender, position_id):
    cursor.execute("""
        INSERT INTO Employees (name, surname, salary, birth_date, gender, position_id)
        VALUES (:name, :surname, :salary, :birth_date, :gender, :position_id)
    """, {
        "name": name,
        "surname": surname,
        "salary": salary,
        "birth_date": birth_date,
        "gender": gender,
        "position_id": position_id
    })
