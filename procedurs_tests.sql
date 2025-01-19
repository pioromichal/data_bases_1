-- REGISTER_MACHINE
-- Test 1: Rejestracja maszyny w istniejącej linii produkcyjnej
BEGIN
    register_machine('Machine Alpha', 1, 1);
END;
/

-- Test 2: Rejestracja maszyny w nieistniejącej linii produkcyjnej (oczekiwany błąd)
BEGIN
    register_machine('Machine Beta', 2, 999); -- Linia produkcyjna 999 nie istnieje
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/
-- SCRAP_MACHINE
-- Test 1: Usunięcie istniejącej maszyny
BEGIN
    scrap_machine(1); -- ID istniejącej maszyny
END;
/
-- Test 2: Usunięcie maszyny, która nie istnieje (oczekiwany błąd)
BEGIN
    scrap_machine(999); -- ID maszyny, która nie istnieje
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- TRANSFER_MACHINE
-- Test 1: Przeniesienie maszyny do istniejącej linii produkcyjnej
BEGIN
    transfer_machine(1, 4, SYSDATE); -- Przenosimy maszynę 1 do linii produkcyjnej 2
END;
/

-- Test 2: Przeniesienie maszyny do nieistniejącej linii produkcyjnej (oczekiwany błąd)
BEGIN
    transfer_machine(1, 999, SYSDATE); -- Linia 999 nie istnieje
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- Test 3: Przeniesienie maszyny, która nie istnieje (oczekiwany błąd)
BEGIN
    transfer_machine(999, 1, SYSDATE); -- Maszyna 999 nie istnieje
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- SCRAP_PRODUCTION_LINE
-- Test 1: Usunięcie istniejącej linii produkcyjnej
BEGIN
    scrap_production_line(1); -- Linia 1 istnieje
END;
/
-- SELECT * from PRODUCTION_LINES;
-- Test 2: Usunięcie linii produkcyjnej, która nie istnieje (oczekiwany błąd lub brak aktualizacji)
BEGIN
    BEGIN
        scrap_production_line(999); -- Linia 999 nie istnieje
    EXCEPTION
        WHEN OTHERS THEN
            -- Obsługuje błąd zgłoszony przez procedurę
            DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
    END;
END;
/
COMMIT;
-- START_SERVICE
-- Test 1: Rozpoczęcie serwisu dla istniejącej maszyny
BEGIN
    start_service(1, SYSDATE, 'Maintenance A', 'INSPECTION', 1); -- Serwis dla maszyny 1
END;
/
COMMIT;
-- Test 2: Rozpoczęcie serwisu dla maszyny, która nie istnieje (oczekiwany błąd)
BEGIN
    start_service(999, SYSDATE, 'Maintenance B', 'INSPECTION', 1);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/
-- SELECT * FROM EMPLOYEES;

-- COMPLETE_SERVICE
-- Test 1: Zakończenie serwisu z sukcesem
BEGIN
    complete_service(2, 'COMPLETED', SYSDATE); -- Serwis 1 zakończony sukcesem dla maszyny 1
END;
/

-- Test 2: Zakończenie serwisu z niepowodzeniem
BEGIN
    complete_service(3, 'FAILED', SYSDATE); -- Serwis 2 zakończony niepowodzeniem dla maszyny 1
END;
/

-- Test 3: Zakończenie serwisu dla maszyny, która nie istnieje (oczekiwany błąd)
BEGIN
    complete_service(999, 'FAILED', SYSDATE);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/
commit;

-- CREATE_PRODUCT
-- Test 1: Tworzenie produktu, gdy wszystkie maszyny na linii produkcyjnej są aktywne
BEGIN
    create_product('Product Alpha', 1, 'Type A'); -- Produkt na linii 1
END;
/

-- Test 2: Tworzenie produktu, gdy maszyny na linii produkcyjnej wymagają serwisu (oczekiwany błąd)
BEGIN
    create_product('Product Beta', 1, 'Type B'); -- Zakładamy, że maszyna na linii 2 wymaga serwisu
EXCEPTION
    WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(check_machine_service(3)); -- Zakładamy, że maszyna istnieje i wymaga serwisu
END;
/

COMMIT;
