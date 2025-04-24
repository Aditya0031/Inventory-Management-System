-- Presenting to you, GenSEEK.Co : Everything that our generation seeks. All rights reserved. ©

-- DATABASE Creation
show databases;
CREATE DATABASE IF NOT EXISTS Inventory_Management;
USE Inventory_Management;
select database();


-- TABLE CREATION
-- Product Categories Table
CREATE TABLE PRODUCT_CATEGORIES_T (
    category_id_PK INT PRIMARY KEY,
    category_name VARCHAR(50)
);

-- Suppliers Table
CREATE TABLE SUPPLIERS_T (
    supplier_id_PK INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    contact_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(50)
);

-- Create a Lookup Table for US States
CREATE TABLE US_STATES_LOOKUP (
    state_code_PK CHAR(2) primary key,
    state_name VARCHAR(255)
);

-- Customers Table
CREATE TABLE IF NOT EXISTS CUSTOMERS_T (
    customer_id_PK INT PRIMARY KEY,
    F_name VARCHAR(50),
    L_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(15),
    Address_line1 VARCHAR(100),
    STATE char(2),
    city VARCHAR(50),
    Pincode INT,
    FOREIGN KEY (STATE) REFERENCES us_states_lookup(state_code_PK)
);

-- Inventory Items
CREATE TABLE IF NOT EXISTS INVENTORY_ITEMS_T (
    item_id_PK INT PRIMARY KEY,
    SKU_PK VARCHAR(255),
    item_name VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10, 2),
    category_id_FK INT,
    supplier_id_FK INT,
    FOREIGN KEY (category_id_FK) REFERENCES PRODUCT_CATEGORIES_T(category_id_PK),
    FOREIGN KEY (supplier_id_FK) REFERENCES SUPPLIERS_T(supplier_id_PK)
);

-- lookup table
CREATE TABLE DELIVERY_STATUS_LOOKUP (
    status_id INT PRIMARY KEY NOT NULL CHECK(status_id BETWEEN 1 AND 4),
    status_name VARCHAR(20)
);


-- Shipment Tracking Table
CREATE TABLE SHIPMENT_TRACKING_T (
    tracking_id_PK INT PRIMARY KEY,
    item_id_FK INT,
    shipment_date  DATE,
    tracking_number VARCHAR(20),
    status_id_FK INT,
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK),
    FOREIGN KEY (status_id_FK) REFERENCES DELIVERY_STATUS_LOOKUP (status_id)
);


-- Warehouse Table
CREATE TABLE Warehouse (
    warehouse_id_PK INT PRIMARY KEY,
    warehouse_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

-- Warehouse Inventory table
CREATE TABLE WAREHOUSE_INVENTORY_T (
	warehouse_inventory_id_PK INT PRIMARY KEY,
    warehouse_id_FK INT,
    item_id_FK INT,
    quantity INT,
    FOREIGN KEY (warehouse_id_FK) REFERENCES Warehouse(warehouse_id_PK),
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK)
);

-- Return Reasons Table
CREATE TABLE RETURN_REASONS_T (
    reason_id_PK INT PRIMARY KEY,
    reason_description VARCHAR(100)
);

-- Product Reviews Table
CREATE TABLE PRODUCT_REVIEWS_T (
    review_id_PK INT PRIMARY KEY,
    item_id_FK INT,
    customer_id_FK INT,
    rating INT,
    review_text VARCHAR(255),
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK),
    FOREIGN KEY (customer_id_FK) REFERENCES CUSTOMERS_T(customer_id_PK)
);

-- Payment Methods Table + modifying the table
CREATE TABLE PAYMENT_METHODS_LOOKUP (
    method_id_PK INT PRIMARY KEY,
    payment_name VARCHAR(255) NOT NULL
);

-- Orders Table
CREATE TABLE ORDERS_T (
    order_id_PK INT PRIMARY KEY,
    customer_id_FK INT,
    item_id_FK INT,
    quantity INT,
    total_amount DECIMAL(10, 2),
    order_date DATE,
    payment_method_id_FK INT,
    tracking_id_FK INT,
    return_reason_id_FK INT,
    review_id_FK INT,
    FOREIGN KEY (customer_id_FK) REFERENCES CUSTOMERS_T(customer_id_PK),
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK),
    FOREIGN KEY (payment_method_id_FK) REFERENCES PAYMENT_METHODS_LOOKUP(method_id_PK),
    FOREIGN KEY (tracking_id_FK) REFERENCES SHIPMENT_TRACKING_T(tracking_id_PK),
    FOREIGN KEY (return_reason_id_FK) REFERENCES RETURN_REASONS_T(reason_id_PK),
    FOREIGN KEY (review_id_FK) REFERENCES PRODUCT_REVIEWS_T(review_id_PK)
);

-- Sales Transactions Table
CREATE TABLE SALES_TRANSACTIONS_T (
    transaction_id_PK INT PRIMARY KEY,
    order_id_FK INT,
    transaction_date DATE,
    total_amount DECIMAL(10, 2),
    payment_method_id_FK INT,
    FOREIGN KEY (order_id_FK) REFERENCES ORDERS_T(order_id_PK),
    FOREIGN KEY (payment_method_id_FK) REFERENCES PAYMENT_METHODS_LOOKUP(method_id_PK)
);

-- Employees Table
CREATE TABLE EMPLOYEES_T (
    employee_id_PK INT PRIMARY KEY,
    employee_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(15),
    hire_date DATE,
    reports_to char(100),
    job_title varchar(100)
);

CREATE TABLE EMPLOYEE_ASSIGNMENTS_T (
    assignment_id_PK INT PRIMARY KEY,
    employee_id_FK INT,
    warehouse_id_FK INT,
    assignment_start_date DATE,
    assignment_end_date DATE,
    FOREIGN KEY (employee_id_FK) REFERENCES EMPLOYEES_T(employee_id_PK),
    FOREIGN KEY (warehouse_id_FK) REFERENCES Warehouse(warehouse_id_PK)
);

-- Product Discounts Table
CREATE TABLE PRODUCT_DISCOUNTS_T (
    discount_id_PK INT PRIMARY KEY,
    item_id_FK INT,
    discount_percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK)
);

-- Product Images Table
CREATE TABLE PRODUCT_IMAGES_T (
    image_id_PK INT PRIMARY KEY,
    item_id_FK INT,
    image_url VARCHAR(255),
    caption VARCHAR(255),
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK)
);

-- Order Items Table
CREATE TABLE ORDER_ITEMS_T (
    order_item_id_PK INT PRIMARY KEY,
    order_id_FK INT,
    item_id_FK INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (order_id_FK) REFERENCES ORDERS_T(order_id_PK),
    FOREIGN KEY (item_id_FK) REFERENCES INVENTORY_ITEMS_T(item_id_PK)
);

