-- Procedura: Rejestracja maszyny
CREATE OR REPLACE PROCEDURE register_machine (
    machine_name VARCHAR2,
    machine_type_id NUMBER,
    new_production_line_id NUMBER
) AS
    v_machine_id NUMBER;
BEGIN
    -- Wstaw nową maszynę
    INSERT INTO Machines (machine_name, machine_type_id, production_line_id, status)
    VALUES (machine_name, machine_type_id, new_production_line_id, 'ACTIVE')
    RETURNING machine_id INTO v_machine_id;

    -- Zarejestruj zmianę w tabeli historii maszyn
    INSERT INTO Machines_History (machine_id, new_production_line_id, transfer_date)
    VALUES (v_machine_id, new_production_line_id, SYSDATE);

    -- Komunikat o sukcesie
    DBMS_OUTPUT.PUT_LINE('Machine "' || machine_name || '" has been successfully registered with ID ' || v_machine_id || '.');
END;
/


CREATE OR REPLACE PROCEDURE scrap_machine (
    act_machine_id NUMBER
) AS
    v_production_line_id NUMBER;
BEGIN
    -- Sprawdź, czy maszyna istnieje
    SELECT production_line_id
    INTO v_production_line_id
    FROM Machines
    WHERE machine_id = act_machine_id;

    -- Dodaj wpis do historii maszyn (maszyna przed usunięciem)
    INSERT INTO MACHINES_HISTORY (machine_id, new_production_line_id, transfer_date)
    VALUES (act_machine_id, NULL, SYSDATE);

    -- Ustawienie numeru linii produkcyjnej na NULL (w razie potrzeby)
    UPDATE Machines
    SET production_line_id = NULL, status = 'SCRAPED'
    WHERE machine_id = act_machine_id;


    DBMS_OUTPUT.PUT_LINE('Machine with ID ' || act_machine_id || ' has been scrapped.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Jeśli maszyna nie istnieje
        RAISE_APPLICATION_ERROR(-20003, 'Machine with ID ' || act_machine_id || ' does not exist.');
    WHEN OTHERS THEN
        -- Obsłuż inne nieoczekiwane błędy
        RAISE_APPLICATION_ERROR(-20010, 'An unexpected error occurred: ' || SQLERRM);
END;
/



CREATE OR REPLACE PROCEDURE transfer_machine (
    transfered_machine_id NUMBER,
    new_production_line_id NUMBER,
    transfer_date DATE
) AS
    v_machine_exists NUMBER;
    v_production_line_exists NUMBER;
BEGIN
    -- Sprawdź, czy maszyna istnieje
    SELECT COUNT(*)
    INTO v_machine_exists
    FROM Machines
    WHERE machine_id = transfered_machine_id;

    IF v_machine_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Machine with ID ' || transfered_machine_id || ' does not exist.');
        RETURN;
    END IF;

    -- Sprawdź, czy linia produkcyjna istnieje
    SELECT COUNT(*)
    INTO v_production_line_exists
    FROM production_lines
    WHERE production_line_id = new_production_line_id;

    IF v_production_line_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Production line with ID ' || new_production_line_id || ' does not exist.');
        RETURN;
    END IF;

    -- Dodaj wpis do historii maszyn (transfer maszyny)
    INSERT INTO Machines_History (machine_id, new_production_line_id, transfer_date)
    VALUES (transfered_machine_id, new_production_line_id, transfer_date);

    -- Zaktualizuj linię produkcyjną w tabeli Machines
    UPDATE Machines
    SET production_line_id = new_production_line_id
    WHERE machine_id = transfered_machine_id;

    DBMS_OUTPUT.PUT_LINE('Machine with ID ' || transfered_machine_id || ' has been transferred to production line ' || new_production_line_id);
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20010, 'An unexpected error occurred: ' || SQLERRM);
END;
/


-- Procedura: Usuwanie linii produkcyjnej
CREATE OR REPLACE PROCEDURE scrap_production_line (
    act_production_line_id NUMBER
) AS
BEGIN
    -- Aktualizacja statusu i daty usunięcia
    UPDATE Production_Lines
    SET status = 'INACTIVE',
        removal_date = SYSDATE
    WHERE production_line_id = act_production_line_id;

    -- Sprawdzenie, czy aktualizacja się powiodła
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No production line found with ID ' || act_production_line_id || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Production line with ID ' || act_production_line_id || ' has been marked as removed.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE start_service (
    act_machine_id NUMBER,
    new_start_date DATE,
    new_service_name VARCHAR2,
    new_service_reason VARCHAR2,
    new_performed_by NUMBER
) AS
    v_service_id NUMBER;

