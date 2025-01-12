import cx_Oracle

def connect_to_db():
    dsn = cx_Oracle.makedsn("ora4.ii.pw.edu.pl", 1521, service_name="pdb1.ii.pw.edu.pl")
    # return cx_Oracle.connect("z22", "scmb6a", dsn)
    return cx_Oracle.connect("rslepowr", "rslepowr", dsn)

def display_employees():
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Employees")
    
    for row in cursor:
        print(row)
    
    conn.close()

display_employees()
