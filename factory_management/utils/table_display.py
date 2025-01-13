from rich.console import Console
from rich.table import Table
from datetime import datetime

def display_table(title, headers, rows):
    table = Table(title=title)
    for header in headers:
        table.add_column(header, style="cyan", no_wrap=True)

    for row in rows:
        formatted_row = []
        for cell in row:
            if isinstance(cell, datetime):
                formatted_row.append(cell.strftime("%Y-%m-%d"))
            else:
                formatted_row.append(str(cell))
        table.add_row(*formatted_row)

    console = Console()
    console.print(table)
