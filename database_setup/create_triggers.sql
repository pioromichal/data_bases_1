CREATE OR REPLACE TRIGGER trg_machines_fk_check
BEFORE INSERT OR UPDATE ON Machines
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the machine_type_id exists (only if NOT NULL)
    IF :NEW.machine_type_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Machine_Types
        WHERE machine_type_id = :NEW.machine_type_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'No machine type exists for the given machine_type_id.');
        END IF;
    END IF;

    -- Check if the production_line_id exists (only if NOT NULL)
    IF :NEW.production_line_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Production_Lines
        WHERE production_line_id = :NEW.production_line_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No production line exists for the given production_line_id.');
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_services_fk_check
BEFORE INSERT OR UPDATE ON Services
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the machine_id exists (only if NOT NULL)
    IF :NEW.machine_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Machines
        WHERE machine_id = :NEW.machine_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'No machine exists for the given machine_id.');
        END IF;
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
    -- Check if the production_line_id exists (only if NOT NULL)
    IF :NEW.production_line_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Production_Lines
        WHERE production_line_id = :NEW.production_line_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No production line exists for the given production_line_id.');
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_employees_fk_check
BEFORE INSERT OR UPDATE ON Employees
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the position_id exists in the Positions table (only if NOT NULL)
    IF :NEW.position_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Positions
        WHERE position_id = :NEW.position_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'No position exists for the given position_id.');
        END IF;
    END IF;

    -- Check if the production_line_id exists in the Production_Lines table (only if NOT NULL)
    IF :NEW.production_line_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Production_Lines
        WHERE production_line_id = :NEW.production_line_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No production line exists for the given production_line_id.');
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_machines_history_fk_check
BEFORE INSERT OR UPDATE ON Machines_History
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the machine_id exists in the Machines table (only if NOT NULL)
    IF :NEW.machine_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Machines
        WHERE machine_id = :NEW.machine_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'No machine exists for the given machine_id.');
        END IF;
    END IF;

    -- Check if the new_production_line_id exists in the Production_Lines table (only if NOT NULL)
    IF :NEW.new_production_line_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Production_Lines
        WHERE production_line_id = :NEW.new_production_line_id;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No production line exists for the given new_production_line_id.');
        END IF;
    END IF;
END;
/

-- Trigger do aktualizacji min_salary i max_salary w tabeli Positions
CREATE OR REPLACE TRIGGER update_position_salary
AFTER INSERT OR UPDATE ON Employees
FOR EACH ROW
BEGIN
    -- Aktualizacja min_salary, jeśli nowa pensja jest mniejsza
    UPDATE Positions
    SET min_salary = :NEW.salary
    WHERE position_id = :NEW.position_id
      AND (:NEW.salary < min_salary OR min_salary IS NULL);

    -- Aktualizacja max_salary, jeśli nowa pensja jest większa
    UPDATE Positions
    SET max_salary = :NEW.salary
    WHERE position_id = :NEW.position_id
      AND (:NEW.salary > max_salary OR max_salary IS NULL);
END;
/

-- Trigger do sprawdzania pełnoletności pracownika
CREATE OR REPLACE TRIGGER check_employee_majority
AFTER INSERT OR UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF MONTHS_BETWEEN(SYSDATE, :NEW.birth_date) / 12 < 18 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Employee must be at least 18 years old.');
    END IF;
END;
/