BEGIN
    -- Aktualizacja statusu maszyny na 'MAINTENANCE'
    UPDATE Machines
    SET status = 'MAINTENANCE'
    WHERE machine_id = act_machine_id;

    -- Dodanie wpisu o serwisie do tabeli Services (status 'PENDING')
    INSERT INTO Services (
        machine_id,
        start_date,
        service_name,
        service_reason,
        service_status,
        performed_by
    ) VALUES (
        act_machine_id,
        new_start_date,
        new_service_name,
        new_service_reason,
        'PENDING', -- Status 'PENDING' przy rozpoczęciu serwisu
        new_performed_by
    )
    RETURNING service_id INTO v_service_id;

    -- Wyświetlenie komunikatu o pomyślnym rozpoczęciu serwisu
    DBMS_OUTPUT.PUT_LINE('Service ' || v_service_id || ' has been successfully started for machine ' || act_machine_id || '.');
END;
/


CREATE OR REPLACE PROCEDURE complete_service (
    act_service_id NUMBER,
    new_service_status VARCHAR2,
    new_end_date DATE
) AS
    v_machine_id NUMBER;
BEGIN
    -- Zaktualizowanie statusu serwisu w tabeli Services oraz dodanie daty zakończenia
    UPDATE Services
    SET service_status = new_service_status, end_date = new_end_date
    WHERE service_id = act_service_id
    RETURNING machine_id INTO v_machine_id;

    -- Sprawdzenie, czy serwis istnieje
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Service with the given ID does not exist.');
    END IF;

    -- Sprawdzenie, czy maszyna została przypisana
    IF v_machine_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'No machine associated with this service.');
    END IF;

    -- Jeśli serwis zakończył się sukcesem, zaktualizuj status maszyny na 'ACTIVE'
    IF new_service_status = 'COMPLETED' THEN
        UPDATE Machines
        SET status = 'ACTIVE'
        WHERE machine_id = v_machine_id;
    END IF;

    -- Jeśli serwis zakończył się niepowodzeniem, maszyna pozostaje w 'MAINTENANCE'
    IF new_service_status = 'FAILED' THEN
        UPDATE Machines
        SET status = 'MAINTENANCE'
        WHERE machine_id = v_machine_id;
    END IF;

    -- Wyświetlenie komunikatu o zakończeniu serwisu
    DBMS_OUTPUT.PUT_LINE('Service ' || act_service_id || ' has been ' || new_service_status || ' for machine ' || v_machine_id || '.');

END;

/


CREATE OR REPLACE PROCEDURE create_product (
    product_name VARCHAR2,
    production_line_id NUMBER,
    product_type VARCHAR2
) AS
    v_cursor SYS_REFCURSOR;
    v_machine_id NUMBER;
    v_machine_requires_service NUMBER;
BEGIN
    -- Sprawdzamy, czy jakakolwiek maszyna na danej linii produkcyjnej wymaga serwisu
    v_cursor := check_production_line_service(production_line_id);

    -- Przechodzimy przez wszystkie maszyny wymagające serwisu
    LOOP
        FETCH v_cursor INTO v_machine_id;
        EXIT WHEN v_cursor%NOTFOUND;

        -- Sprawdzamy, czy maszyna jest aktywna
        SELECT CASE WHEN status = 'ACTIVE' THEN 0 ELSE 1 END
        INTO v_machine_requires_service
        FROM Machines
        WHERE machine_id = v_machine_id;

        -- Jeśli maszyna jest aktywna, zmieniamy jej status na "WAITING_FOR_SERVICE"
        IF v_machine_requires_service = 1 THEN
            UPDATE Machines
            SET status = 'WAITING_FOR_SERVICE'
            WHERE machine_id = v_machine_id;
        END IF;
    END LOOP;

    -- Sprawdzamy, czy są jeszcze maszyny wymagające serwisu
    FETCH v_cursor INTO v_machine_id;
    IF v_cursor%FOUND THEN
        CLOSE v_cursor; -- Zamykanie kursora przed zgłoszeniem błędu
        RAISE_APPLICATION_ERROR(-20007, 'One or more machines on production line ' || production_line_id || ' require service. Product creation is halted.');
    END IF;

    -- Tworzymy nowy produkt
    INSERT INTO Products (product_name, production_date, product_type, production_line_id)
    VALUES (product_name, SYSDATE, product_type, production_line_id);

    -- Zamykamy kursor
    CLOSE v_cursor;

EXCEPTION
    WHEN OTHERS THEN
        -- Zamykanie kursora w przypadku wyjątku
        IF v_cursor%ISOPEN THEN
            CLOSE v_cursor;
        END IF;
        RAISE; -- Przekazanie wyjątku dalej
END;
/




