
-- Sprawdzenie liczby maszyn na każdej linii produkcyjnej
SELECT production_line_id, COUNT(*) AS machine_count
FROM Machines
GROUP BY production_line_id;

-- Weryfikacja, czy pracownicy mają przypisane ważne stanowiska
SELECT e.name, e.surname, e.position_id, p.position_name
FROM Employees e
LEFT JOIN Positions p ON e.position_id = p.position_id
WHERE p.position_id IS NULL;

-- Sprawdzenie, czy maszyny były serwisowane zgodnie z harmonogramem
SELECT m.machine_name, MAX(s.start_date) AS last_service_date
FROM Machines m
LEFT JOIN Services s ON m.machine_id = s.machine_id
GROUP BY m.machine_name
HAVING MAX(s.start_date) < SYSDATE - INTERVAL '6' MONTH;




-- Łączenie tabel i filtrowanie maszyn aktywnych z ich typami
SELECT m.machine_name, mt.type_name, m.status
FROM Machines m
JOIN Machine_Types mt ON m.machine_type_id = mt.machine_type_id
WHERE m.status = 'ACTIVE';

-- Zestawienie pracowników i linii produkcyjnych z przypisaniem ich stanowisk
SELECT e.name, e.surname, p.position_name, pl.line_name
FROM Employees e
LEFT JOIN Positions p ON e.position_id = p.position_id
LEFT JOIN Production_Lines pl ON e.production_line_id = pl.production_line_id;

-- Sumaryczna liczba produktów wytworzonych na każdej linii produkcyjnej
SELECT pl.line_name, COUNT(p.product_id) AS total_products
FROM Production_Lines pl
JOIN Products p ON pl.production_line_id = p.production_line_id
GROUP BY pl.line_name;

-- Lista maszyn, które były przeniesione między liniami produkcyjnymi
SELECT mh.machine_id, mh.transfer_date, pl.line_name AS new_line_name
FROM Machines_History mh
JOIN Production_Lines pl ON mh.new_production_line_id = pl.production_line_id
WHERE mh.new_state = 'ACTIVE';

-- Wykaz serwisów przeprowadzonych przez konkretnych pracowników
SELECT s.service_name, e.name AS employee_name, e.surname, s.start_date, s.service_reason
FROM Services s
LEFT JOIN Employees e ON s.performed_by = e.employee_id
WHERE s.service_status = 'COMPLETED';



