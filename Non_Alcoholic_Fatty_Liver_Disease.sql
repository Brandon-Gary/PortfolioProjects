--DATA ON PATIENTS WITH NON ALCOHOLIC LIVER DISEASE--
SELECT *
FROM observations

SELECT *
FROM labs

--For this project I joined the tables in every query, but here I display how a temp table of joined tables could be useful to save time for future queries
DROP TABLE IF EXISTS #DiabetesAndLabsTemp

CREATE TABLE #DiabetesAndLabsTemp
(
id float,
age float,
weight float,
height float,
bmi float,
test nvarchar(255),
value float
)
INSERT INTO #DiabetesAndLabsTemp
SELECT Observations.id, Observations.age, Observations.weight, Observations.height, Observations.bmi, labs.test, labs.value
FROM Observations
INNER JOIN labs
	ON Observations.id = labs.id



--Viewing highest to lowest HDL results with corresponding patient age
SELECT observations.id, age, MAX(value) as MaxHDL
FROM observations
INNER JOIN labs
	ON observations.id = labs.id
WHERE test = 'hdl'
GROUP BY observations.id, age
ORDER BY MaxHDL desc, age


--Viewing highest to lowest HDL and CHOL test with corresponding patient bmi
SELECT observations.id, bmi, test, MAX(value) as MaxTestValue
FROM observations
INNER JOIN labs
	ON observations.id = labs.id
WHERE test = 'hdl' OR test = 'chol'
GROUP BY observations.id, bmi, test
ORDER BY bmi desc


--Viewing 3 highest chol tests and corresponding patient age and bmi
select TOP 3 MAX(value) as HighestChol, age, bmi
FROM labs
INNER JOIN observations
	ON labs.id = observations.id
WHERE test = 'chol' AND bmi IS NOT NULL
GROUP BY age, bmi
ORDER BY HighestChol desc


--Viewing average BMI of all patients based on whether they are a smoker or non smoker
SELECT AVG(
			CASE 
			WHEN bmi IS NOT NULL AND test = 'smoke' AND value =1 THEN bmi END) as Avg_Smoker_BMI,
		AVG(
			CASE
			WHEN bmi IS NOT NULL AND test = 'smoke' AND value = 0 THEN bmi END) as Avg_NonSmoker_BMI
FROM observations
INNER JOIN labs
	ON labs.id = observations.id


--Viewing average age of fatty liver disease patients who are now deceased vs alive
--In 'Status' column, 0 = alive and 1 = dead
SELECT  AVG(CASE WHEN status = 1 THEN age END) as Avg_Age_Of_Death,
		AVG(CASE WHEN status = 0 THEN age END) as Avg_Age_Of_Living_Patients
FROM observations





