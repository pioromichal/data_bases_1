

DECLARE
    v_count INT;
    v_name VARCHAR2(30);
    TYPE namesarray IS VARRAY(8) OF VARCHAR2(30); -- Zmieniono na 8, bo jest 8 tabel
    names namesarray;
BEGIN
    -- Kolejność od zależnych do nadrzędnych
    names := namesarray('Machines_History', 'Services', 'Products', 'Employees', 'Machines', 'Positions', 'Production_Lines', 'Machine_Types');

    FOR i IN 1..names.count LOOP
        v_name := names(i);

        -- Sprawdzenie, czy tabela istnieje
        SELECT COUNT(*) INTO v_count FROM user_tables WHERE table_name = UPPER(v_name);
        IF v_count = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Dropping table: ' || v_name);
            EXECUTE IMMEDIATE 'DROP TABLE ' || v_name || ' CASCADE CONSTRAINTS';
        END IF;
    END LOOP;
END;
/


-- Tabela: Machine_Type
CREATE TABLE Machine_Types (
    machine_type_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    type_name VARCHAR2(100) NOT NULL,
    service_interval_hours NUMBER NOT NULL,
    service_interval_products NUMBER NOT NULL
);

-- Tabela: Production_Line
CREATE TABLE Production_Lines (
    production_line_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    line_name VARCHAR2(100) NOT NULL,
    start_date DATE NOT NULL,
    removal_date DATE DEFAULT null,
    status VARCHAR2(50) DEFAULT 'UNKNOWN',
    CONSTRAINT chk_production_lines_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'UNKNOWN'))
);

-- Tabela: Machines
CREATE TABLE Machines (
    machine_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    machine_name VARCHAR2(100) NOT NULL,
    machine_type_id NUMBER NOT NULL,
    production_line_id NUMBER NOT NULL,
    status VARCHAR2(50) DEFAULT 'UNKNOWN',
    FOREIGN KEY (machine_type_id) REFERENCES Machine_Types(machine_type_id),
    FOREIGN KEY (production_line_id) REFERENCES Production_Lines(production_line_id),
    CONSTRAINT chk_machines_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'UNKNOWN'))
);

-- Tabela: Positions
CREATE TABLE Positions (
    position_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    position_name VARCHAR2(50) NOT NULL,
    min_salary NUMBER NOT NULL,
    max_salary NUMBER NOT NULL,
    service_permission NUMBER(1) CHECK (service_permission IN (0, 1))
);

-- Tabela: Employees
CREATE TABLE Employees (
    employee_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    surname VARCHAR2(50) NOT NULL,
    salary NUMBER,
    birth_date DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    position_id NUMBER NOT NULL,
    production_line_id NUMBER,
    FOREIGN KEY (position_id) REFERENCES Positions(position_id),
    FOREIGN KEY (production_line_id) REFERENCES Production_Lines(production_line_id)
);


-- Tabela: Services
CREATE TABLE Services (
    service_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    service_name VARCHAR2(100) NOT NULL,
    machine_id NUMBER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    performed_by NUMBER,
    service_reason VARCHAR2(100) NOT NULL,
    service_status VARCHAR2(50) DEFAULT 'PENDING',
    CONSTRAINT chk_services_status CHECK (service_status IN ('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED')),
    CONSTRAINT chk_services_reason CHECK (service_reason IN ('MAINTENANCE', 'REPAIR', 'INSPECTION', 'UPGRADE')),
    FOREIGN KEY (machine_id) REFERENCES Machines(machine_id),
    FOREIGN KEY (performed_by) REFERENCES Employees(employee_id)
);

-- Tabela: Products
CREATE TABLE Products (
    product_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    production_date DATE NOT NULL,
    product_type VARCHAR2(50) NOT NULL,
    production_line_id NUMBER NOT NULL,
    FOREIGN KEY (production_line_id) REFERENCES Production_Lines(production_line_id)
);

-- Tabela: Machine_History
CREATE TABLE Machines_History (
    history_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    machine_id NUMBER NOT NULL,
    new_production_line_id NUMBER,
    transfer_date DATE NOT NULL,
    new_state VARCHAR2(50) DEFAULT 'UNKNOWN',
    CONSTRAINT chk_machine_history_status CHECK (new_state IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE', 'UNKNOWN')),
    FOREIGN KEY (machine_id) REFERENCES Machines(machine_id),
    FOREIGN KEY (new_production_line_id) REFERENCES Production_Lines(production_line_id)
);