-- To display the total number of tables
show tables;
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = 'Inventory_Management_1';

-- Insert Queries to enter values in the tables

INSERT INTO PAYMENT_METHODS_LOOKUP (method_id_PK, payment_name)
VALUES
    (1, 'Credit Card'),
    (2, 'Debit Card'),
    (3, 'Cash on Delivery'),
    (4, 'PayPal');

INSERT INTO DELIVERY_STATUS_LOOKUP (status_id, status_name)
VALUES
    (1, 'Order Placed'),
    (2, 'Order Shipped'),
    (3, 'Out For Delivery'),
    (4, 'Delivered');

INSERT INTO US_STATES_LOOKUP (state_code_PK, state_name)
VALUES
    ('AL', 'Alabama'),
    ('AK', 'Alaska'),
    ('AZ', 'Arizona'),
    ('AR', 'Arkansas'),
    ('CA', 'California'),
    ('CO', 'Colorado'),
    ('CT', 'Connecticut'),
    ('DE', 'Delaware'),
    ('FL', 'Florida'),
    ('GA', 'Georgia'),
    ('HI', 'Hawaii'),
    ('ID', 'Idaho'),
    ('IL', 'Illinois'),
    ('IN', 'Indiana'),
    ('IA', 'Iowa'),
    ('KS', 'Kansas'),
    ('KY', 'Kentucky'),
    ('LA', 'Louisiana'),
    ('ME', 'Maine'),
    ('MD', 'Maryland'),
    ('MA', 'Massachusetts'),
    ('MI', 'Michigan'),
    ('MN', 'Minnesota'),
    ('MS', 'Mississippi'),
    ('MO', 'Missouri'),
    ('MT', 'Montana'),
    ('NE', 'Nebraska'),
    ('NV', 'Nevada'),
    ('NH', 'New Hampshire'),
    ('NJ', 'New Jersey'),
    ('NM', 'New Mexico'),
    ('NY', 'New York'),
    ('NC', 'North Carolina'),
    ('ND', 'North Dakota'),
    ('OH', 'Ohio'),
    ('OK', 'Oklahoma'),
    ('OR', 'Oregon'),
    ('PA', 'Pennsylvania'),
    ('RI', 'Rhode Island'),
    ('SC', 'South Carolina'),
    ('SD', 'South Dakota'),
    ('TN', 'Tennessee'),
    ('TX', 'Texas'),
    ('UT', 'Utah'),
    ('VT', 'Vermont'),
    ('VA', 'Virginia'),
    ('WA', 'Washington'),
    ('WV', 'West Virginia'),
    ('WI', 'Wisconsin'),
    ('WY', 'Wyoming');

INSERT INTO RETURN_REASONS_T (reason_id_PK, reason_description)
VALUES
    (983307, 'Item not as described'),
    (530447, 'Wrong size or fit'),
    (787373, 'Received damaged item'),
    (226348, 'Changed my mind'),
    (193292, 'Defective product'),
    (455659, 'Received the wrong item'),
    (684366, 'Item doesn''t match the website'),
    (783363, 'Not satisfied with the quality'),
    (389013, 'Item doesn''t meet expectations'),
    (868969, 'Received duplicate item'),
    (672505, 'Item missing parts or accessories'),
    (176892, 'Received expired product'),
    (361022, 'Item doesn''t match the description'),
    (601961, 'Ordered the wrong item'),
    (141996, 'Received the item too late'),
    (509190, 'Item not compatible with my device'),
    (159981, 'Received the wrong color'),
    (978086, 'Item doesn''t work as expected'),
    (773826, 'Changed my purchase decision'),
    (837375, 'Received a different brand than expected');

INSERT INTO CUSTOMERS_T (customer_id_PK, F_name, L_name, email, phone, Address_line1, STATE, city, Pincode)
VALUES
    (744033, 'John', 'Doe', 'john.doe@example.com', '555-1234', '123 Main St', 'CA', 'Los Angeles', 90001),
    (641643, 'Alice', 'Smith', 'alice.smith@example.com', '555-5678', '456 Oak St', 'NY', 'New York', 10001),
    (406822, 'Bob', 'Johnson', 'bob.johnson@example.com', '555-8765', '789 Pine St', 'TX', 'Houston', 77001),
    (106177, 'Eva', 'Williams', 'eva.williams@example.com', '555-4321', '987 Elm St', 'FL', 'Miami', 33101),
    (196694, 'Charlie', 'Davis', 'charlie.davis@example.com', '555-9876', '654 Cedar St', 'IL', 'Chicago', 60601),
    (993150, 'Olivia', 'Miller', 'olivia.miller@example.com', '555-2345', '321 Birch St', 'CA', 'San Francisco', 94101),
    (480744, 'Daniel', 'Brown', 'daniel.brown@example.com', '555-6789', '876 Maple St', 'TX', 'Austin', 73301),
    (185757, 'Sophia', 'Wilson', 'sophia.wilson@example.com', '555-7654', '234 Oak St', 'NY', 'Buffalo', 14201),
    (116293, 'Liam', 'Anderson', 'liam.anderson@example.com', '555-8765', '543 Elm St', 'FL', 'Orlando', 32801),
    (892615, 'Emma', 'Martin', 'emma.martin@example.com', '555-4321', '789 Pine St', 'IL', 'Springfield', 62701),
    (604805, 'Mia', 'Taylor', 'mia.taylor@example.com', '555-1234', '987 Cedar St', 'CA', 'San Diego', 92101),
    (171901, 'Aiden', 'Clark', 'aiden.clark@example.com', '555-5678', '123 Birch St', 'TX', 'Dallas', 75201),
    (303490, 'Isabella', 'Lewis', 'isabella.lewis@example.com', '555-8765', '456 Pine St', 'FL', 'Tampa', 33601),
    (548377, 'Lucas', 'Hill', 'lucas.hill@example.com', '555-2345', '654 Oak St', 'NY', 'Rochester', 14601),
    (487504, 'Ava', 'Wright', 'ava.wright@example.com', '555-9876', '876 Cedar St', 'CA', 'San Jose', 95101),
    (583258, 'Jackson', 'Young', 'jackson.young@example.com', '555-8765', '543 Birch St', 'TX', 'Houston', 77001),
    (602537, 'Chloe', 'Cooper', 'chloe.cooper@example.com', '555-4321', '234 Cedar St', 'IL', 'Chicago', 60601),
    (523863, 'Sophie', 'Evans', 'sophie.evans@example.com', '555-5678', '987 Elm St', 'NY', 'Syracuse', 13201),
    (744563, 'Logan', 'Perez', 'logan.perez@example.com', '555-7654', '456 Maple St', 'CA', 'Los Angeles', 90001),
    (671595, 'Evelyn', 'Fisher', 'evelyn.fisher@example.com', '555-2345', '789 Pine St', 'FL', 'Miami', 33101);

