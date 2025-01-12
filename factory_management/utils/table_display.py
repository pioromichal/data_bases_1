from rich.console import Console
from rich.table import Table

def display_table(headers, rows):
    table = Table(title="Data")
    for header in headers:
        table.add_column(header, style="cyan", no_wrap=True)

    for row in rows:
        table.add_row(*map(str, row))

    console = Console()
    console.print(table)
