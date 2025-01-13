-- Procedura: Zatrudnienie pracownika
-- CREATE OR REPLACE PROCEDURE hire_employee (
--     emp_name VARCHAR2,
--     emp_surname VARCHAR2,
--     birth_date DATE,
--     gender CHAR,
--     salary NUMBER,
--     position_id NUMBER,
--     emp_production_line_id NUMBER
-- ) AS
--     v_production_line_status production_lines.status%TYPE;
--     v_position_exists positions.position_id%TYPE;
-- BEGIN
--     -- Sprawdź, czy linia produkcyjna istnieje i jest aktywna
--     SELECT status
--     INTO v_production_line_status
--     FROM production_lines
--     WHERE production_line_id = emp_production_line_id;

--     IF v_production_line_status = 'ACTIVE' THEN
--         -- Sprawdź, czy pozycja istnieje
--         SELECT position_id
--         INTO v_position_exists
--         FROM positions
--         WHERE position_id = position_id;

--         -- Wstaw nowego pracownika (id generuje się automatycznie)
--         INSERT INTO Employees (name, surname, birth_date, gender, salary, position_id, production_line_id)
--         VALUES (emp_name, emp_surname, birth_date, gender, salary, position_id, emp_production_line_id);

--         DBMS_OUTPUT.PUT_LINE('Employee has been successfully hired.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Production line is not active.');
--     END IF;
-- EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--         DBMS_OUTPUT.PUT_LINE('Production line or position does not exist.');
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
-- END;
-- /


-- Procedura: Zwolnienie pracownika
-- CREATE OR REPLACE PROCEDURE fire_employee (
--     emp_id NUMBER
-- ) AS
-- BEGIN
--     -- Usuń pracownika i sprawdź, czy rekord został usunięty
--     DELETE FROM Employees
--     WHERE EMPLOYEE_ID = emp_id;

--     IF SQL%ROWCOUNT = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Employee with ID ' || emp_id || ' does not exist.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Employee with ID ' || emp_id || ' has been successfully fired.');
--     END IF;
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
-- END;
-- /


-- Procedura: Rejestracja maszyny
CREATE OR REPLACE PROCEDURE register_machine (
    machine_name VARCHAR2,
    machine_type_id NUMBER,
    new_production_line_id NUMBER
) AS
    v_machine_id NUMBER;
    v_production_line_exists NUMBER;
    v_machine_type_exists NUMBER;
BEGIN
    -- Sprawdź, czy linia produkcyjna istnieje
    SELECT COUNT(*)
    INTO v_production_line_exists
    FROM production_lines
    WHERE production_line_id = new_production_line_id;

    IF v_production_line_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Production line with ID ' || new_production_line_id || ' does not exist.');
        RETURN;
    END IF;

    -- Sprawdź, czy typ maszyny istnieje
    SELECT COUNT(*)
    INTO v_machine_type_exists
    FROM Machine_Types
    WHERE machine_type_id = machine_type_id;

    IF v_machine_type_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Machine type with ID ' || machine_type_id || ' does not exist.');
        RETURN;
    END IF;

    -- Wstaw nową maszynę
    INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
    VALUES (machine_name, machine_type_id, new_production_line_id, 'Active')
    RETURNING machine_id INTO v_machine_id;

    -- Zarejestruj zmianę w tabeli historii maszyn
    INSERT INTO MACHINES_HISTORY (machine_id, new_production_line_id, transfer_date)
    VALUES (v_machine_id, new_production_line_id, SYSDATE);

    DBMS_OUTPUT.PUT_LINE('Machine "' || machine_name || '" has been successfully registered with ID ' || v_machine_id || '.');
EXCEPTION
    WHEN OTHERS THEN
        -- Obsłuż nieoczekiwane błędy
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/



-- Procedura: Złomowanie maszyny
CREATE OR REPLACE PROCEDURE scrap_machine (
    machine_id NUMBER
) AS
    v_production_line_id NUMBER;
