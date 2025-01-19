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
    VALUES (machine_name, machine_type_id, new_production_line_id, 'Active')
    RETURNING machine_id INTO v_machine_id;

    -- Zarejestruj zmianę w tabeli historii maszyn
    INSERT INTO Machines_History (machine_id, new_production_line_id, transfer_date)
    VALUES (v_machine_id, new_production_line_id, SYSDATE);

    -- Komunikat o sukcesie
    DBMS_OUTPUT.PUT_LINE('Machine "' || machine_name || '" has been successfully registered with ID ' || v_machine_id || '.');
END;
/


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
        -- Jeśli maszyna nie istnieje
        RAISE_APPLICATION_ERROR(-20003, 'Machine with ID ' || machine_id || ' does not exist.');
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

-- -- Procedura: Zmiana statusu maszyny na "oczekujący na serwis"
-- CREATE OR REPLACE PROCEDURE change_machine_status_to_service (
--     production_line_id NUMBER
-- ) AS
--     v_machine_id NUMBER;
-- BEGIN
--     -- Znajdź maszynę, która wymaga serwisu
--     SELECT machine_id
--     INTO v_machine_id
--     FROM Machines
--     WHERE production_line_id = production_line_id
--       AND requires_service = 1
--     FETCH FIRST ROW ONLY;

--     IF v_machine_id IS NULL THEN
--         RAISE_APPLICATION_ERROR(-20011, 'No machine on this production line requires service.');
--         RETURN;
--     END IF;

--     -- Zmiana statusu maszyny na "oczekujący na serwis"
--     UPDATE Machines
--     SET status = 'Awaiting Service'
--     WHERE machine_id = v_machine_id;

--     -- Zmiana statusu linii produkcyjnej na "oczekujący na serwis"
--     UPDATE Production_Lines
--     SET status = 'Awaiting Service'
--     WHERE production_line_id = production_line_id
--       AND EXISTS (
--           SELECT 1
--           FROM Machines
--           WHERE production_line_id = production_line_id
--             AND requires_service = 1
--       );

--     DBMS_OUTPUT.PUT_LINE('Machine with ID ' || v_machine_id || ' on production line ' || production_line_id || ' is now awaiting service.');
-- EXCEPTION
--     WHEN OTHERS THEN
--         RAISE_APPLICATION_ERROR(-20012, 'An unexpected error occurred: ' || SQLERRM);
-- END;
-- /



CREATE OR REPLACE PROCEDURE start_service (
    service_id NUMBER,
    machine_id NUMBER,
    start_date DATE,
    service_name VARCHAR2,
    service_reason VARCHAR2,
    performed_by NUMBER  -- ID pracownika wykonującego serwis
) AS
BEGIN
    -- Aktualizacja statusu maszyny na 'MAINTENANCE'
    UPDATE Machines
    SET status = 'MAINTENANCE'
    WHERE machine_id = machine_id;

    -- Dodanie wpisu o serwisie do tabeli Services (status 'PENDING')
    INSERT INTO Services (
        service_id,
        machine_id,
        start_date,
        service_name,
        service_reason,
        service_status,
        performed_by
    ) VALUES (
        service_id,
        machine_id,
        start_date,
        service_name,
        service_reason,
        'PENDING', -- Status 'PENDING' przy rozpoczęciu serwisu
        performed_by
    );

    -- Wyświetlenie komunikatu o pomyślnym rozpoczęciu serwisu
    DBMS_OUTPUT.PUT_LINE('Service ' || service_id || ' has been successfully started for machine ' || machine_id || '.');
END;
/



CREATE OR REPLACE PROCEDURE complete_service (
    service_id NUMBER,
    machine_id NUMBER,
    service_status VARCHAR2,  -- Status serwisu, np. 'COMPLETED', 'FAILED'
    end_date DATE              -- Data zakończenia serwisu
) AS
BEGIN
    -- Zaktualizowanie statusu serwisu w tabeli Services oraz dodanie daty zakończenia
    UPDATE Services
    SET service_status = service_status, end_date = end_date
    WHERE service_id = service_id AND machine_id = machine_id;

    -- Jeśli serwis zakończył się sukcesem, zaktualizuj status maszyny na 'ACTIVE'
    IF service_status = 'COMPLETED' THEN
        UPDATE Machines
        SET status = 'ACTIVE'
        WHERE machine_id = machine_id;
    END IF;

    -- Jeśli serwis zakończył się niepowodzeniem, maszyna pozostaje w 'MAINTENANCE'
    IF service_status = 'FAILED' THEN
        UPDATE Machines
        SET status = 'MAINTENANCE'
        WHERE machine_id = machine_id;
    END IF;

    -- Wyświetlenie komunikatu o zakończeniu serwisu
    DBMS_OUTPUT.PUT_LINE('Service ' || service_id || ' has been ' || service_status || ' for machine ' || machine_id || '.');
END;
/



CREATE OR REPLACE PROCEDURE create_product (
    product_name VARCHAR2,
    production_line_id NUMBER,
    product_type VARCHAR2
) AS
    v_cursor SYS_REFCURSOR;
    v_machine_id NUMBER;
    v_machine_requires_service NUMBER;  -- Zmienna przechowująca informację o stanie maszyny
BEGIN
    -- Sprawdzamy, czy jakakolwiek maszyna na danej linii produkcyjnej wymaga serwisu
    v_cursor := check_production_line_service(production_line_id); -- Funkcja zwraca kursor z maszynami wymagającymi serwisu

    -- Przechodzimy przez wszystkie maszyny wymagające serwisu
    LOOP
        FETCH v_cursor INTO v_machine_id;
        EXIT WHEN v_cursor%NOTFOUND;

        -- Sprawdzamy, czy maszyna jest aktywna
        SELECT CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END
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

    -- Jeśli maszyny wymagają serwisu, przerywamy proces tworzenia produktu i zgłaszamy błąd
    FETCH v_cursor INTO v_machine_id;
    IF v_cursor%FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'One or more machines on production line ' || production_line_id || ' require service. Product creation is halted.');
    END IF;

    -- Tworzymy nowy produkt, jeśli maszyny wymagające serwisu zostały obsłużone
    INSERT INTO Products (product_name, production_date, product_type, production_line_id)
    VALUES (product_name, SYSDATE, product_type, production_line_id);

    -- Zamykamy kursor
    CLOSE v_cursor;

END;
/



