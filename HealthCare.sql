SELECT *
FROM healthcare_dataset;

CREATE TABLE `healthcare_dataset_staging` (
  `People` text,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `Blood_Type` text,
  `Medical_Condition` text,
  `Date_of_Admission` text,
  `Doctor` text,
  `Hospital` text,
  `Insurance_Provider` text,
  `Billing_Amount` double DEFAULT NULL,
  `Room_Number` int DEFAULT NULL,
  `Admission_Type` text,
  `Discharge_Date` text,
  `Medication` text,
  `Test_Results` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO healthcare_dataset_staging
SELECT *
FROM healthcare_dataset;

SELECT *
FROM healthcare_dataset_staging;

WITH CTE AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY People, Age, Gender, Blood_Type, Medical_Condition, Date_of_Admission, Doctor, Hospital, Insurance_Provider, 
Billing_Amount, Room_Number, Admission_Type, Discharge_Date, Medication, Test_Results) AS row_num
FROM healthcare_dataset_staging
)
SELECT *
FROM CTE
WHERE row_num > 1;

SELECT *
FROM healthcare_dataset_staging;

UPDATE healthcare_dataset_staging
SET Date_of_Admission = STR_TO_DATE(Date_of_Admission, '%m/%d/%Y');

ALTER Table healthcare_dataset_staging
MODIFY COLUMN Date_of_Admission DATE;

UPDATE healthcare_dataset_staging
SET Discharge_Date = STR_TO_DATE(Discharge_Date, '%m/%d/%Y');

ALTER TABLE healthcare_dataset_staging
MODIFY COLUMN Discharge_Date DATE;

SELECT *
FROM healthcare_dataset_staging;

WITH CTE_2 AS 
(
SELECT *, ROUND(Billing_Amount, 2) AS Bills
FROM healthcare_dataset_staging
)
UPDATE healthcare_dataset_staging
JOIN CTE_2
	ON healthcare_dataset_staging.People = CTE_2.People
SET healthcare_dataset_staging.Billing_Amount = CTE_2.Bills;

SELECT *
FROM healthcare_dataset_staging;

-- Most Expensive Med Conditions
SELECT Medical_Condition, ROUND(SUM(Billing_Amount), 2) AS BILLED
FROM healthcare_dataset_staging
GROUP BY Medical_Condition
ORDER BY 2;




