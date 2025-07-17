CREATE DATABASE MotorQ;

USE MotorQ;
SHOW TABLES;
SELECT * FROM vehicle_data LIMIT 5;
SELECT * FROM trip_data LIMIT 5;
SELECT * FROM dtc_data LIMIT 5;
SELECT * FROM driver_details LIMIT 5;
SELECT * FROM vehicle_assignments LIMIT 5;


-- Q1.Show each vehicle's VIN and the total number of trips taken.

SELECT v.vin AS "VIN",count(t.trip_id) AS "No of Trips per Vehicle" FROM vehicle_data AS v
INNER JOIN trip_data AS t
ON v.vehicle_id=t.vehicle_id
GROUP BY v.vin;


-- Q2.List all vehicles that have never had a diagnostic trouble code reported.

SELECT v.*
FROM vehicle_data AS v
LEFT JOIN dtc_data AS d ON v.vehicle_id = d.vehicle_id
WHERE d.vehicle_id IS NULL;

-- Q3.Find all drivers who have been assigned more than one vehicle.

SELECT a.driver_id
FROM driver_details AS d
INNER JOIN vehicle_assignments AS a ON d.driver_id = a.driver_id
GROUP BY a.driver_id
HAVING COUNT(a.driver_id) > 1;


-- Q4.Display each vehicle and the total distance traveled in 2024, sorted from highest to lowest.

SELECT v.vehicle_id, SUM(distance_km) AS total_distance
FROM vehicle_data AS v
INNER JOIN trip_data AS t ON v.vehicle_id = t.vehicle_id
WHERE YEAR(start_time) = 2024
GROUP BY t.vehicle_id
ORDER BY total_distance DESC;


-- Q5.List the top 3 vehicles that traveled the longest total distance.

SELECT v.vehicle_id, SUM(distance_km) AS total_distance
FROM vehicle_data AS v
INNER JOIN trip_data AS t ON v.vehicle_id = t.vehicle_id
WHERE YEAR(start_time) = 2024
GROUP BY t.vehicle_id
ORDER BY total_distance DESC
LIMIT 3;


-- Q6.Show vehicle models that have both petrol and diesel variants.

SELECT model
FROM vehicle_data
WHERE fuel_type IN ('Petrol', 'Diesel')
GROUP BY model
HAVING COUNT(DISTINCT fuel_type) = 2;


-- Q7.Find the driver(s) assigned to vehicles that have had a diagnostic code severity of 'High'.

SELECT d.*
FROM driver_details AS d
INNER JOIN vehicle_assignments AS v ON d.driver_id = v.driver_id
INNER JOIN dtc_data AS c ON c.vehicle_id = v.vehicle_id
WHERE c.severity = 'High';


-- Q8.Display all VINs where the vehicle has taken at least 10 trips but had no DTCs.

SELECT v.*
FROM vehicle_assignments AS a
INNER JOIN vehicle_data AS v ON a.vehicle_id = v.vehicle_id
WHERE a.vehicle_id NOT IN (
    SELECT t.vehicle_id
    FROM trip_data AS t
    GROUP BY t.vehicle_id
    HAVING COUNT(t.trip_id) > 10
);


-- Q9.List all vehicle IDs that are not assigned to any driver.

SELECT veh.vehicle_id FROM vehicle_data AS veh
LEFT JOIN vehicle_assignments AS assign ON veh.vehicle_id=assign.vehicle_id
WHERE assign.vehicle_id IS NULL;


-- Q10.Find the vehicle(s) that had the highest number of diagnostics reported.

SELECT vehicle_id,COUNT(vehicle_id) AS "No of Diagnostics" FROM dtc_data
GROUP BY vehicle_id
HAVING COUNT(vehicle_id)
ORDER BY COUNT(vehicle_id) DESC
LIMIT 1;

-- Q11.Display fuel types where the average trip distance is more than 200 km.

SELECT veh.fuel_type,ROUND(AVG(trip.distance_km),2) AS "Average Distance" FROM vehicle_data AS veh
INNER JOIN trip_data AS trip
ON veh.vehicle_id=trip.vehicle_id
GROUP BY veh.fuel_type
HAVING AVG(trip.distance_km)>200;

