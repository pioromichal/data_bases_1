from rich.console import Console
from rich.table import Table
import cx_Oracle

# Połączenie z bazą
def connect_to_db():
    return cx_Oracle.connect("rslepowr", "rslepowr", "ora4.ii.pw.edu.pl/pdb1.ii.pw.edu.pl")

# Wyświetlenie danych
def display_employees():
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM Employees")
    rows = cursor.fetchall()
    
    table = Table(title="Employees")
    table.add_column("ID", style="cyan", no_wrap=True)
    table.add_column("Name", style="green")
    table.add_column("Surname", style="green")
    table.add_column("Salary", style="green")
    table.add_column("Birth Date", style="green")
    table.add_column("Gender", style="green")
    table.add_column("Position", style="green")
    table.add_column("Production Line", style="green")

    for row in rows:
        table.add_row(*map(str, row))
    
    console = Console()
    console.print(table)
    conn.close()

# Wywołanie
display_employees()
