CREATE DATABASE gokuldham_society;
USE gokuldham_society;

-- Create apartments table to store apartment information
CREATE TABLE apartments (
    apartment_id INT PRIMARY KEY,
    apartment_number VARCHAR(10) NOT NULL,
    floor_number INT NOT NULL,
    wing_name CHAR(1) NOT NULL
);

-- Create residents table with foreign key to apartments
CREATE TABLE residents (
    resident_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    occupation VARCHAR(100),
    apartment_id INT,
    FOREIGN KEY (apartment_id) REFERENCES apartments(apartment_id)
);

-- Insert sample apartment data
INSERT INTO apartments (apartment_id, apartment_number, floor_number, wing_name) VALUES
(1, '101', 1, 'A'),
(2, '102', 1, 'A'),
(3, '201', 2, 'A'),
(4, '202', 2, 'A'),
(5, '301', 3, 'A'),
(6, '302', 3, 'A'),
(7, '401', 4, 'A'),
(8, '402', 4, 'A'),
(9, '501', 5, 'B'),
(10, '502', 5, 'B');

-- Insert sample resident data
INSERT INTO residents (resident_id, first_name, last_name, occupation, apartment_id) VALUES
(1, 'Jethalal', 'Gada', 'Electronics Shop Owner', 1),
(2, 'Daya', 'Gada', 'Housewife', 1),
(3, 'Taarak', 'Mehta', 'Writer', 2),
(4, 'Anjali', 'Mehta', 'Teacher', 2),
(5, 'Popatlal', 'Pandey', 'Reporter', 3),
(6, 'Bhide', 'Aatmaram', 'School Teacher', 4),
(7, 'Madhavi', 'Bhide', 'Housewife', 4),
(8, 'Dr', 'Hathi', 'Doctor', 5),
(9, 'Komal', 'Hathi', 'Housewife', 5);


-- Basic SELECT query to view all residents
select *from residents;

-- Create maintenance_requests table with foreign key to apartments
CREATE TABLE maintenance_requests (
    request_id INT PRIMARY KEY,
    apartment_id INT,
    request_date DATE NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (apartment_id) REFERENCES apartments(apartment_id)
);

-- Insert sample maintenance request data
INSERT INTO maintenance_requests (request_id, apartment_id, request_date, description, status) VALUES
(1, 1, '2023-01-15', 'Leaky faucet in kitchen', 'Completed'),
(2, 1, '2023-02-20', 'Broken window handle', 'Completed'),
(3, 2, '2023-03-10', 'Electricity fluctuation', 'In Progress'),
(4, 4, '2023-03-15', 'Ceiling fan not working', 'Pending'),
(5, 5, '2023-04-01', 'Bathroom door lock broken', 'Completed'),
(6, 8, '2023-04-10', 'Water seepage in wall', 'In Progress');

insert into maintenance_requests values(7, 5, '2023-03-15', 'Ceiling fan not working', 'Pending');

-- DEMO: RIGHT JOIN to see all apartments and their residents (if any)
SELECT a.apartment_number, a.floor_number, a.wing_name, 
       r.first_name, r.last_name,r.apartment_id
FROM residents r 
RIGHT JOIN apartments a
ON r.apartment_id = a.apartment_id;

-- EXERCISE 1: Finding Unoccupied Apartments
Select a.apartment_id 
from residents r
RIGHT JOIN apartments a
On a.apartment_id = r.apartment_id
where r.apartment_id is null;

-- EXERCISE 2: Count the number of residents per apartment
Select a.apartment_id,count(a.apartment_id) as Persons,
Group_concat(r.first_name) as Members
from apartments a
right join residents r
on a.apartment_id=r.apartment_id
group by a.apartment_id;

-- EXERCISE 3: List all apartments with their residents and maintenance request status
SELECT
	a.apartment_id, 
    a.apartment_number, 
    a.floor_number, 
    a.wing_name,
    m.description,
    m.status AS maintenance_status
FROM residents r
RIGHT JOIN  apartments a
On a.apartment_id=r.apartment_id
RIGHT JOIN maintenance_requests m
ON m.apartment_id = a.apartment_id;

-- EXERCISE 3: List all apartments with their residents and maintenance request status
SELECT
    m.description,
    GROUP_CONCAT(distinct a.apartment_number ORDER BY a.apartment_number) AS apartments,
    GROUP_CONCAT(
        DISTINCT CONCAT(r.first_name, ' ', r.last_name)
        ORDER BY r.first_name
    ) AS residents,
    m.status AS maintenance_status
FROM residents r
Right join apartments a
    ON a.apartment_id = r.apartment_id
right join maintenance_requests m
    ON a.apartment_id = m.apartment_id
GROUP BY m.description, m.status;


-- EXERCISE 4: Write a query to find the floor with the most unoccupied apartments
SELECT 
    floor_number,
    wing_name,
    COUNT(*) AS unoccupied_count
FROM 
    apartments a
LEFT JOIN 
    residents r ON a.apartment_id = r.apartment_id
WHERE 
    r.resident_id IS NULL
GROUP BY 
    floor_number, wing_name
ORDER BY 
    unoccupied_count DESC
LIMIT 1;



