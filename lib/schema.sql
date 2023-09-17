CREATE TABLE expense(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       title VARCHAR(100) NOT NULL,
       amount REAL NOT NULL,
       category VARCHAR(100) NOT NULL,
       paid_date VARCHAR(40) DEFAULT CURRENT_TIMESTAMP NOT NULL,
       isRefundable INTEGER DEFAULT 0,
       refundedAmount REAL DEFAULT 0,
       deletionMarker INTEGER DEFAULT 0);

INSERT INTO expense (title, amount, category) VALUES ('Jio recharge', 249, 'Bills');
INSERT INTO expense (title, amount, category) VALUES ('Groceries', 2500, 'Bills');

INSERT INTO expense (title, amount, category, paid_date) VALUES ('Kerala vision', 600, 'Bills', '2023-09-01 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Groceries', 3000, 'Bills', '2023-09-01 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Jio recharge', 249, 'Bills', '2023-09-04 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Pizza', 500, 'Bills', '2023-09-06 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Gold Investment', 3000, 'Bills', '2023-09-07 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Car Petrol', 1000, 'Bills', '2023-09-10 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Bike Service', 2360, 'Bills', '2023-09-10 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Hospital diabetic checkup', 450, 'Bills', '2023-09-11 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Snacks', 150, 'Bills', '2023-09-11 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Fruits and vegetables', 270, 'Bills', '2023-09-13 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Home loan EMI', 7500, 'Bills', '2023-09-14 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Bike EMI', 2700, 'Bills', '2023-09-17 09:20:23');
INSERT INTO expense (title, amount, category, paid_date) VALUES ('Onam dress purchage', 3100, 'Bills', '2023-08-17 09:20:23');
