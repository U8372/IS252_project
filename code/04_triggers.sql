CREATE OR REPLACE TRIGGER trg_audit_customer
AFTER UPDATE OR DELETE ON Customer
FOR EACH ROW
DECLARE
  v_op VARCHAR2(10);
BEGIN
  IF UPDATING THEN
   v_op := 'UPDATE';
  ELSE 
   v_op := 'DELETE'; 
  END IF;

  INSERT INTO AuditLog (logId, tableName, operationType, recordId,  oldValues, newValues, changedBy)
  VALUES  (
            audit_seq.NEXTVAL,
            'CUSTOMER',
            v_op,
            :OLD.customerNo,
            'name=' || :OLD.customerName || ', gender=' || :OLD.gender,
            'name=' || :NEW.customerName || ', gender=' || :NEW.gender,
            SYS_CONTEXT('USERENV', 'SESSION_USER')
          );
END trg_audit_customer;
/


CREATE OR REPLACE TRIGGER trg_audit_employee
AFTER UPDATE OR DELETE ON Employee
FOR EACH ROW
DECLARE
  v_op VARCHAR2(10);
BEGIN
  IF UPDATING THEN
    v_op := 'UPDATE'; 
  ELSE 
    v_op := 'DELETE'; 
  END IF;

  INSERT INTO AuditLog (logId, tableName, operationType, recordId, oldValues, newValues, changedBy)
  VALUES (
          audit_seq.NEXTVAL,
          'EMPLOYEE',
          v_op,
          :OLD.employeeNo,
          'name=' || :OLD.employeeName || ', job=' || :OLD.job || ', branch=' || :OLD.branchNo,
          'name=' || :NEW.employeeName || ', job=' || :NEW.job || ', branch=' || :NEW.branchNo,
          SYS_CONTEXT('USERENV', 'SESSION_USER')
         );
END trg_audit_employee;
/










CREATE OR REPLACE TRIGGER trg_check_stock_on_sale
BEFORE INSERT ON InvoiceDetail
FOR EACH ROW
DECLARE
  v_stock Items.total_quantity%TYPE;
BEGIN
  SELECT total_quantity INTO v_stock
  FROM   Items
  WHERE  itemNo = :NEW.itemNo
  FOR UPDATE;

  IF v_stock < :NEW.quantity THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for item ' || :NEW.itemNo || ': requested ' || :NEW.quantity || ', available ' || v_stock);
  END IF;

  UPDATE Items
     SET total_quantity = total_quantity - :NEW.quantity
   WHERE itemNo = :NEW.itemNo;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'Item ' || :NEW.itemNo || ' does not exist.');
END trg_check_stock_on_sale;
/