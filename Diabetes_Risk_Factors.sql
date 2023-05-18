--Evaluating data from a table of patients who do or do not have diabetes, and whether they do or do not have diabetes risk factors
--The diabetes column reports '0' for abscence of diabetes, and '1' for presence of diabetes (same for hypertension and heart_disease)
SELECT *
FROM Diabetes_Risks

--EVALUATING EACH RISK INDIVIDUALLY--

WITH HTvsDia (hypertension, diabetes, DiabetesandHypertension)
as
(
SELECT hypertension, diabetes, COUNT((hypertension+diabetes)) as DiabetesandHypertension
FROM Diabetes_Risks
GROUP BY hypertension, diabetes
)
SELECT *, (DiabetesandHypertension*0.001) as PercentByCondition
FROM HTvsDia
--86.103% have neither, only 2.088% have both conditions


WITH HDvsDia (heart_disease, diabetes, DiabetesandHeartDisease)
as
(
SELECT heart_disease, diabetes, COUNT((heart_disease+diabetes)) as DiabetesandHeartDisease
FROM Diabetes_Risks
GROUP BY heart_disease, diabetes
)
SELECT *, (DiabetesandHeartDisease*.001) as PercentByConditions
FROM HDvsDia
ORDER BY heart_disease, diabetes
--88.83% have neither, only 1.27% have both conditions

WITH SmokeVsDiabetes (smoking_history, diabetes, SmokeandDiabetes)
as
(
SELECT smoking_history, diabetes, count((smoking_history + diabetes)) as SmokeandDiabetes
FROM Diabetes_Risks
WHERE smoking_history IS NOT NULL
GROUP BY smoking_history, diabetes
)
SELECT *, (SmokeandDiabetes*.001) as PercentByConditions
FROM SmokeVsDiabetes
--Updated smoking history column so that 0 = never smoked, 1 = former smoker, and 2 = current smoker
--For the purpose of this project I assumed 'not current' meant former smoker, and 'ever' was a typo and meant 'never'


SELECT bmi, 
COUNT(
	CASE 
	WHEN diabetes = 1 THEN diabetes 
	END) as TotalDiabetes
FROM Diabetes_Risks
GROUP BY bmi
ORDER BY TotalDiabetes desc
--Converted BMI from float to int to better visualize any trends
--Utilized a case function to only view patients who have diabetes
--Highest amount of diabetes cases are BMI 27 
SELECT AVG(bmi) as AvgBMI
FROM Diabetes_Risks 
--Simultaneously viewed the average BMI to compare with data from previous query (Avg = 26)


SELECT HbA1c_level, 
COUNT(
	CASE 
	WHEN diabetes = 1 THEN diabetes
	END) as TotalDiabetes
FROM Diabetes_Risks
GROUP BY HbA1c_level
ORDER BY TotalDiabetes desc
--Viewed HbA1c levels similar to BMI levels.
--8/10 of the HbA1c levels with the most diabetes cases are >6%


SELECT blood_glucose_level, 
COUNT(
	CASE 
	WHEN diabetes = 1 THEN diabetes
	END) as TotalDiabetes
FROM Diabetes_Risks
WHERE blood_glucose_level > 126
GROUP BY blood_glucose_level
ORDER BY TotalDiabetes desc
--Once again used a case function to only pull patients with diabetes.
--Included a WHERE clause to only use blood glucose data with 126 mg/dL or greater as that is a standard definition of diabetes.


--Further statistical analysis can be done to better evaluate trends in these risk factors as they relate to presence or absence of diabetes.
--The risk factors together could be used to create predictive models for predicting diabetes based on the risk factors.