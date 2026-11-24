CREATE TABLE Branch (
  branchNo    NUMBER        CONSTRAINT pk_branch PRIMARY KEY,
  branchName  VARCHAR2(100) NOT NULL
);

CREATE TABLE Employee (
  employeeNo    NUMBER        CONSTRAINT pk_employee PRIMARY KEY,
  employeeName  VARCHAR2(100) NOT NULL,
  job           VARCHAR2(50)  NOT NULL,
  branchNo      NUMBER        NOT NULL
                CONSTRAINT fk_employee_branch REFERENCES Branch(branchNo)
);

CREATE TABLE Customer (
  customerNo    NUMBER        CONSTRAINT pk_customer PRIMARY KEY,
  customerName  VARCHAR2(100) NOT NULL,
  gender        CHAR(1)       CONSTRAINT ck_customer_gender CHECK (gender IN ('M','F'))
);

CREATE TABLE Items (
  itemNo          NUMBER         CONSTRAINT pk_items PRIMARY KEY,
  itemName        VARCHAR2(100)  NOT NULL,
  price           NUMBER(10,2)   NOT NULL CONSTRAINT ck_items_price CHECK (price > 0),
  total_quantity  NUMBER         NOT NULL CONSTRAINT ck_items_qty   CHECK (total_quantity >= 0),
  category        VARCHAR2(100)  NOT NULL
);

CREATE TABLE Invoice (
  invoiceNo    NUMBER        CONSTRAINT pk_invoice PRIMARY KEY,
  employeeNo   NUMBER        NOT NULL CONSTRAINT fk_invoice_employee REFERENCES Employee(employeeNo),
  customerNo   NUMBER        NOT NULL CONSTRAINT fk_invoice_customer REFERENCES Customer(customerNo),
  total_price  NUMBER(10,2)  NOT NULL CONSTRAINT ck_invoice_total CHECK (total_price >= 0),
  invoiceDate  DATE          NOT NULL
);

CREATE TABLE InvoiceDetail (
  invoiceNo  NUMBER        NOT NULL CONSTRAINT fk_detail_invoice REFERENCES Invoice(invoiceNo),
  itemNo     NUMBER        NOT NULL CONSTRAINT fk_detail_item REFERENCES Items(itemNo),
  paidPrice  NUMBER(10,2)  NOT NULL CONSTRAINT ck_detail_price CHECK (paidPrice > 0),
  quantity   NUMBER        NOT NULL CONSTRAINT ck_detail_qty   CHECK (quantity > 0),
  CONSTRAINT pk_invoicedetail PRIMARY KEY (invoiceNo, itemNo)
);

CREATE TABLE AuditLog (
  logId          NUMBER         CONSTRAINT pk_auditlog PRIMARY KEY,
  tableName      VARCHAR2(50)   NOT NULL,
  operationType  VARCHAR2(10)   NOT NULL,
  recordId       NUMBER,
  oldValues      VARCHAR2(400),
  newValues      VARCHAR2(400),
  changedBy      VARCHAR2(50),
  changeDate     TIMESTAMP      DEFAULT SYSTIMESTAMP
);

CREATE SEQUENCE customer_seq START WITH 211  INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE invoice_seq  START WITH 1011 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE audit_seq    START WITH 1    INCREMENT BY 1 NOCACHE;