INSERT INTO EMPLOYEES_T (employee_id_PK, employee_name, email, phone, hire_date, reports_to, job_title)
VALUES
    (232707, 'Alice Johnson', 'alice.johnson@example.com', '555-1234', '2021-01-15', NULL, 'CEO'),
    (475230, 'Bob Smith', 'bob.smith@example.com', '555-5678', '2021-02-28', 232707, 'Vice President'),
    (305940, 'Charlie Davis', 'charlie.davis@example.com', '555-8765', '2021-03-15', 475230, 'General Manager'),
    (670179, 'David Wilson', 'david.wilson@example.com', '555-4321', '2021-04-20', 305940, 'Manager'),
    (543594, 'Eva Miller', 'eva.miller@example.com', '555-9876', '2021-05-10', 670179, 'Employee'),
    (820053, 'Frank Brown', 'frank.brown@example.com', '555-2345', '2021-06-02', 305940, 'Manager'),
    (276069, 'Grace Taylor', 'grace.taylor@example.com', '555-6789', '2021-07-18', 820053, 'Employee'),
    (141187, 'Henry Clark', 'henry.clark@example.com', '555-7654', '2021-08-05', 670179, 'Employee'),
    (263987, 'Ivy Lewis', 'ivy.lewis@example.com', '555-8765', '2021-09-12', 820053, 'Employee'),
    (429352, 'Jack Anderson', 'jack.anderson@example.com', '555-4321', '2021-10-25', 670179, 'Employee'),
    (216116, 'Katie Evans', 'katie.evans@example.com', '555-1234', '2021-11-08', 232707, 'Vice President'),
    (806459, 'Liam Young', 'liam.young@example.com', '555-5678', '2021-12-03', 216116, 'General Manager'),
    (231857, 'Mia Perez', 'mia.perez@example.com', '555-8765', '2022-01-17', 806459, 'Manager'),
    (318603, 'Noah Fisher', 'noah.fisher@example.com', '555-9876', '2022-02-22', 231857, 'Employee'),
    (898526, 'Olivia Hill', 'olivia.hill@example.com', '555-2345', '2022-03-10', 231857, 'Employee'),
    (294814, 'Peter Wright', 'peter.wright@example.com', '555-8765', '2022-04-05', 806459, 'Manager'),
    (646311, 'Quinn Cooper', 'quinn.cooper@example.com', '555-4321', '2022-05-19', 294814, 'Employee'),
    (405679, 'Ryan Martin', 'ryan.martin@example.com', '555-1234', '2022-06-28', 294814, 'Employee'),
    (387741, 'Sofia Brown', 'sofia.brown@example.com', '555-5678', '2022-07-15', 806459, 'Manager'),
    (689037, 'Tyler Anderson', 'tyler.anderson@example.com', '555-8765', '2022-08-20', 387741, 'Employee');

INSERT INTO Warehouse (warehouse_id_PK, warehouse_name, location)
VALUES
    (976702, 'Main Warehouse', '123 Warehouse Street, Cityville, State'),
    (307868, 'North Warehouse', '456 Storage Avenue, Townsville, State'),
    (950299, 'East Warehouse', '789 Logistics Lane, Villageton, State'),
    (929209, 'West Warehouse', '987 Distribution Drive, Hamletville, State'),
    (433904, 'Central Warehouse', '654 Supply Street, Boroughtown, State'),
    (642418, 'South Warehouse', '321 Inventory Road, Metropolis, State'),
    (555548, 'West Central Warehouse', '876 Stockpile Boulevard, Cityburg, State'),
    (444049, 'East Central Warehouse', '543 Goods Avenue, Villagetown, State');

INSERT INTO EMPLOYEE_ASSIGNMENTS_T (assignment_id_PK, employee_id_FK, warehouse_id_FK, assignment_start_date, assignment_end_date)
VALUES
    (730554, 232707, 976702, '2021-01-15', '2021-02-28'),
    (399235, 475230, 307868, '2021-03-01', '2021-04-15'),
    (167323, 305940, 950299, '2021-04-16', '2021-05-31'),
    (627861, 670179, 929209, '2021-06-01', '2021-07-15'),
    (626608, 543594, 433904, '2021-07-16', '2021-08-31'),
    (251222, 820053, 642418, '2021-09-01', '2021-10-15'),
    (125291, 276069, 555548, '2021-10-16', '2021-11-30'),
    (965841, 141187, 444049, '2021-12-01', '2022-01-15'),
    (883839, 263987, 976702, '2022-01-16', '2022-02-28'),
    (914943, 429352, 307868, '2022-03-01', '2022-04-15'),
    (343722, 216116, 950299, '2022-04-16', '2022-05-31'),
    (746357, 806459, 929209, '2022-06-01', '2022-07-15'),
    (796955, 231857, 433904, '2022-07-16', '2022-08-31'),
    (152416, 318603, 642418, '2022-09-01', '2022-10-15'),
    (339168, 898526, 555548, '2022-10-16', '2022-11-30'),
    (137161, 294814, 444049, '2022-12-01', '2023-01-15'),
    (686597, 646311, 976702, '2023-01-16', '2023-02-28'),
    (490440, 405679, 307868, '2023-03-01', '2023-04-15'),
    (428959, 387741, 950299, '2023-04-16', '2023-05-31'),
    (412712, 689037, 929209, '2023-06-01', '2023-07-15');

INSERT INTO PRODUCT_CATEGORIES_T (category_id_PK, category_name)
VALUES
    (237509, 'Electronics'),
    (162439, 'Clothing'),
    (443087, 'Home and Kitchen'),
    (468718, 'Sports and Outdoors'),
    (312926, 'Toys and Games'),
    (108849, 'Books'),
    (824415, 'Health and Beauty'),
    (621310, 'Automotive'),
    (209087, 'Furniture'),
    (586187, 'Jewelry'),
    (623844, 'Appliances'),
    (205564, 'Pet Supplies'),
    (735049, 'Office Products'),
    (710365, 'Grocery'),
    (875746, 'Tools and Home Improvement'),
    (643872, 'Baby'),
    (892962, 'Garden and Outdoor'),
    (134990, 'Musical Instruments'),
    (555018, 'Movies and TV Shows'),
    (471374, 'Video Games');

