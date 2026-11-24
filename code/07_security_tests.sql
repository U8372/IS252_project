-- Connected as POS_Employee
SELECT * FROM pos.Customer; -- allowed
SELECT * FROM pos.Items;    -- allowed

INSERT INTO pos.Invoice (invoiceNo, employeeNo, customerNo, total_price, invoiceDate) VALUES (2000, 101, 201, 45, SYSDATE); -- allowed
INSERT INTO pos.InvoiceDetail (invoiceNo, itemNo, paidPrice, quantity) VALUES (2000, 302, 45, 1); -- allowed (stock trigger runs)
ROLLBACK;

UPDATE pos.Customer SET customerName = 'X' WHERE customerNo = 201;  -- ERROR EXPECTED
DELETE FROM pos.Items WHERE itemNo = 301;                           -- ERROR EXPECTED
SELECT * FROM pos.Employee;                                         -- ERROR EXPECTED
SELECT * FROM pos.Invoice;                                          -- ERROR EXPECTED (INSERT only)
UPDATE pos.Invoice SET total_price = 0 WHERE invoiceNo = 1001;      -- ERROR EXPECTED










-- Connected as POS_Manager 
SELECT * FROM pos.Branch;                                       -- allowed
UPDATE pos.Items SET price = 3600 WHERE itemNo = 301;           -- allowed
UPDATE pos.Employee SET job = 'Cashier' WHERE employeeNo = 110; -- allowed (audited)
ROLLBACK;