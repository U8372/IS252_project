CREATE ROLE Manager;
CREATE ROLE Employee;

CREATE USER POS_Manager  IDENTIFIED BY "Manager_123";
CREATE USER POS_Employee IDENTIFIED BY "Employee_123";



GRANT SELECT, INSERT, UPDATE, DELETE ON pos.Branch        TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON pos.Employee      TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON pos.Customer      TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON pos.Items         TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON pos.Invoice       TO Manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON pos.InvoiceDetail TO Manager;
GRANT EXECUTE                        ON pos.pos_pkg       TO Manager;
GRANT CREATE SESSION                                      TO POS_Manager;

GRANT SELECT  ON pos.Customer      TO Employee;
GRANT SELECT  ON pos.Items         TO Employee;
GRANT INSERT  ON pos.Invoice       TO Employee;
GRANT INSERT  ON pos.InvoiceDetail TO Employee;
GRANT EXECUTE ON pos.pos_pkg       TO Employee;
GRANT CREATE SESSION               TO POS_Employee;



GRANT Manager  TO POS_Manager;
GRANT Employee TO POS_Employee;