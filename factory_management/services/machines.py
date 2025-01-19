from db.connection import get_connection
import db.queries as queries
from utils.table_display import display_table
from utils.input_validation import *
import cx_Oracle
from termcolor import colored

headers = ["ID", "Name", "Machine Id", "Start Date", "End Date", "Performed By", "Service Reason", "Service Status"]


def list_services():
    conn = get_connection()
    cursor = conn.cursor()
    services = queries.get_all_services(cursor)
    display_table("Services", headers, services)
    conn.close()


def start_service():
    machine_id = get_valid_input(
        "Enter machine ID: ", 
        validate_positive_integer, 
        "Invalid machine ID"
    )
    start_date = get_valid_input(
        "Enter start date (YYYY-MM-DD): ", 
        lambda x: validate_date(x, "%Y-%m-%d"), 
        "Invalid date format"
    )
    service_name = get_valid_input(
        "Enter service name: ", 
        validate_non_empty, 
        "Service name cannot be empty"
    )
    service_reason = get_valid_input(
        "Enter service reason (MAINTENANCE/REPAIR/INSPECTION/UPGRADE): ", 
        lambda x: validate_choice(x, ['MAINTENANCE', 'REPAIR', 'INSPECTION', 'UPGRADE']), 
        "Invalid reason"
    )
    performed_by = get_valid_input(
        "Enter employee ID (performing service): ", 
        validate_positive_integer, 
        "Invalid employee ID"
    )

    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.callproc("start_service", [
            machine_id, 
            datetime.strptime(start_date, "%Y-%m-%d"),
            service_name, 
            service_reason, 
            performed_by
        ])
        conn.commit()

        print(colored(f"\nService '{service_name}' for machine {machine_id} has been successfully started.", 'green'))
    except cx_Oracle.DatabaseError as e:
        print(colored("\nError while starting the service:\n", 'red'), e)
    finally:
        cursor.close()
        conn.close()


def complete_service():
    service_id = get_valid_input(
        "Enter service ID: ", 
        validate_positive_integer, 
        "Invalid service ID"
    )
    machine_id = get_valid_input(
        "Enter machine ID: ", 
        validate_positive_integer, 
        "Invalid machine ID"
    )
    service_status = get_valid_input(
        "Enter service status (COMPLETED/FAILED): ", 
        lambda x: validate_choice(x, ['COMPLETED', 'FAILED']), 
        "Invalid service status"
    )
    end_date_str = get_valid_input(
        "Enter end date (YYYY-MM-DD): ", 
        lambda x: validate_date(x, "%Y-%m-%d"), 
        "Invalid date format"
    )

    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.callproc("complete_service", [
            service_id,
            service_status,
            datetime.strptime(end_date_str, "%Y-%m-%d") 
        ])
        conn.commit()

        print(colored(f"\nService {service_id} for machine {machine_id} has been marked as {service_status}.", 'green'))
    except cx_Oracle.DatabaseError as e:
        print(colored("\nError while completing the service:\n", 'red'), e)
    finally:
        cursor.close()
        conn.close()


def check_production_line_service():
    production_line_id = get_valid_input(
        "Enter production line ID: ", 
        validate_positive_integer, 
        "Invalid production line ID"
    )

    conn = get_connection()
    cursor = conn.cursor()

    try:
        sql = """
        BEGIN
            :ref_cursor := check_production_line_service(:p_production_line_id);
        END;
        """
        ref_cursor = cursor.var(cx_Oracle.CURSOR)
        cursor.execute(sql, {
            "ref_cursor": ref_cursor,
            "p_production_line_id": production_line_id
        })

        results = ref_cursor.getvalue()

        if results:
            print("\n\n")
            headers = ["Machine ID"]
            display_table(
                title=f"Machines Requiring Service on Production Line {production_line_id}",
                headers=headers,
                rows=results
            )
        else:
            print(colored(f"No machines on production line {production_line_id} require service.", 'green'))

    except cx_Oracle.DatabaseError as e:
        print(colored(f"Error while checking production line service: \n{e}", 'red'))
    finally:
        cursor.close()
        conn.close()