INSERT INTO SUPPLIERS_T (supplier_id_PK, supplier_name, contact_name, phone, email)
VALUES
    (102034, 'ElectroTech Suppliers', 'John Doe', '555-1234', 'john.doe@electrotech.com'),
    (504639, 'FashionR Us', 'Alice Smith', '555-5678', 'alice.smith@fashionrus.com'),
    (749363, 'HomeGoods Co.', 'Bob Johnson', '555-8765', 'bob.johnson@homegoods.com'),
    (258593, 'OutdoorGear Pro', 'Eva Williams', '555-4321', 'eva.williams@outdoorgearpro.com'),
    (175968, 'ToyLand Suppliers', 'Charlie Davis', '555-9876', 'charlie.davis@toyland.com'),
    (906529, 'Book Haven', 'Olivia Miller', '555-2345', 'olivia.miller@bookhaven.com'),
    (582484, 'BeautyHub Suppliers', 'Daniel Brown', '555-6789', 'daniel.brown@beautyhub.com'),
    (168546, 'AutoParts Pro', 'Sophia Wilson', '555-7654', 'sophia.wilson@autopartspro.com'),
    (817571, 'FurnitureCraft', 'Liam Anderson', '555-8765', 'liam.anderson@furniturecraft.com'),
    (871204, 'Gemstone Jewelers', 'Emma Martin', '555-4321', 'emma.martin@gemstonejewelers.com'),
    (688178, 'ApplianceWorld', 'Mia Taylor', '555-1234', 'mia.taylor@applianceworld.com'),
    (744319, 'Pet Paradise', 'Aiden Clark', '555-5678', 'aiden.clark@petparadise.com'),
    (502482, 'OfficeSupplies Co.', 'Isabella Lewis', '555-8765', 'isabella.lewis@officesupplies.com'),
    (787060, 'Grocery Haven', 'Lucas Hill', '555-2345', 'lucas.hill@groceryhaven.com'),
    (211704, 'ToolBox Pro', 'Ava Wright', '555-9876', 'ava.wright@toolboxpro.com'),
    (733608, 'Baby Essentials', 'Jackson Young', '555-8765', 'jackson.young@babyessentials.com'),
    (847376, 'GardenGlo', 'Chloe Cooper', '555-4321', 'chloe.cooper@gardenglo.com'),
    (459143, 'MusicMasters', 'Sophie Evans', '555-5678', 'sophie.evans@musicmasters.com'),
    (791716, 'CineWorld', 'Logan Perez', '555-7654', 'logan.perez@cineworld.com'),
    (348084, 'GameWorld Suppliers', 'Evelyn Fisher', '555-2345', 'evelyn.fisher@gameworld.com');

INSERT INTO INVENTORY_ITEMS_T (item_id_PK, SKU_PK, item_name, quantity, unit_price, category_id_FK, supplier_id_FK)
VALUES
    (363921, 'IPHN15PRO', 'iPhone 15 Pro', 50, 999.99, 237509, 102034),
    (300919, 'LPTP456', 'Laptop XYZ', 20, 899.99, 162439, 504639),
    (376704, 'HDD2TB', '2TB Hard Drive', 100, 79.99, 443087, 749363),
    (618023, 'SECAM1080P', '1080P Security Camera', 30, 129.99, 468718, 258593),
    (182369, 'BLTHSPKR', 'Bluetooth Speaker', 40, 49.99, 312926, 175968),
    (362546, 'TBLTABC', 'Tablet ABC', 15, 199.99, 108849, 906529),
    (355284, 'WLSHDPHN', 'Wireless Headphones', 25, 69.99, 824415, 582484),
    (979681, 'PWRDRILL', 'Power Drill', 10, 129.99, 621310, 168546),
    (566360, 'WLSROUTER', 'Wireless Router', 30, 89.99, 209087, 817571),
    (289989, 'DISHWASHER', 'Dishwasher', 5, 599.99, 586187, 871204),
    (429521, 'IPHN15AM', 'iPhone 15 Pro Max', 50, 1099.99, 623844, 688178),
    (162406, 'LPTPX1', 'Laptop X1', 20, 899.99, 205564, 744319),
    (648801, 'TBHD1TB', '1TB Hard Drive', 100, 79.99, 735049, 502482),
    (246300, 'CAM480P', '480P Security Camera', 30, 129.99, 710365, 787060),
    (478865, 'SPKRBXL', 'Extra Large Speaker', 40, 49.99, 875746, 211704),
    (356849, 'HDPHNBLU', 'Blue Headphones', 15, 199.99, 643872, 733608),
    (304951, 'DVDPLYR2', 'DVD Player 2', 25, 69.99, 892962, 847376),
    (942409, 'LITFLD500', 'Light Flood 500', 10, 129.99, 134990, 459143),
    (357678, 'PNTRLRBLK', 'Black Paint Roller', 30, 89.99, 555018, 791716),
    (337582, 'CLNSHPX', 'Shampoo X', 5, 599.99, 471374, 348084);

INSERT INTO PRODUCT_IMAGES_T (image_id_PK, item_id_FK, image_url, caption)
VALUES
    (139441, 363921, 'image_url_1.jpg', 'Image 1 Caption'),
    (484107, 300919, 'image_url_2.jpg', 'Image 2 Caption'),
    (383353, 376704, 'image_url_3.jpg', 'Image 3 Caption'),
    (852606, 618023, 'image_url_4.jpg', 'Image 4 Caption'),
    (597300, 182369, 'image_url_5.jpg', 'Image 5 Caption'),
    (185033, 362546, 'image_url_6.jpg', 'Image 6 Caption'),
    (297367, 355284, 'image_url_7.jpg', 'Image 7 Caption'),
    (129800, 979681, 'image_url_8.jpg', 'Image 8 Caption'),
    (748000, 566360, 'image_url_9.jpg', 'Image 9 Caption'),
    (423289, 289989, 'image_url_10.jpg', 'Image 10 Caption'),
    (864420, 429521, 'image_url_11.jpg', 'Image 11 Caption'),
    (210298, 162406, 'image_url_12.jpg', 'Image 12 Caption'),
    (733891, 648801, 'image_url_13.jpg', 'Image 13 Caption'),
    (948948, 246300, 'image_url_14.jpg', 'Image 14 Caption'),
    (683201, 478865, 'image_url_15.jpg', 'Image 15 Caption'),
    (758389, 356849, 'image_url_16.jpg', 'Image 16 Caption'),
    (787235, 304951, 'image_url_17.jpg', 'Image 17 Caption'),
    (694231, 942409, 'image_url_18.jpg', 'Image 18 Caption'),
    (965526, 357678, 'image_url_19.jpg', 'Image 19 Caption'),
    (589633, 337582, 'image_url_20.jpg', 'Image 20 Caption');

