import services.employees
import services.machines

introduction = """
Welcome to Factory management application!
=============================================
Instructions:
Use Keyboard for interaction with app
Use Ctrl+D for returning to menu
Use Ctrl+C to exit application at any moment
=============================================
"""


menu_options = {
    "1": ("List all employees", services.employees.list_employees),
    "2": ("Add employee", services.employees.create_employee),
    "3": ("Fire employee", services.employees.terminate_employee),
    "4": ("Edit employee", services.employees.edit_employee),

    "5": ("List all services", services.machines.list_services),
    "6": ("Start a service", services.machines.start_service),
    "7": ("Complete a service", services.machines.complete_service),

    "0": ("Exit", None)
}

def display_menu():
    print("\nMENU:")
    for key, (description, _) in menu_options.items():
        print(f"  {key}. {description}")

def factory_management():

    print(introduction)

    while True:
        try:
            display_menu()

            choice = input("\nChoose an option: ")
            if choice in menu_options:
                description, action = menu_options[choice]
                print(f"\nChosen '{description}'\n")
                if action:
                    action()
                else:
                    print("Goodbye!")
                    break
            else:
                print("\nInvalid choice. Please try again.")
                
        except EOFError:
            print("\n\nOperation interrupted with Ctrl+D. Returning to main menu.")
        except KeyboardInterrupt:
            print("\n\nOperation interrupted with Ctrl+C. Goodbye!")
            break

if __name__ == "__main__":
    factory_management()
