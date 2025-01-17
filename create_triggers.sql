CREATE OR REPLACE TRIGGER trg_machines_fk_check
BEFORE INSERT OR UPDATE ON Machines
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the machine_type_id exists
    SELECT COUNT(*) INTO v_count
    FROM Machine_Types
    WHERE machine_type_id = :NEW.machine_type_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No machine type exists for the given machine_type_id.');
    END IF;

    -- Check if the production_line_id exists
    SELECT COUNT(*) INTO v_count
    FROM Production_Lines
    WHERE production_line_id = :NEW.production_line_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No production line exists for the given production_line_id.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_services_fk_check
BEFORE INSERT OR UPDATE ON Services
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the machine_id exists
    SELECT COUNT(*) INTO v_count
    FROM Machines
    WHERE machine_id = :NEW.machine_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No machine exists for the given machine_id.');
    END IF;

    -- Check if performed_by (if not NULL) exists in Employees table
    IF :NEW.performed_by IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Employees
        WHERE employee_id = :NEW.performed_by;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'No employee exists for the given performed_by.');
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_products_fk_check
BEFORE INSERT OR UPDATE ON Products
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the production_line_id exists
    SELECT COUNT(*) INTO v_count
    FROM Production_Lines
    WHERE production_line_id = :NEW.production_line_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'No production line exists for the given production_line_id.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_employees_fk_check
BEFORE INSERT OR UPDATE ON Employees
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the position_id exists in the Positions table
    SELECT COUNT(*) INTO v_count
    FROM Positions
    WHERE position_id = :NEW.position_id;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'No position exists for the given position_id.');
    END IF;

    -- Check if the production_line_id exists in the Production_Lines table (if not NULL)
    IF :NEW.production_line_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Production_Lines
        WHERE production_line_id = :NEW.production_line_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'No production line exists for the given production_line_id.');
        END IF;
    END IF;
END;
/
