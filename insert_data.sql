-- Wstawianie danych do Machine_Type
INSERT INTO Machine_Type (type_name, service_interval_hours, service_interval_products)
VALUES ('Fermenter', 1000, 5000);
INSERT INTO Machine_Type (type_name, service_interval_hours, service_interval_products)
VALUES ('Bottling Machine', 500, 2000);
INSERT INTO Machine_Type (type_name, service_interval_hours, service_interval_products)
VALUES ('Pasteurizer', 700, 3000);
COMMIT;

-- Wstawianie danych do Production_Line
INSERT INTO Production_Line (line_name, start_date, status)
VALUES ('Fermentation Line 1', DATE '2024-01-01', 'ACTIVE');
INSERT INTO Production_Line (line_name, start_date, status)
VALUES ('Fermentation Line 2', DATE '2024-01-01', 'ACTIVE');
INSERT INTO Production_Line (line_name, start_date, status)
VALUES ('Bottling Line 1', DATE '2024-01-01', 'ACTIVE');
INSERT INTO Production_Line (line_name, start_date, status)
VALUES ('Fermentation Line 3', DATE '2024-05-01', 'ACTIVE');
INSERT INTO Production_Line (line_name, start_date, status)
VALUES ('Bottling Line 2', DATE '2024-07-01', 'ACTIVE');
COMMIT;

-- Wstawianie danych do Machines
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter A', 1, 1, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter B', 1, 1, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter C', 1, 1, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter D', 1, 2, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter E', 1, 2, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter F', 1, 2, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Bottling Machine A', 2, 3, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Bottling Machine B', 2, 3, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Pasteurizer A', 3, 3, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter G', 1, 4, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter H', 1, 4, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Fermenter I', 1, 4, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Bottling Machine C', 2, 5, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Bottling Machine D', 2, 5, 'ACTIVE');
INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
VALUES ('Pasteurizer B', 3, 5, 'ACTIVE');
COMMIT;

-- Wstawianie danych do Positions
INSERT INTO Positions (position_name, min_salary, max_salary, service_permission)
VALUES ('Brewmaster', 5000, 10000, 1);
INSERT INTO Positions (position_name, min_salary, max_salary, service_permission)
VALUES ('Technician', 4000, 7000, 1);
INSERT INTO Positions (position_name, min_salary, max_salary, service_permission)
VALUES ('Quality Control Specialist', 3500, 6000, 0);
INSERT INTO Positions (position_name, min_salary, max_salary, service_permission)
VALUES ('Packaging Worker', 3000, 5000, 0);
INSERT INTO Positions (position_name, min_salary, max_salary, service_permission)
VALUES ('Logistics Specialist', 3000, 5000, 0);
COMMIT;

-- Wstawianie danych do Employees
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('John', 'Smith', DATE '1990-03-15', 'M', 1, 1);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Anna', 'Taylor', DATE '1985-07-10', 'F', 2, 2);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Mike', 'Brown', DATE '1995-02-25', 'M', 2, 3);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Susan', 'Davis', DATE '1988-11-05', 'F', 3, 1);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Tom', 'Wilson', DATE '1992-06-20', 'M', 4, 2);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Laura', 'Anderson', DATE '1997-01-15', 'F', 5, 3);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Jake', 'Moore', DATE '1980-09-30', 'M', 2, 4);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Emily', 'Clark', DATE '1993-05-18', 'F', 3, 5);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Chris', 'Evans', DATE '1987-08-12', 'M', 4, 1);
INSERT INTO Employees (name, surname, birth_date, gender, position_id, production_line_id)
VALUES ('Sophia', 'Lewis', DATE '1990-12-03', 'F', 5, 2);
COMMIT;

-- Wstawianie danych do Services
INSERT INTO Services (service_name, machine_id, service_date, performed_by)
VALUES ('Filter Replacement', 1, DATE '2024-03-01', 2);
INSERT INTO Services (service_name, machine_id, service_date, performed_by)
VALUES ('Cleaning', 3, DATE '2024-04-15', 3);
INSERT INTO Services (service_name, machine_id, service_date, performed_by)
VALUES ('Calibration', 7, DATE '2024-06-20', 1);
INSERT INTO Services (service_name, machine_id, service_date, performed_by)
VALUES ('Inspection', 9, DATE '2024-08-05', 2);
INSERT INTO Services (service_name, machine_id, service_date, performed_by)
VALUES ('Repair', 13, DATE '2024-09-10', 3);
COMMIT;

-- Wstawianie danych do Products
BEGIN
    FOR i IN 1..10000 LOOP
        INSERT INTO Products (product_name, production_date, product_type, production_line_id)
        VALUES ('Beer ' || i, DATE '2024-01-01' + DBMS_RANDOM.VALUE(0, 365), 'Pale Ale', MOD(i, 5) + 1);
    END LOOP;
END;
/
COMMIT;

-- Wstawianie danych do Machine_History
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (1, 2, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (2, 3, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (3, 1, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (4, 2, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (5, 1, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (6, 3, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (7, 4, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (8, 5, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (9, 1, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (10, 4, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (11, 2, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (12, 5, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (13, 3, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (14, 1, DATE '2024-01-01');
INSERT INTO Machine_History (machine_id, new_production_line_id, transfer_date)
VALUES (15, 2, DATE '2024-01-01');

