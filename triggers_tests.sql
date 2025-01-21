-- Test pozytywny: Dodanie poprawnych danych do tabeli Machines
BEGIN
    INSERT INTO Machines (machine_type_id, production_line_id)
    VALUES (1, 10);  -- Przykładowe istniejące machine_type_id i production_line_id
    DBMS_OUTPUT.PUT_LINE('Machine added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in adding Machine: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący machine_type_id w tabeli Machines
BEGIN
    INSERT INTO Machines (machine_type_id, production_line_id)
    VALUES (9999, 10);  -- Przykładowe nieistniejące machine_type_id
    DBMS_OUTPUT.PUT_LINE('Machine added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Machine: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący production_line_id w tabeli Machines
BEGIN
    INSERT INTO Machines (machine_type_id, production_line_id)
    VALUES (1, 9999);  -- Przykładowe nieistniejące production_line_id
    DBMS_OUTPUT.PUT_LINE('Machine added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Machine: ' || SQLERRM);
END;
/
-- Test pozytywny: Dodanie poprawnych danych do tabeli Services
BEGIN
    INSERT INTO Services (machine_id, performed_by)
    VALUES (100, 200);  -- Przykładowe istniejące machine_id i performed_by (employee_id)
    DBMS_OUTPUT.PUT_LINE('Service record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in adding Service record: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący machine_id w tabeli Services
BEGIN
    INSERT INTO Services (machine_id, performed_by)
    VALUES (9999, 200);  -- Przykładowe nieistniejące machine_id
    DBMS_OUTPUT.PUT_LINE('Service record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Service record: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący performed_by w tabeli Services
BEGIN
    INSERT INTO Services (machine_id, performed_by)
    VALUES (100, 9999);  -- Przykładowe nieistniejące performed_by (employee_id)
    DBMS_OUTPUT.PUT_LINE('Service record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Service record: ' || SQLERRM);
END;
/
-- Test pozytywny: Dodanie poprawnych danych do tabeli Products
BEGIN
    INSERT INTO Products (production_line_id)
    VALUES (10);  -- Przykładowe istniejące production_line_id
    DBMS_OUTPUT.PUT_LINE('Product added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in adding Product: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący production_line_id w tabeli Products
BEGIN
    INSERT INTO Products (production_line_id)
    VALUES (9999);  -- Przykładowe nieistniejące production_line_id
    DBMS_OUTPUT.PUT_LINE('Product added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Product: ' || SQLERRM);
END;
/
-- Test pozytywny: Dodanie poprawnych danych do tabeli Employees
BEGIN
    INSERT INTO Employees (position_id, production_line_id, salary)
    VALUES (1, 10, 3000);  -- Przykładowe istniejące position_id, production_line_id
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in adding Employee: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący position_id w tabeli Employees
BEGIN
    INSERT INTO Employees (position_id, production_line_id, salary)
    VALUES (9999, 10, 3000);  -- Przykładowe nieistniejące position_id
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Employee: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący production_line_id w tabeli Employees
BEGIN
    INSERT INTO Employees (position_id, production_line_id, salary)
    VALUES (1, 9999, 3000);  -- Przykładowe nieistniejące production_line_id
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Employee: ' || SQLERRM);
END;
/
-- Test pozytywny: Dodanie poprawnych danych do tabeli Machines_History
BEGIN
    INSERT INTO Machines_History (machine_id, new_production_line_id)
    VALUES (100, 10);  -- Przykładowe istniejące machine_id i production_line_id
    DBMS_OUTPUT.PUT_LINE('Machine History record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in adding Machine History record: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący machine_id w tabeli Machines_History
BEGIN
    INSERT INTO Machines_History (machine_id, new_production_line_id)
    VALUES (9999, 10);  -- Przykładowe nieistniejące machine_id
    DBMS_OUTPUT.PUT_LINE('Machine History record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Machine History record: ' || SQLERRM);
END;
/
-- Test negatywny: Nieistniejący new_production_line_id w tabeli Machines_History
BEGIN
    INSERT INTO Machines_History (machine_id, new_production_line_id)
    VALUES (100, 9999);  -- Przykładowe nieistniejące new_production_line_id
    DBMS_OUTPUT.PUT_LINE('Machine History record added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Machine History record: ' || SQLERRM);
END;
/
-- Test pozytywny: Aktualizacja min_salary i max_salary w tabeli Employees
BEGIN
    UPDATE Employees
    SET salary = 2500
    WHERE employee_id = 1;  -- Przykładowe istniejące employee_id
    DBMS_OUTPUT.PUT_LINE('Employee salary updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in updating Employee salary: ' || SQLERRM);
END;
/
-- Test pozytywny: Aktualizacja min_salary (nowa pensja niższa)
BEGIN
    UPDATE Employees
    SET salary = 2000
    WHERE employee_id = 1;  -- Przykładowe istniejące employee_id
    DBMS_OUTPUT.PUT_LINE('Employee salary updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in updating Employee salary: ' || SQLERRM);
END;
/
-- Test pozytywny: Aktualizacja max_salary (nowa pensja wyższa)
BEGIN
    UPDATE Employees
    SET salary = 3500
    WHERE employee_id = 1;  -- Przykładowe istniejące employee_id
    DBMS_OUTPUT.PUT_LINE('Employee salary updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in updating Employee salary: ' || SQLERRM);
END;
/
-- Test pozytywny: Pracownik pełnoletni
BEGIN
    INSERT INTO Employees (birth_date)
    VALUES (TO_DATE('2000-01-01', 'YYYY-MM-DD'));  -- Pracownik pełnoletni
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in adding Employee: ' || SQLERRM);
END;
/
-- Test negatywny: Pracownik niepełnoletni
BEGIN
    INSERT INTO Employees (birth_date)
    VALUES (TO_DATE('2010-01-01', 'YYYY-MM-DD'));  -- Pracownik niepełnoletni
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error in adding Employee: ' || SQLERRM);
END;
/