BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS course (
	course_code VARCHAR NOT NULL PRIMARY KEY, 
	course_title VARCHAR NOT NULL, 
	department VARCHAR NOT NULL
);
INSERT INTO course VALUES('ECBS5148','Data Architecture for Analysts','Department of Economics and Business');
INSERT INTO course VALUES('ECBS6001','Advanced Macroeconomics','Department of Economics and Business');
CREATE TABLE IF NOT EXISTS program (
	program VARCHAR NOT NULL PRIMARY KEY, 
	department VARCHAR NOT NULL
);
INSERT INTO program VALUES('MS in Business Analytics (full time) - Dual','Department of Economics and Business');
INSERT INTO program VALUES('PhD in Economics - Dual','Department of Economics and Business');
INSERT INTO program VALUES('PhD in Cognitive Science – Dual','Department of Cognitive Science');
INSERT INTO program VALUES('MA in Economics - Dual','Department of Economics and Business');
CREATE TABLE IF NOT EXISTS roster (
	course_code VARCHAR NOT NULL, 
	student_id INTEGER NOT NULL, 
	registration_mode VARCHAR NOT NULL
);
INSERT INTO roster VALUES('ECBS5148',1000001,'Grade');
INSERT INTO roster VALUES('ECBS5148',1000002,'Grade');
INSERT INTO roster VALUES('ECBS5148',1000003,'Audit');
INSERT INTO roster VALUES('ECBS5148',1000004,'Grade');
INSERT INTO roster VALUES('ECBS6001',1000003,'Grade');
INSERT INTO roster VALUES('ECBS6001',1000005,'Grade');
CREATE TABLE IF NOT EXISTS student (
	student_id INTEGER NOT NULL PRIMARY KEY, 
	first_name VARCHAR NOT NULL, 
	last_name VARCHAR NOT NULL, 
	program VARCHAR NOT NULL, 
	year INTEGER NOT NULL
);
INSERT INTO student VALUES(1000001,'Sean','Richmond','MS in Business Analytics (full time) - Dual',1);
INSERT INTO student VALUES(1000002,'Dana','McPherson','MS in Business Analytics (full time) - Dual',1);
INSERT INTO student VALUES(1000003,'Csongor','Barta','PhD in Economics - Dual',2);
INSERT INTO student VALUES(1000004,'Hanna','Csatár','PhD in Cognitive Science – Dual',3);
INSERT INTO student VALUES(1000005,'Lyudmila','Vinogradova','MA in Economics - Dual',2);
COMMIT;
