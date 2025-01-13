import services.employees

introduction = """
Welcome to Factory management application!
=============================================
Instructions:
Use Keyboard for interaction with app
Use Ctrl+D for returning to menu
Use Ctrl+C to exit application at any moment
=============================================
"""

menu = """
MENU:
  1. List employees
  2. Add employee
  3. Fire employee
  ...
  0. Exit
"""

def factory_management():
    print(introduction)

    while True:
        try:
            print(menu)

            choice = input("Choose an option: ")

            if choice == "1":
                print("Chosen 'List employees'\n")
                services.employees.list_employees()
            elif choice == "2":
                print("Chosen 'Add employee'\n")
                services.employees.create_employee()
            elif choice == "3":
                print("Chosen 'Fire employee'\n")
                services.employees.terminate_employee()
            elif choice == "0":
                print("Chosen 'Exit'\n")
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