INSERT INTO PRODUCT_REVIEWS_T (review_id_PK, item_id_FK, customer_id_FK, rating, review_text)
VALUES
    (740422, 363921, 744033, 4, 'Great product! Highly recommended.'),
    (872894, 300919, 641643, 5, 'Amazing quality and performance.'),
    (657281, 376704, 406822, 3, 'Good value for money.'),
    (842145, 618023, 106177, 4, 'Satisfied with the purchase.'),
    (766044, 182369, 196694, 5, 'Excellent service and fast delivery.'),
    (242930, 362546, 993150, 2, 'Not as expected. Disappointed.'),
    (393507, 355284, 480744, 4, 'Impressive design and features.'),
    (842277, 979681, 185757, 5, 'Best purchase ever!'),
    (219501, 566360, 116293, 3, 'Decent product, could be better.'),
    (187193, 289989, 892615, 5, 'Absolutely love it! 5 stars.'),
    (252199, 429521, 604805, 4, 'Impressed with the features.'),
    (779360, 162406, 171901, 5, 'Great quality and fast delivery.'),
    (313156, 648801, 303490, 3, 'Average product, expected more.'),
    (575208, 246300, 548377, 4, 'Satisfied with the purchase.'),
    (630258, 478865, 487504, 5, 'Excellent service and prompt delivery.'),
    (696530, 356849, 583258, 2, 'Not as described. Disappointed.'),
    (467648, 304951, 602537, 4, 'Highly recommend!'),
    (291225, 942409, 523863, 5, 'Outstanding product.'),
    (462726, 357678, 744563, 3, 'Decent but could be better.'),
    (550812, 337582, 671595, 5, 'Absolutely love it! 5 stars.');

INSERT INTO SHIPMENT_TRACKING_T (tracking_id_PK, item_id_FK, shipment_date, tracking_number, status_id_FK)
VALUES
    (372640, 363921, '2023-01-15', '92009753246891027485', 1),
    (719928, 300919, '2023-02-20', '92009753246891027486', 2),
    (582585, 376704, '2023-03-10', '92009753246891027487', 3),
    (180623, 618023, '2023-04-05', '92009753246891027488', 4),
    (220867, 182369, '2023-05-12', '92009753246891027489', 1),
    (304977, 362546, '2023-06-18', '92009753246891027490', 2),
    (217237, 355284, '2023-07-22', '92009753246891027491', 3),
    (212442, 979681, '2023-08-30', '92009753246891027492', 4),
    (469700, 566360, '2023-09-14', '92009753246891027493', 1),
    (951405, 289989, '2023-10-25', '92009753246891027494', 2),
    (333746, 429521, '2023-11-08', '92009753246891027495', 3),
    (416507, 162406, '2023-12-03', '92009753246891027496', 4),
    (664577, 648801, '2024-01-17', '92009753246891027497', 1),
    (675003, 246300, '2024-02-29', '92009753246891027498', 2),
    (663422, 478865, '2024-03-15', '92009753246891027499', 3),
    (954242, 356849, '2024-04-20', '92009753246891027500', 4),
    (814806, 304951, '2024-05-22', '92009753246891027501', 1),
    (300965, 942409, '2024-06-08', '92009753246891027502', 2),
    (357162, 357678, '2024-07-11', '92009753246891027503', 3),
    (683323, 337582, '2024-08-28', '92009753246891027504', 4);

INSERT INTO PRODUCT_DISCOUNTS_T (discount_id_PK, item_id_FK, discount_percentage, start_date, end_date)
VALUES
    (151769, 363921, 20.5, '2023-11-08', '2023-12-21'),
    (234634, 300919, 15.0, '2023-02-20', '2023-03-20'),
    (324371, 376704, 30.0, '2023-03-10', '2023-04-10'),
    (718183, 618023, 25.5, '2023-04-05', '2023-05-05'),
    (717534, 182369, 40.0, '2023-05-12', '2023-06-12'),
    (607857, 362546, 18.0, '2023-11-08', '2023-12-21'),
    (535362, 355284, 12.5, '2023-07-22', '2023-08-22'),
    (483330, 979681, 35.0, '2023-08-30', '2023-09-30'),
    (250156, 566360, 22.5, '2023-09-14', '2023-10-14'),
    (193029, 289989, 10.0, '2023-11-08', '2023-12-21'),
    (801289, 429521, 45.0, '2023-11-08', '2023-12-21'),
    (564251, 162406, 27.5, '2023-12-03', '2024-01-03'),
    (483609, 648801, 20.0, '2024-01-17', '2024-02-17'),
    (966055, 246300, 32.0, '2024-02-29', '2024-03-29'),
    (898440, 478865, 14.5, '2024-03-15', '2024-04-15'),
    (986136, 356849, 38.0, '2024-04-20', '2024-05-20'),
    (929662, 304951, 17.5, '2024-05-22', '2024-06-22'),
    (510652, 942409, 42.0, '2024-06-08', '2024-07-08'),
    (883300, 357678, 29.0, '2024-07-11', '2024-08-11'),
    (838162, 337582, 16.0, '2024-08-28', '2024-09-28');

INSERT INTO ORDERS_T (order_id_PK, customer_id_FK, item_id_FK, quantity, total_amount, order_date, payment_method_id_FK, tracking_id_FK, return_reason_id_FK, review_id_FK)
VALUES
    (692938, 744033, 363921, 2, 150.99, '2023-01-15', 1, 372640, 983307, 740422),
    (206499, 641643, 300919, 1, 89.99, '2023-02-20', 2, 719928, 530447, 872894),
    (365291, 406822, 376704, 3, 299.97, '2023-03-10', 3, 582585, 787373, 657281),
    (282102, 106177, 618023, 1, 199.99, '2023-04-05', 4, 180623, 226348, 842145),
    (962762, 196694, 182369, 2, 179.98, '2023-05-12', 1, 220867, 193292, 766044),
    (218000, 993150, 362546, 1, 129.99, '2023-06-18', 2, 304977, 455659, 242930),
    (979591, 480744, 355284, 2, 249.98, '2023-07-22', 3, 217237, 684366, 393507),
    (290621, 185757, 979681, 1, 79.99, '2023-08-30', 4, 212442, 783363, 842277),
    (937813, 116293, 566360, 3, 299.97, '2023-09-14', 1, 469700, 389013, 219501),
    (382336, 892615, 289989, 1, 149.99, '2023-10-25', 2, 951405, 868969, 187193),
    (416553, 604805, 429521, 2, 120.99, '2023-01-15', 1, 333746, 672505, 252199),
    (284909, 171901, 162406, 1, 79.99, '2023-02-20', 2, 416507, 176892, 779360),
    (784769, 303490, 648801, 3, 239.97, '2023-03-10', 3, 664577, 361022, 313156),
    (887452, 548377, 246300, 1, 129.99, '2023-04-05', 4, 675003, 601961, 575208),
    (153018, 487504, 478865, 2, 159.98, '2023-05-12', 1, 663422, 141996, 630258),
    (424916, 583258, 356849, 2, 120.99, '2023-01-15', 1, 954242, NULL, 696530),
    (416219, 602537, 304951, 1, 79.99, '2023-02-20', 2, 814806, NULL, 467648),
    (111922, 523863, 942409, 3, 239.97, '2023-03-10', 3, 300965, NULL, 291225),
    (266068, 744563, 357678, 1, 129.99, '2023-04-05', 4, 357162, NULL, 462726),
    (933659, 671595, 337582, 2, 159.98, '2023-05-12', 1, 683323, NULL, 550812);

