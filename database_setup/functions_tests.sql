-- Test 1: check_machine_service
-- Dodanie maszyny z automatycznym ID
INSERT INTO Machines (machine_name, status, machine_type_id)
VALUES ('Machine A', 'MAINTENANCE', 1);

-- Wywołanie funkcji
SELECT check_machine_service(1) FROM dual;

-- Test 2: check_machine_service
-- Dodanie danych związanych z funkcją
INSERT INTO Machine_Types (type_name, service_interval_hours, service_interval_products)
VALUES ('Type A', 100, 1000);

INSERT INTO Machines (machine_name, status, machine_type_id, production_line_id)
VALUES ('Machine B', 'ACTIVE', 1, 1);

INSERT INTO Services (service_name, machine_id, service_reason, service_status, start_date, end_date)
VALUES ('Maintenance Service', 2, 'MAINTENANCE', 'COMPLETED', SYSDATE - 20, SYSDATE - 10);

INSERT INTO Products (product_name, production_date, product_type, production_line_id)
VALUES ('Product A', SYSDATE - 5, 'Type X', 1);

-- Wywołanie funkcji
SELECT check_machine_service(2) FROM dual;

-- Test 3: check_machine_service
-- Dodanie kolejnych danych
INSERT INTO Machines (machine_name, status, machine_type_id)
VALUES ('Machine C', 'ACTIVE', 1);

INSERT INTO Services (service_name, machine_id, service_reason, service_status, start_date, end_date)
VALUES ('Maintenance Service', 3, 'MAINTENANCE', 'COMPLETED', SYSDATE - 30, SYSDATE - 20);

-- Wywołanie funkcji
SELECT check_machine_service(3) FROM dual;



-- Test 1: Linia produkcyjna z maszynami wymagającymi serwisu
BEGIN
    -- Dodanie typu maszyny
    INSERT INTO Machine_Types (type_name, service_interval_hours, service_interval_products)
    VALUES ('Type A', 100, 1000);

    -- Dodanie linii produkcyjnej
    INSERT INTO Production_Lines (line_name, start_date, status)
    VALUES ('Line 1', SYSDATE - 365, 'ACTIVE');

    -- Dodanie maszyn
    INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
    VALUES ('Machine 1', 1, 1, 'ACTIVE');
    INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
    VALUES ('Machine 2', 1, 1, 'ACTIVE');

    -- Dodanie serwisów
    INSERT INTO Services (service_name, machine_id, start_date, end_date, service_reason, service_status)
    VALUES ('Maintenance A', 1, SYSDATE - 200, SYSDATE - 199, 'MAINTENANCE', 'COMPLETED');
    INSERT INTO Services (service_name, machine_id, start_date, end_date, service_reason, service_status)
    VALUES ('Maintenance B', 2, SYSDATE - 120, SYSDATE - 119, 'MAINTENANCE', 'COMPLETED');
END;
/

-- Deklaracja kursora
VARIABLE cur REFCURSOR;

-- Wywołanie funkcji dla linii produkcyjnej 1
BEGIN
    :cur := check_production_line_service(1);
END;
/

-- Wyświetlenie wyników kursora
PRINT cur;


-- Test 2: Linia produkcyjna bez maszyn wymagających serwisu
BEGIN
    -- Dodanie nowej linii produkcyjnej
    INSERT INTO Production_Lines (line_name, start_date, status)
    VALUES ('Line 2', SYSDATE - 200, 'ACTIVE');

    -- Dodanie maszyn
    INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
    VALUES ('Machine 3', 1, 2, 'ACTIVE');
    INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
    VALUES ('Machine 4', 1, 2, 'ACTIVE');

    -- Dodanie serwisów w wystarczająco bliskim czasie
    INSERT INTO Services (service_name, machine_id, start_date, end_date, service_reason, service_status)
    VALUES ('Maintenance C', 3, SYSDATE - 5, SYSDATE - 4, 'MAINTENANCE', 'COMPLETED');
    INSERT INTO Services (service_name, machine_id, start_date, end_date, service_reason, service_status)
    VALUES ('Maintenance D', 4, SYSDATE - 6, SYSDATE - 5, 'MAINTENANCE', 'COMPLETED');
END;
/

-- Wywołanie funkcji dla linii produkcyjnej 2
BEGIN
    :cur := check_production_line_service(2);
END;
/

-- Wyświetlenie wyników kursora
PRINT cur;


-- Test 3: Linia produkcyjna bez maszyn
BEGIN
    -- Dodanie pustej linii produkcyjnej
    INSERT INTO Production_Lines (line_name, start_date, status)
    VALUES ('Line 3', SYSDATE - 100, 'ACTIVE');
END;
/

-- Wywołanie funkcji dla linii produkcyjnej 3
BEGIN
    :cur := check_production_line_service(3);
END;
/

-- Wyświetlenie wyników kursora
PRINT cur;
