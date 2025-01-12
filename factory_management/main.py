from services.employees import list_employees, create_employee

def main_menu():
    try:
        while True:
            print("1. List employees")
            print("2. Add employee")
            print("0. Exit")
            choice = input("Choose an option: ")

            if choice == "1":
                list_employees()
            elif choice == "2":
                create_employee()
            elif choice == "0":
                print("Goodbye!")
                break
            else:
                print("Invalid choice. Please try again.")
    except KeyboardInterrupt:
        print("\nOperation interrupted. Goodbye!")

if __name__ == "__main__":
    main_menu()
