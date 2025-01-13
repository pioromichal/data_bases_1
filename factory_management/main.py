from services.employees import list_employees, create_employee

def main_menu():
    print("""
    
Welcome to Factory management application!

=============================================
Instructions:
Use Keyboard for interaction with app
Use Ctrl+D for returning to menu
Use Ctrl+C to exit application at any moment
=============================================
""")

    try:
        while True:
            try:
                print("\nMENU:")
                print(" 1. List employees")
                print(" 2. Add employee")
                print(" 0. Exit")
                choice = input("Choose an option: ")

                if choice == "1":
                    list_employees()
                elif choice == "2":
                    create_employee()
                elif choice == "0":
                    print("Goodbye!")
                    break
                else:
                    print("\nInvalid choice. Please try again.")
                    
            except EOFError:
                print("\n\nOperation interrupted with Ctrl+D. Returning to main menu.\n")
    except KeyboardInterrupt:
        print("\n\nOperation interrupted with Ctrl+C. Goodbye!")

if __name__ == "__main__":
    main_menu()