BEGIN
    -- Sprawdź, czy maszyna istnieje
    SELECT production_line_id
    INTO v_production_line_id
    FROM Machines
    WHERE machine_id = machine_id;

    -- Dodaj wpis do historii maszyn (maszyna przed usunięciem)
    INSERT INTO MACHINES_HISTORY (machine_id, new_production_line_id, transfer_date)
    VALUES (machine_id, NULL, SYSDATE);

    -- Ustawienie numeru linii produkcyjnej na NULL (w razie potrzeby)
    UPDATE Machines
    SET production_line_id = NULL
    WHERE machine_id = machine_id;

    -- Usuń maszynę z tabeli Machines
    DELETE FROM Machines
    WHERE machine_id = machine_id;

    DBMS_OUTPUT.PUT_LINE('Machine with ID ' || machine_id || ' has been scrapped.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Machine with ID ' || machine_id || ' does not exist.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/



-- Procedura: Transfer maszyny
CREATE OR REPLACE PROCEDURE transfer_machine (
    transfered_machine_id NUMBER,
    new_production_line_id NUMBER,
    transfer_date DATE
) AS
    v_machine_exists NUMBER;
    v_production_line_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_machine_exists
    FROM Machines
    WHERE machine_id = transfered_machine_id;

    IF v_machine_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Machine with ID ' || transfered_machine_id || ' does not exist.');
        RETURN;
    END IF;

    SELECT COUNT(*)
    INTO v_production_line_exists
    FROM production_lines
    WHERE production_line_id = new_production_line_id;

    IF v_production_line_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Production line with ID ' || new_production_line_id || ' does not exist.');
        RETURN;
    END IF;

    INSERT INTO Machines_History (machine_id, new_production_line_id, transfer_date)
    VALUES (transfered_machine_id, new_production_line_id, transfer_date);

    UPDATE Machines
    SET production_line_id = new_production_line_id
    WHERE machine_id = transfered_machine_id;

    DBMS_OUTPUT.PUT_LINE('Machine with ID ' || transfered_machine_id || ' has been transferred to production line ' || new_production_line_id);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

-- Procedura: Tworzenie linii produkcyjnej
-- CREATE OR REPLACE PROCEDURE create_production_line (
--     line_name VARCHAR2
-- ) AS
-- BEGIN
--     INSERT INTO Production_Lines (line_name, start_date, status)
--     VALUES (line_name, SYSDATE, 'ACTIVE');

--     DBMS_OUTPUT.PUT_LINE('Production line "' || line_name || '" has been created successfully.');
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
-- END;
-- /


-- Procedura: Usuwanie linii produkcyjnej
CREATE OR REPLACE PROCEDURE remove_production_line (
    production_line_id NUMBER
) AS
BEGIN
    -- Aktualizacja statusu i daty usunięcia
    UPDATE Production_Lines
    SET status = 'INACTIVE',
        removal_date = SYSDATE
    WHERE production_line_id = production_line_id;

    -- Sprawdzenie, czy aktualizacja się powiodła
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No production line found with ID ' || production_line_id || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Production line with ID ' || production_line_id || ' has been marked as removed.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/


-- -- Procedura: Dodanie typu maszyny
-- CREATE OR REPLACE PROCEDURE add_machine_type (
--     type_name VARCHAR2,
--     service_interval_hours NUMBER,
--     service_interval_products NUMBER
-- ) AS
-- BEGIN
--     INSERT INTO Machine_Types (type_name, service_interval_hours, service_interval_products)
--     VALUES (type_name, service_interval_hours, service_interval_products);

--     DBMS_OUTPUT.PUT_LINE('Machine type "' || type_name || '" has been successfully added.');
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
-- END;
-- /


-- Procedura: Tworzenie stanowiska
-- CREATE OR REPLACE PROCEDURE create_position (
--     position_name VARCHAR2,
--     min_salary NUMBER,
--     max_salary NUMBER,
--     service_permission NUMBER
-- ) AS
-- BEGIN
--     INSERT INTO Positions (position_name, min_salary, max_salary, service_permission)
--     VALUES (position_name, min_salary, max_salary, service_permission);

--     DBMS_OUTPUT.PUT_LINE('Position "' || position_name || '" has been successfully created.');
-- EXCEPTION
--     WHEN OTHERS THEN
--         DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
-- END;
-- /


-- Procedura: Wykonanie serwisu
CREATE OR REPLACE PROCEDURE perform_service (
    service_id NUMBER,
    machine_id NUMBER,
    service_date DATE,
    service_cost NUMBER
) AS
BEGIN
    INSERT INTO Services (id, machine_id, service_date, cost)
    VALUES (service_id, machine_id, service_date, service_cost);
END;
/

-- Procedura: Tworzenie produktu
CREATE OR REPLACE PROCEDURE create_product (
    product_name VARCHAR2,
    production_line_id NUMBER,
    product_type VARCHAR2
) AS
BEGIN
    INSERT INTO Products (product_name, production_date, product_type, production_line_id)
    VALUES (product_name, SYSDATE, product_type, production_line_id);

    DBMS_OUTPUT.PUT_LINE('Product "' || product_name || '" has been successfully created.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

