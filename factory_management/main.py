import services.employees
import services.machines
from termcolor import colored

introduction = """
Welcome to Factory Management Application!
===================================================
Instructions:
- Use Keyboard for interaction with the app.
- Use Ctrl+D to return to the menu at any moment.
- Use Ctrl+C to exit the application at any moment.
===================================================
"""

menu_sections = {
    "Employee Management": {
        "1": ("List all employees", services.employees.list_employees),
        "2": ("Add employee", services.employees.create_employee),
        "3": ("Fire employee", services.employees.terminate_employee),
        "4": ("Edit employee", services.employees.edit_employee),
    },
    "Service Management": {
        "5": ("List all services", services.machines.list_services),
        "6": ("Start a service", services.machines.start_service),
        "7": ("Complete a service", services.machines.complete_service),
        "8": ("Machines Requiring Service", services.machines.check_production_line_service),
    },
    "Other": {
        "0": ("Exit", None),
    }
}

def display_menu():
    print("\nMENU:")
    for section, options in menu_sections.items():
        print(f"\n  {section}:")
        for key, (description, _) in options.items():
            print(f"    {key}. {description}")

def factory_management():

    print(introduction)

    while True:
        try:
            display_menu()

            choice = input("\nChoose an option: ")
            for _, options in menu_sections.items():
                if choice in options:
                    description, action = options[choice]
                    print(f"\nChosen '{description}'\n")
                    if action:
                        action()
                    else:
                        print("Goodbye!")
                        return
                    break
            else:
                print(colored("\nInvalid choice. Please try again.", 'red'))
                
        except EOFError:
            print("\n\nOperation interrupted with Ctrl+D. Returning to main menu.")
        except KeyboardInterrupt:
            print("\n\nOperation interrupted with Ctrl+C. Goodbye!")
            return

if __name__ == "__main__":
    factory_management()
