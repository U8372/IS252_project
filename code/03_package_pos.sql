
CREATE OR REPLACE PACKAGE pos_pkg AS

  PROCEDURE add_customer (p_name IN VARCHAR2, p_gender IN CHAR, p_customer_no OUT NUMBER);
  PROCEDURE create_invoice (p_employee_no IN NUMBER, p_customer_no IN NUMBER, p_invoice_no OUT NUMBER);
  PROCEDURE add_invoice_item (p_invoice_no IN NUMBER, p_item_no IN NUMBER, p_quantity IN NUMBER);
  PROCEDURE restock_item (p_item_no IN NUMBER, p_quantity IN NUMBER);
  PROCEDURE cancel_invoice (p_invoice_no IN NUMBER);


  FUNCTION calculate_invoice_total (p_invoice_no IN NUMBER) RETURN NUMBER;
  FUNCTION get_item_stock (p_item_no IN NUMBER) RETURN NUMBER;
  FUNCTION get_customer_total_spent (p_customer_no IN NUMBER) RETURN NUMBER;
  FUNCTION get_branch_employee_count (p_branch_no IN NUMBER) RETURN NUMBER;
  FUNCTION get_branch_sales (p_branch_no IN NUMBER) RETURN NUMBER;

END pos_pkg;
/

CREATE OR REPLACE PACKAGE BODY pos_pkg AS

  PROCEDURE add_customer (p_name IN VARCHAR2, p_gender IN CHAR, p_customer_no OUT NUMBER) IS
  BEGIN
    IF p_name IS NULL OR TRIM(p_name) IS NULL THEN
      RAISE_APPLICATION_ERROR(-20010, 'Customer name cannot be empty.');
    END IF;
    IF p_gender IS NULL OR p_gender NOT IN ('M','F') THEN
      RAISE_APPLICATION_ERROR(-20011, 'Gender must be M or F.');
    END IF;

    p_customer_no := customer_seq.NEXTVAL;
    INSERT INTO Customer (customerNo, customerName, gender)
    VALUES (p_customer_no, p_name, p_gender);
  END add_customer;


  PROCEDURE create_invoice (p_employee_no IN NUMBER, p_customer_no IN NUMBER, p_invoice_no OUT NUMBER) IS
    v_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_cnt FROM Employee WHERE employeeNo = p_employee_no;
    IF v_cnt = 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'Employee ' || p_employee_no || ' does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM Customer WHERE customerNo = p_customer_no;
    IF v_cnt = 0 THEN
      RAISE_APPLICATION_ERROR(-20013, 'Customer ' || p_customer_no || ' does not exist.');
    END IF;

    p_invoice_no := invoice_seq.NEXTVAL;
    INSERT INTO Invoice (invoiceNo, employeeNo, customerNo, total_price, invoiceDate)
    VALUES (p_invoice_no, p_employee_no, p_customer_no, 0, SYSDATE);
  END create_invoice;


  PROCEDURE add_invoice_item (p_invoice_no IN NUMBER, p_item_no IN NUMBER, p_quantity IN NUMBER) IS
    v_price Items.price%TYPE;
    v_cnt   NUMBER;
  BEGIN
    IF p_quantity IS NULL OR p_quantity <= 0 THEN
      RAISE_APPLICATION_ERROR(-20014, 'Quantity must be a positive number.');
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM Invoice WHERE invoiceNo = p_invoice_no;
    IF v_cnt = 0 THEN
      RAISE_APPLICATION_ERROR(-20015, 'Invoice ' || p_invoice_no || ' does not exist.');
    END IF;

    BEGIN
      SELECT price INTO v_price FROM Items WHERE itemNo = p_item_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20016, 'Item ' || p_item_no || ' does not exist.');
    END;

    INSERT INTO InvoiceDetail (invoiceNo, itemNo, paidPrice, quantity)
    VALUES (p_invoice_no, p_item_no, v_price, p_quantity);

    UPDATE Invoice
       SET total_price = calculate_invoice_total(p_invoice_no)
     WHERE invoiceNo = p_invoice_no;
  END add_invoice_item;


  PROCEDURE restock_item (p_item_no IN NUMBER, p_quantity IN NUMBER) IS
  BEGIN
    IF p_quantity IS NULL OR p_quantity <= 0 THEN
      RAISE_APPLICATION_ERROR(-20014, 'Quantity must be a positive number.');
    END IF;

    UPDATE Items
       SET total_quantity = total_quantity + p_quantity
     WHERE itemNo = p_item_no;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20016, 'Item ' || p_item_no || ' does not exist.');
    END IF;
  END restock_item;


  PROCEDURE cancel_invoice (p_invoice_no IN NUMBER) IS
    v_cnt NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_cnt FROM Invoice WHERE invoiceNo = p_invoice_no;
    IF v_cnt = 0 THEN
      RAISE_APPLICATION_ERROR(-20015, 'Invoice ' || p_invoice_no || ' does not exist.');
    END IF;

    -- give the sold quantities back to stock
    FOR d IN (SELECT itemNo, quantity FROM InvoiceDetail WHERE invoiceNo = p_invoice_no) LOOP
      UPDATE Items
         SET total_quantity = total_quantity + d.quantity
       WHERE itemNo = d.itemNo;
    END LOOP;

    DELETE FROM InvoiceDetail WHERE invoiceNo = p_invoice_no;
    DELETE FROM Invoice       WHERE invoiceNo = p_invoice_no;
  END cancel_invoice;





















  FUNCTION calculate_invoice_total (p_invoice_no IN NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(paidPrice * quantity), 0)
      INTO v_total
      FROM InvoiceDetail
     WHERE invoiceNo = p_invoice_no;
    RETURN v_total;
  END calculate_invoice_total;


  FUNCTION get_item_stock (p_item_no IN NUMBER) RETURN NUMBER IS
    v_stock NUMBER;
  BEGIN
    SELECT total_quantity INTO v_stock FROM Items WHERE itemNo = p_item_no;
    RETURN v_stock;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20016, 'Item ' || p_item_no || ' does not exist.');
  END get_item_stock;


  FUNCTION get_customer_total_spent (p_customer_no IN NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(total_price), 0)
      INTO v_total
      FROM Invoice
     WHERE customerNo = p_customer_no;
    RETURN v_total;
  END get_customer_total_spent;


  FUNCTION get_branch_employee_count (p_branch_no IN NUMBER) RETURN NUMBER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Employee WHERE branchNo = p_branch_no;
    RETURN v_count;
  END get_branch_employee_count;


  FUNCTION get_branch_sales (p_branch_no IN NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(i.total_price), 0)
      INTO v_total
      FROM Invoice i
      JOIN Employee e ON e.employeeNo = i.employeeNo
     WHERE e.branchNo = p_branch_no;
    RETURN v_total;
  END get_branch_sales;

END pos_pkg;
/