INSERT INTO SALES_TRANSACTIONS_T (transaction_id_PK, order_id_FK, transaction_date, total_amount, payment_method_id_FK)
VALUES
    (711822, 692938, '2023-01-20', 120.99, 1),
    (289850, 206499, '2023-02-25', 79.99, 2),
    (504664, 365291, '2023-03-15', 239.97, 3),
    (810942, 282102, '2023-04-10', 129.99, 4),
    (512260, 962762, '2023-05-17', 159.98, 1),
    (794087, 218000, '2023-06-22', 120.99, 2),
    (487608, 979591, '2023-07-05', 79.99, 3),
    (906225, 290621, '2023-08-12', 239.97, 4),
    (353634, 937813, '2023-09-18', 129.99, 1),
    (704505, 382336, '2023-10-25', 159.98, 2),
    (726147, 416553, '2023-11-30', 120.99, 3),
    (287893, 284909, '2023-12-10', 79.99, 4),
    (783161, 784769, '2024-01-15', 239.97, 1),
    (539237, 887452, '2024-02-20', 129.99, 2),
    (392715, 153018, '2024-03-25', 159.98, 3),
    (862998, 424916, '2024-04-30', 120.99, 4),
    (183127, 416219, '2024-05-05', 79.99, 1),
    (638268, 111922, '2024-06-10', 239.97, 2),
    (286087, 266068, '2024-07-15', 129.99, 3),
    (830682, 933659, '2024-08-20', 159.98, 4);

INSERT INTO ORDER_ITEMS_T (order_item_id_PK, order_id_FK, item_id_FK, quantity, unit_price, total_amount)
VALUES
    (476557, 692938, 363921, 2, 29.99, 59.98),
    (170112, 206499, 300919, 1, 49.99, 49.99),
    (605144, 365291, 376704, 3, 19.99, 59.97),
    (359319, 282102, 618023, 1, 79.99, 79.99),
    (635638, 962762, 182369, 2, 39.99, 79.98),
    (460958, 218000, 362546, 1, 89.99, 89.99),
    (448438, 979591, 355284, 4, 14.99, 59.96),
    (663332, 290621, 979681, 2, 29.99, 59.98),
    (264638, 937813, 566360, 1, 99.99, 99.99),
    (755757, 382336, 289989, 3, 49.99, 149.97),
    (182188, 416553, 429521, 2, 39.99, 79.98),
    (734286, 284909, 162406, 1, 59.99, 59.99),
    (918089, 784769, 648801, 3, 19.99, 59.97),
    (991905, 887452, 246300, 1, 79.99, 79.99),
    (809661, 153018, 478865, 2, 29.99, 59.98),
    (376221, 424916, 356849, 1, 89.99, 89.99),
    (643937, 416219, 304951, 4, 14.99, 59.96),
    (508693, 111922, 942409, 2, 29.99, 59.98),
    (437435, 266068, 357678, 1, 99.99, 99.99),
    (290827, 933659, 337582, 3, 49.99, 149.97);

INSERT INTO WAREHOUSE_INVENTORY_T (warehouse_inventory_id_PK, warehouse_id_FK, item_id_FK, quantity)
VALUES
    (621839, 976702, 363921, 50),
    (928130, 307868, 300919, 30),
    (488109, 950299, 376704, 40),
    (643392, 929209, 618023, 25),
    (298609, 433904, 182369, 60),
    (429818, 642418, 362546, 35),
    (221991, 555548, 355284, 45),
    (554425, 444049, 979681, 55),
    (378945, 976702, 566360, 20),
    (907949, 307868, 289989, 15),
    (685247, 950299, 429521, 10),
    (435784, 929209, 162406, 25),
    (877350, 433904, 648801, 30),
    (854788, 642418, 246300, 40),
    (117242, 555548, 478865, 50),
    (118725, 444049, 356849, 20),
    (261590, 976702, 304951, 15),
    (198161, 307868, 942409, 25),
    (933435, 950299, 357678, 30),
    (263793, 929209, 337582, 35);

-- Complex Queries
-- 1. Retrieve a list of product categories along with the average rating of products in each category. 
-- Display the categories in descending order of the average rating.

SELECT pc.category_id_PK, pc.category_name, AVG(pr.rating) AS average_rating
FROM PRODUCT_CATEGORIES_T pc
JOIN INVENTORY_ITEMS_T i ON pc.category_id_PK = i.category_id_FK
LEFT JOIN PRODUCT_REVIEWS_T pr ON i.item_id_PK = pr.item_id_FK
GROUP BY pc.category_id_PK, pc.category_name
ORDER BY average_rating DESC;

-- 2. Calculate the total purchase made by each customer, including their name and email, 
-- and display the results in descending order of total purchase amount.
SELECT c.customer_id_PK, c.F_name as FirstName, c.L_name as LastName, c.email,
    SUM(i.quantity * i.unit_price) AS total_purchase_amount
FROM CUSTOMERS_T c
JOIN ORDERS_T o ON c.customer_id_PK = o.customer_id_FK
JOIN ORDER_ITEMS_T oi ON o.order_id_PK = oi.order_id_FK
JOIN INVENTORY_ITEMS_T i ON oi.item_id_FK = i.item_id_PK
GROUP BY c.customer_id_PK, c.F_name, c.L_name, c.email
ORDER BY total_purchase_amount DESC;

-- 3.Query to retrive customer shipment status along with tracking number and customer details.
SELECT c.customer_id_PK, c.F_name, c.L_name, i.item_id_PK, i.item_name,
    st.tracking_id_PK, st.shipment_date, st.tracking_number, ds.status_name AS delivery_status
FROM CUSTOMERS_T c
JOIN ORDERS_T o ON c.customer_id_PK = o.customer_id_FK
JOIN SHIPMENT_TRACKING_T st ON o.tracking_id_FK = st.tracking_id_PK
JOIN DELIVERY_STATUS_LOOKUP ds ON st.status_id_FK = ds.status_id
JOIN ORDER_ITEMS_T oi ON o.order_id_PK = oi.order_id_FK
JOIN INVENTORY_ITEMS_T i ON oi.item_id_FK = i.item_id_PK;

-- 4.Calculate the total amount of sales made using each payment method, 
-- and display the payment method name and the total sales amount in descending order of sales.
SELECT pm.payment_name, SUM(ot.total_amount) AS total_sales_amount
FROM PAYMENT_METHODS_LOOKUP pm
JOIN ORDERS_T ot ON pm.method_id_PK = ot.payment_method_id_FK
GROUP BY pm.payment_name
ORDER BY total_sales_amount DESC;

