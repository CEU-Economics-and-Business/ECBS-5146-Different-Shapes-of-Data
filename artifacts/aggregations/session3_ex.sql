
-- Exercise1: Do the same with speed. If speed is NULL or speed < 100 create a "LOW SPEED" category, otherwise, mark as "HIGH SPEED". Use IF instead of CASE!
SELECT aircraft, airline,speed,
	IF(speed < 100 OR SPEED IS NULL,'LOW SPEED','HIGH SPEED') AS speed_category  
	FROM  birdstrikes 
	ORDER BY speed_category;

-- Exercise2: How many distinct 'aircraft' we have in the database?
SELECT COUNT(DISTINCT aircraft) FROM  birdstrikes;
-- 3


-- Exercise3: What was the lowest speed of aircrafts starting with 'H'
SELECT aircraft,MIN(speed) FROM birdstrikes WHERE aircraft LIKE 'H%';
-- 9 






-- Exercise4: Which phase_of_flight has the least of incidents?
SELECT phase_of_flight, COUNT(*) as count 
	FROM birdstrikes GROUP BY phase_of_flight ORDER BY count LIMIT 1;
-- Taxi

-- Exercise5: What is the rounded highest average cost by phase_of_flight?
SELECT phase_of_flight, ROUND(AVG(cost)) as avg_cost  
	FROM birdstrikes GROUP BY phase_of_flight ORDER BY avg_cost DESC LIMIT 1;
-- 54673











-- Exercise6: What the highest AVG speed of the states with names less than 5 characters?
SELECT AVG(speed) as avg_speed,state FROM birdstrikes GROUP BY state HAVING LENGTH(state)<5 AND state!='' ORDER BY avg_speed DESC LIMIT 1;
-- 2862.5000


SELECT state, AVG(speed) AS avg_speed,state FROM birdstrikes WHERE state !='' AND LENGTH(state)<5 GROUP BY state;

