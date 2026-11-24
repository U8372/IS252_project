SET SERVEROUTPUT ON


-- Functions 
SELECT pos_pkg.calculate_invoice_total(1001)  AS invoice_1001_total   FROM dual;
SELECT pos_pkg.get_item_stock(302)            AS stock_item_302       FROM dual;
SELECT pos_pkg.get_customer_total_spent(201)  AS customer_201_spent   FROM dual;
SELECT pos_pkg.get_branch_employee_count(1)   AS branch_1_employees   FROM dual;
SELECT pos_pkg.get_branch_sales(1)            AS branch_1_sales       FROM dual;

-- Procedures
DECLARE
  v_cust NUMBER;
  v_inv  NUMBER;
BEGIN
  pos_pkg.add_customer('Test Customer', 'M', v_cust);
  pos_pkg.create_invoice(101, v_cust, v_inv);
  pos_pkg.add_invoice_item(v_inv, 302, 3);   
  pos_pkg.add_invoice_item(v_inv, 305, 2);
  DBMS_OUTPUT.PUT_LINE('Customer no : ' || v_cust);
  DBMS_OUTPUT.PUT_LINE('Invoice no  : ' || v_inv);
  DBMS_OUTPUT.PUT_LINE('Invoice total (expected 205): ' || pos_pkg.calculate_invoice_total(v_inv));
  DBMS_OUTPUT.PUT_LINE('Stock item 302 (expected 147): ' || pos_pkg.get_item_stock(302));
  DBMS_OUTPUT.PUT_LINE('Stock item 305 (expected 198): ' || pos_pkg.get_item_stock(305));
END;
/
SELECT * FROM Invoice       WHERE invoiceNo >= 1011;
SELECT * FROM InvoiceDetail WHERE invoiceNo >= 1011;


BEGIN
  pos_pkg.restock_item(308, 10);
  DBMS_OUTPUT.PUT_LINE('Stock item 308 (expected 25): ' || pos_pkg.get_item_stock(308));
END;
/


BEGIN
  pos_pkg.cancel_invoice(1011);
  DBMS_OUTPUT.PUT_LINE('Stock item 302 (expected 150): ' || pos_pkg.get_item_stock(302));
  DBMS_OUTPUT.PUT_LINE('Stock item 305 (expected 200): ' || pos_pkg.get_item_stock(305));
END;
/

-- Trigger
DECLARE
  v_inv NUMBER;
BEGIN
  pos_pkg.create_invoice(101, 201, v_inv);
  pos_pkg.add_invoice_item(v_inv, 308, 9999);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('error: ' || SQLERRM);
    ROLLBACK;
END;
/

UPDATE Customer SET customerName = 'Abdullah Al-Rashid.' WHERE customerNo = 201;
UPDATE Employee SET job = 'Senior Cashier'               WHERE employeeNo = 102;

DECLARE
  v_cust NUMBER;
BEGIN
  pos_pkg.add_customer('Temp Customer', 'F', v_cust);
  DELETE FROM Customer WHERE customerNo = v_cust;
END;
/
COMMIT;

SELECT logId, tableName, operationType, recordId, oldValues, newValues, changedBy,
       TO_CHAR(changeDate, 'YYYY-MM-DD HH24:MI:SS') AS changeDate
  FROM AuditLog
 ORDER BY logId;

-- Constraint
BEGIN
  INSERT INTO Customer VALUES (999, 'Bad Gender', 'X');
EXCEPTION
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('error: ' || SQLERRM);
END;
/