-- 5.Write a query to display the list of employees as an organization tree and show
-- who reports to whom.(Self join)
SELECT
	e.employee_id_PK as Employee_ID,
    CONCAT(e.employee_name, ' (', e.job_title, ')') AS Employee_Name,
    CONCAT(m.employee_name, ' (', m.job_title, ')') AS Reports_to
FROM EMPLOYEES_T m
LEFT JOIN EMPLOYEES_T e ON m.employee_id_PK = e.reports_to
WHERE m.job_title IN ('CEO', 'Vice President', 'General Manager','Manager')
ORDER BY m.employee_name, e.employee_name;

-- Query 6
SELECT 
    i.SKU_PK,
    i.item_name,
    pd.discount_percentage,
    pd.start_date,
    pd.end_date
FROM INVENTORY_ITEMS_T i
LEFT JOIN PRODUCT_DISCOUNTS_T pd ON i.item_id_PK = pd.item_id_FK
WHERE pd.start_date <= CURDATE() AND pd.end_date >= CURDATE(); -- Dishwasher,iPhone 15 Pro,iPhone 15 Pro,Tablet ABC(Made changes)

-- Query 7
SELECT 
    i.item_name,
    SUM(wi.quantity) AS total_quantity_across_warehouses
FROM INVENTORY_ITEMS_T i
LEFT JOIN WAREHOUSE_INVENTORY_T wi ON i.item_id_PK = wi.item_id_FK
WHERE i.item_name = 'Black Paint Roller';

-- Query 8
SELECT 
    ea.assignment_id_PK,
    e.employee_name,
    w.warehouse_name,
    w.location,
    ea.assignment_start_date,
    ea.assignment_end_date
FROM EMPLOYEE_ASSIGNMENTS_T ea
JOIN EMPLOYEES_T e ON ea.employee_id_FK = e.employee_id_PK
JOIN Warehouse w ON ea.warehouse_id_FK = w.warehouse_id_PK;
 
select * from employees_t;
select * from EMPLOYEE_ASSIGNMENTS_T;
select * from Warehouse;    

-- Query 9
SELECT
    C.F_name AS customer_first_name,
    C.L_name AS customer_last_name,
    P.item_name AS product_name,
    PR.rating AS product_rating,
    PR.review_text AS product_review,
    CASE 
        WHEN RR.reason_description IS NOT NULL THEN RR.reason_description
        ELSE 'No return reason'
    END AS return_reasons
FROM CUSTOMERS_T C
JOIN PRODUCT_REVIEWS_T PR ON C.customer_id_PK = PR.customer_id_FK
JOIN INVENTORY_ITEMS_T P ON PR.item_id_FK = P.item_id_PK
LEFT JOIN RETURN_REASONS_T RR ON P.item_id_PK = RR.reason_id_PK;
    
-- Query 10(Sub query)
SELECT
    P.item_name AS product_name,
    (
        SELECT
            AVG(PR.rating)
        FROM PRODUCT_REVIEWS_T PR
        WHERE PR.item_id_FK = P.item_id_PK
    ) 
AS average_rating
FROM INVENTORY_ITEMS_T P;

-- Query 11
SELECT
    C.F_name AS customer_first_name,
    C.L_name AS customer_last_name,
    O.order_id_PK,
    P.item_name AS product_name,
    RR.reason_description AS return_reason
FROM CUSTOMERS_T C
JOIN ORDERS_T O ON C.customer_id_PK = O.customer_id_FK
JOIN ORDER_ITEMS_T OI ON O.order_id_PK = OI.order_id_FK
JOIN INVENTORY_ITEMS_T P ON OI.item_id_FK = P.item_id_PK
JOIN RETURN_REASONS_T RR ON O.return_reason_id_FK = RR.reason_id_PK;
    
-- Stored Procedures
## Retrieve a list of employees based on their job title.
DELIMITER $$
CREATE PROCEDURE get_employees_by_title (IN job_title VARCHAR(100))
BEGIN
  SELECT e.employee_id_pk, e.employee_name, e.job_title
  FROM employees_t e
  WHERE e.job_title = job_title;  
END $$
DELIMITER ;
CALL get_employees_by_title('CEO');

-- Generate a report showing the monthly sales trend over the past year.
DELIMITER $$
CREATE PROCEDURE GenerateMonthlySalesTrendReport()
BEGIN
    SELECT MONTH(order_date) AS month, YEAR(order_date) AS year, SUM(total_amount) AS monthly_sales
    FROM ORDERS_T
    WHERE order_date >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
    GROUP BY YEAR(order_date), MONTH(order_date)
    ORDER BY year, month;
END $$
DELIMITER ;
CALL GenerateMonthlySalesTrendReport();

-- Identify products that have consistently low sales compared to their inventory quantity.  
DELIMITER $$
CREATE PROCEDURE IdentifyLowPerformingProducts()
BEGIN
    SELECT i.item_id_PK, i.item_name, SUM(oi.quantity) AS total_sold, i.quantity AS current_inventory,
           (SUM(oi.quantity) / i.quantity) AS sales_inventory_ratio
    FROM INVENTORY_ITEMS_T i
    LEFT JOIN ORDER_ITEMS_T oi ON i.item_id_PK = oi.item_id_FK
    GROUP BY i.item_id_PK, i.item_name, i.quantity
    HAVING sales_inventory_ratio < 0.04; -- Identify products with less than 4% sales to inventory ratio
END $$
DELIMITER ;
CALL IdentifyLowPerformingProducts();

-- Views
-- Displays information about products, including their name, category, supplier, current quantity in inventory, and unit price.
 
CREATE VIEW ProductInformationView AS
SELECT
    i.item_id_PK AS ProductID,
    i.item_name AS ProductName,
    pc.category_name AS Category,
    s.supplier_name AS Supplier,
    i.quantity AS QuantityInStock,
    i.unit_price AS UnitPrice
FROM
    INVENTORY_ITEMS_T i
    JOIN PRODUCT_CATEGORIES_T pc ON i.category_id_FK = pc.category_id_PK
    JOIN SUPPLIERS_T s ON i.supplier_id_FK = s.supplier_id_PK;
 
 
SELECT * FROM ProductInformationView;
 
-- Shows the order history for each customer, including order date, product details, quantity, and total amount.
 
CREATE VIEW CustomerOrderHistoryView AS
SELECT
    o.order_id_PK AS OrderID,
    o.order_date AS OrderDate,
    c.F_name AS FirstName,
    c.L_name AS LastName,
    i.item_name AS ProductName,
    oi.quantity AS Quantity,
    oi.total_amount AS TotalAmount
FROM
    ORDERS_T o
    JOIN CUSTOMERS_T c ON o.customer_id_FK = c.customer_id_PK
    JOIN ORDER_ITEMS_T oi ON o.order_id_PK = oi.order_id_FK
    JOIN INVENTORY_ITEMS_T i ON oi.item_id_FK = i.item_id_PK;
    
SELECT * FROM CustomerOrderHistoryView;
    
