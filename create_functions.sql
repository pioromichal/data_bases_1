CREATE OR REPLACE FUNCTION check_machine_service (
    p_machine_id NUMBER
) RETURN NUMBER AS
    v_last_service_date DATE;
    v_service_interval_hours NUMBER;
    v_service_interval_products NUMBER;
    v_produced_products NUMBER;
    v_machine_status VARCHAR2(50);
BEGIN
    -- Pobierz status maszyny
    SELECT status
    INTO v_machine_status
    FROM Machines
    WHERE machine_id = machine_id;

    -- Jeśli maszyna jest w serwisie lub oczekuje na serwis, nie sprawdzaj jej ponownie
    IF v_machine_status IN ('MAINTENANCE', 'PENDING') THEN
        RETURN 1; -- Maszyna już jest w serwisie lub oczekuje na serwis
    END IF;

    -- Pobierz dane maszyny
    SELECT mt.service_interval_hours, mt.service_interval_products
    INTO v_service_interval_hours, v_service_interval_products
    FROM Machines m
    JOIN Machine_Types mt ON m.machine_type_id = mt.machine_type_id
    WHERE m.machine_id = p_machine_id;

    -- Sprawdź datę ostatniego serwisu
    SELECT MAX(END_DATE)
    INTO v_last_service_date
    FROM Services
    WHERE machine_id = p_machine_id AND service_status = 'COMPLETED';

    -- Jeżeli brak rekordów w tabeli Services, uznajemy, że maszyna nie była serwisowana
    IF v_last_service_date IS NULL THEN
        v_last_service_date := SYSDATE - 1000; -- Zakładamy, że maszyna nie była serwisowana przez bardzo długi czas
    END IF;

    -- Sprawdź, ile produktów zostało wyprodukowanych od ostatniego serwisu
    SELECT COUNT(*)
    INTO v_produced_products
    FROM Products
    WHERE production_line_id = (SELECT production_line_id FROM Machines WHERE machine_id = p_machine_id)
    AND production_date > v_last_service_date;

    -- Sprawdź, czy czas od ostatniego serwisu przekroczył interwał serwisowy lub liczba wyprodukowanych produktów
    IF (SYSDATE - v_last_service_date) * 24 >= v_service_interval_hours OR v_produced_products >= v_service_interval_products THEN
        RETURN 1;  -- Maszyna wymaga serwisu
    ELSE
        RETURN 0;  -- Maszyna nie wymaga serwisu
    END IF;

END;
/

CREATE OR REPLACE FUNCTION check_production_line_service (
    p_production_line_id NUMBER
) RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
BEGIN
    -- Otwarcie kursora, który zwróci wszystkie maszyny wymagające serwisu
    OPEN v_cursor FOR
        SELECT m.machine_id
        FROM Machines m
        WHERE m.production_line_id = p_production_line_id
        AND check_machine_service(m.machine_id) = 1;  -- Porównanie do 1, bo funkcja zwraca 1 lub 0

    RETURN v_cursor;
END;


