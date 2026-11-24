INSERT INTO Branch VALUES (1,  'Riyadh Branch');
INSERT INTO Branch VALUES (2,  'Jeddah Branch');
INSERT INTO Branch VALUES (3,  'Dammam Branch');
INSERT INTO Branch VALUES (4,  'Yanbu Branch');
INSERT INTO Branch VALUES (5,  'Medina Branch');
INSERT INTO Branch VALUES (6,  'Mecca Branch');
INSERT INTO Branch VALUES (7,  'Tabuk Branch');
INSERT INTO Branch VALUES (8,  'Abha Branch');
INSERT INTO Branch VALUES (9,  'Khobar Branch');
INSERT INTO Branch VALUES (10, 'Taif Branch');


INSERT INTO Employee VALUES (101, 'Ahmed Al-Harbi',         'Branch Manager',      1);
INSERT INTO Employee VALUES (102, 'Muhammed Al-Ghamdi',     'Cashier',             2);
INSERT INTO Employee VALUES (103, 'Khalid Al-Dosari',       'Sales Associate',     3);
INSERT INTO Employee VALUES (104, 'Majid Al-Otaibi',        'Cashier',             4);
INSERT INTO Employee VALUES (105, 'Fahad Al-Juhani',        'Sales Associate',     5);
INSERT INTO Employee VALUES (106, 'Saad Al-Qahtani',        'Branch Manager',      6);
INSERT INTO Employee VALUES (107, 'Omar Al-Shehri',         'Cashier',             7);
INSERT INTO Employee VALUES (108, 'Rakan Al-Harbi',         'Sales Associate',     8);
INSERT INTO Employee VALUES (109, 'Yousef Al-Mutairi',      'Cashier',             9);
INSERT INTO Employee VALUES (110, 'Abdulrahman Al-Subaie',  'Inventory Clerk',     10);


INSERT INTO Customer VALUES (201, 'Abdullah Al-Rashid', 'M');
INSERT INTO Customer VALUES (202, 'Ahmed Al-Saud',      'M');
INSERT INTO Customer VALUES (203, 'Faisal Al-Anazi',    'M');
INSERT INTO Customer VALUES (204, 'Khalid Al-Harthi',   'M');
INSERT INTO Customer VALUES (205, 'Turki Al-Malki',     'M');
INSERT INTO Customer VALUES (206, 'Muhammed Al-Yami',   'M');
INSERT INTO Customer VALUES (207, 'Saad Al-Balawi',     'M');
INSERT INTO Customer VALUES (208, 'Yousef Al-Sulami',   'M');
INSERT INTO Customer VALUES (209, 'Majed Al-Ruwaili',   'M');
INSERT INTO Customer VALUES (210, 'Rakan Al-Harbi',     'M');


INSERT INTO Items VALUES (301, 'Laptop 15 inch',       3500.00,  25, 'Computers');
INSERT INTO Items VALUES (302, 'Wireless Mouse',         45.00, 150, 'Accessories');
INSERT INTO Items VALUES (303, 'Mechanical Keyboard',   120.00,  80, 'Accessories');
INSERT INTO Items VALUES (304, 'Monitor 27 inch',       900.00,  30, 'Computers');
INSERT INTO Items VALUES (305, 'USB Flash Drive 64GB',   35.00, 200, 'Storage');
INSERT INTO Items VALUES (306, 'Bluetooth Headphones',  250.00,  60, 'Audio');
INSERT INTO Items VALUES (307, 'HD Webcam',             180.00,  40, 'Accessories');
INSERT INTO Items VALUES (308, 'Laser Printer',         600.00,  15, 'Printers');
INSERT INTO Items VALUES (309, 'WiFi Router',           220.00,  50, 'Networking');
INSERT INTO Items VALUES (310, 'Power Bank 20000mAh',   110.00,  90, 'Accessories');


INSERT INTO Invoice VALUES (1001, 101, 201, 3500.00, DATE '2026-11-01');
INSERT INTO Invoice VALUES (1002, 102, 202,   90.00, DATE '2026-11-03');
INSERT INTO Invoice VALUES (1003, 103, 203,  120.00, DATE '2026-11-05');
INSERT INTO Invoice VALUES (1004, 104, 204,  900.00, DATE '2026-11-08');
INSERT INTO Invoice VALUES (1005, 105, 205,  105.00, DATE '2026-11-10');
INSERT INTO Invoice VALUES (1006, 106, 206,  250.00, DATE '2026-11-12');
INSERT INTO Invoice VALUES (1007, 107, 207,  360.00, DATE '2026-11-15');
INSERT INTO Invoice VALUES (1008, 108, 208,  600.00, DATE '2026-11-18');
INSERT INTO Invoice VALUES (1009, 109, 209,  440.00, DATE '2026-11-20');
INSERT INTO Invoice VALUES (1010, 110, 210,  440.00, DATE '2026-11-22');


INSERT INTO InvoiceDetail VALUES (1001, 301, 3500.00, 1);
INSERT INTO InvoiceDetail VALUES (1002, 302,   45.00, 2);
INSERT INTO InvoiceDetail VALUES (1003, 303,  120.00, 1);
INSERT INTO InvoiceDetail VALUES (1004, 304,  900.00, 1);
INSERT INTO InvoiceDetail VALUES (1005, 305,   35.00, 3);
INSERT INTO InvoiceDetail VALUES (1006, 306,  250.00, 1);
INSERT INTO InvoiceDetail VALUES (1007, 307,  180.00, 2);
INSERT INTO InvoiceDetail VALUES (1008, 308,  600.00, 1);
INSERT INTO InvoiceDetail VALUES (1009, 309,  220.00, 2);
INSERT INTO InvoiceDetail VALUES (1010, 310,  110.00, 4);

COMMIT;









SELECT COUNT(*) AS Branch
FROM Branch;

SELECT COUNT(*) AS Employee
FROM Employee;

SELECT COUNT(*) AS Customer
FROM Customer;

SELECT COUNT(*) AS Invoice
FROM Invoice;

SELECT COUNT(*) AS InvoiceDetail
FROM InvoiceDetail;