-- Provides information about the inventory in each warehouse, including the warehouse name, location, and the quantity of each product.     
CREATE VIEW WarehouseInventoryView AS
SELECT
    w.warehouse_id_PK AS WarehouseID,
    w.warehouse_name AS WarehouseName,
    w.location AS Location,
    i.item_name AS ProductName,
    wi.quantity AS QuantityInWarehouse
FROM
    WAREHOUSE_INVENTORY_T wi
    JOIN Warehouse w ON wi.warehouse_id_FK = w.warehouse_id_PK
    JOIN INVENTORY_ITEMS_T i ON wi.item_id_FK = i.item_id_PK;
    
SELECT * FROM WarehouseInventoryView;

-- Functions
-- 1.Dynamic Pricing Strategy
DELIMITER $$
CREATE FUNCTION SetDynamicProductPrice(
    item_id_param INT,
	demand_factor DECIMAL(5, 2),
	competitor_price DECIMAL(10, 2),
    market_trend_factor DECIMAL(5, 2)
)
RETURNS DECIMAL(10, 2)
deterministic
BEGIN
    DECLARE current_price DECIMAL(10, 2);
    DECLARE new_price DECIMAL(10, 2);

    -- Get base price of the product
    SELECT unit_price INTO current_price
    FROM inventory_items_t
    WHERE item_id_PK = item_id_param;

    -- Calculate the new price based on factors
    SET new_price = (current_price * 0.5 +
					competitor_price * 0.2 +
                    current_price * (1 + demand_factor) * 0.2
                    ) * market_trend_factor;

    -- Return the new price for reference
    RETURN new_price;
END $$
DELIMITER ;
SELECT item_id_PK, unit_price AS 'Old Price', SetDynamicProductPrice(i.item_id_PK, 1.2, 910.00, 0.80) AS 'New Price' FROM inventory_items_T i ORDER BY unit_price ASC;

-- 2. Customer lifetime value
DELIMITER $$
CREATE FUNCTION CustomerLifetimeValue(
	customer_id_param INT,
    discount_rate DECIMAL(5,2),
    customer_acq_cost INT
)
RETURNS DECIMAL(10, 2)
deterministic
BEGIN
    DECLARE lifetime_value DECIMAL(10, 2);

    -- Calculate customer lifetime value based on total purchases
    SELECT
        SUM(o.total_amount) AS total_purchases
    INTO lifetime_value
    FROM ORDERS_T o
    WHERE o.customer_id_FK = customer_id_param;

    -- Assuming a retention period of 1 year(12 months)
    SET lifetime_value = ((lifetime_value * 12)/ discount_rate) - customer_acq_cost; -- improve the formula

    RETURN lifetime_value;
END $$
DELIMITER ;
select CONCAT(c.F_name, ' ', c.L_name)  As 'Full Name', c.email, 
		CustomerLifetimeValue(c.customer_id_PK, 0.40, 1000) AS 'Customer Lifetime Value'
From customers_t c;

-- Employee Assignment To Warehouse
DELIMITER $$
CREATE FUNCTION AssignEmployeeToWarehouse(
	assignment_id_PK INT,
    employee_id_param INT,
    warehouse_id_param INT,
    assignment_start_date_param DATE,
    assignment_end_date_param DATE
)
RETURNS VARCHAR(255)
deterministic
BEGIN
    DECLARE conflict_count INT;
    
    SELECT COUNT(*) INTO conflict_count
    FROM EMPLOYEE_ASSIGNMENTS_T
    WHERE employee_id_FK = employee_id_param
      AND ((assignment_start_date_param BETWEEN assignment_start_date AND assignment_end_date)
          OR (assignment_end_date_param BETWEEN assignment_start_date AND assignment_end_date));

    IF conflict_count = 0 THEN
        INSERT INTO EMPLOYEE_ASSIGNMENTS_T (
			assignment_id_PK,
            employee_id_FK,
            warehouse_id_FK,
            assignment_start_date,
            assignment_end_date
        ) VALUES (
			assignment_id_PK,
            employee_id_param,
            warehouse_id_param,
            assignment_start_date_param,
            assignment_end_date_param
        );
        RETURN 'Assignment successful';
    ELSE
        RETURN 'Conflicting assignment exists';
    END IF;
END $$
DELIMITER ;
SELECT AssignEmployeeToWarehouse(865789, 305940, 950299, '2021-04-16', '2021-05-31') AS 'Assignment Status';

-- Triggers
-- Trigger 1

DELIMITER $$
CREATE TRIGGER AutoRestockTrigger
BEFORE UPDATE ON INVENTORY_ITEMS_T
FOR EACH ROW
BEGIN
    DECLARE restock_threshold INT;

    -- Set the restock threshold (adjust as needed)
    SET restock_threshold = 10;

    -- Check if the quantity is below the threshold
    IF NEW.quantity < restock_threshold THEN
        -- Perform auto-restock (increase quantity by a predefined amount)
        SET NEW.quantity = NEW.quantity + 20; -- Adjust the restock quantity as needed
    END IF;
END;
$$
DELIMITER ;

select * from inventory_items_t;

UPDATE INVENTORY_ITEMS_T
SET quantity = 5
WHERE item_id_PK = 162406; 

-- Select statement to cross-verify the changes
SELECT * FROM INVENTORY_ITEMS_T WHERE item_id_PK = 162406; 

-------------------------------------------------------------------------------------------------------------------------------

-- Trigger 2

DELIMITER $$
CREATE TRIGGER before_delete_customers
BEFORE DELETE ON CUSTOMERS_T
FOR EACH ROW
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count
    FROM ORDERS_T
    WHERE customer_id_FK = OLD.customer_id_PK;

    IF order_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete customer with pending orders';
    END IF;
END;
$$
DELIMITER ;

DELETE FROM CUSTOMERS_T WHERE customer_id_PK = 106177;
SELECT * FROM CUSTOMERS_T WHERE customer_id_PK = 106177;
select * from customers_T;

------------------------------------------------------------------------------------------------------------------------------
-- Trigger 3
ALTER TABLE PRODUCT_DISCOUNTS_T
ADD COLUMN status VARCHAR(20);

-- Trigger to update product discount status on expiry

DELIMITER $$
CREATE TRIGGER update_product_discount_expiry
BEFORE INSERT ON PRODUCT_DISCOUNTS_T
FOR EACH ROW
BEGIN
    -- Update status of expired discounts
    SET NEW.status = IF(NEW.end_date < CURDATE(), 'Expired', NULL);
END;
$$
DELIMITER ;

SELECT * FROM PRODUCT_DISCOUNTS_T;
INSERT INTO PRODUCT_DISCOUNTS_T (discount_id_PK, item_id_FK, discount_percentage, start_date, end_date)
VALUES (986136, 356849, 38.00, '2023-01-01', '2023-12-03');
