create database ManufacturingData;
show databases;
use manufacturingdata;
desc manufacturingdata;
select * from manufacturingdata;
select count(*) from manufacturingdata;
select count(distinct(empcode)) from manufacturingdata;

## 1. MANUFACTURED QUANTITY
SELECT 
    SUM(MANUFACTUREDQUANTITY) AS 'Manufactured Quantity'
FROM
    manufacturingdata;
    
## Manufactured Quantity in Millions
SELECT 
    CONCAT(ROUND(SUM(manufacturedquantity) / 1000000.0, 2),
            'M') AS 'Manufactured Quantity (M)'
FROM
    manufacturingdata;
    
    ## 2. REJECTED QUANTITY
SELECT 
    SUM(REJECTEDQUANTITY) AS 'Rejected Quantity'
FROM
    manufacturingdata;
    
    ## REJECTED QUANTITY IN THOUSANDS
SELECT 
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000.0, 2),
            'K') AS 'REJECTED QUANTITY (K)'
FROM
    manufacturingdata;
    
## 3. PROCESSED QUANTITY
SELECT 
    SUM(PROCESSEDQUANTITY) AS 'Processed Quantity'
FROM
    manufacturingdata;
    
## Processed Quantity in Millions
SELECT 
    CONCAT(ROUND(SUM(PROCESSEDQUANTITY) / 1000000, 2),
            'M') AS 'PROCESSED QUANTITY (M)'
FROM
    manufacturingdata;

## 4. Wastage Quantity Percentage
SELECT 
    CONCAT(ROUND((SUM(REJECTEDQUANTITY) / SUM(PROCESSEDQUANTITY)) * 100,
                    2),
            '%') AS 'Wastage Quantity'
FROM
    manufacturingdata;
    
## 5. Employee Name-wise Rejected Quantity
SELECT 
    EMPNAME AS `Employee Name`,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000.0, 2),
            'K') AS `REJECTED QUANTITY`
FROM
    manufacturingdata
GROUP BY EMPNAME
ORDER BY SUM(REJECTEDQUANTITY) DESC;

## 6. EMP Code-wise Rejected Quantity
SELECT 
    EMPCODE,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000.0, 2),
            'K') AS `REJECTED QUANTITY`
FROM
    manufacturingdata
GROUP BY EMPCODE
ORDER BY SUM(REJECTEDQUANTITY) DESC;

# 7. Machine-wise rejected Quantity
-- distinct count of machines.
SELECT 
    COUNT(DISTINCT (MACHINECODE)) AS TOTALMACHINES
FROM
    MANUFACTURINGDATA;

-- Machine code wise rejected quantity
SELECT 
    MACHINECODE,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) /1000,2), "K") AS `Machine-wise Rejected Quantity`
FROM
    manufacturingdata
GROUP BY MACHINECODE
ORDER BY SUM(REJECTEDQUANTITY) DESC;

#8. PRODUCTION COMPARISON TREND
SELECT * FROM manufacturingdata;
desc manufacturingdata;
select monthname(docdate) from manufacturingdata;

-- I. Month-wise processed quantiy, rejected quantity and rejection rate
SELECT 
    MONTHNAME(DOCDATE) AS MONTH,
    CONCAT(ROUND(SUM(processedquantity) / 1000000, 2),
            'M') AS TotalProcessed,
    CONCAT(ROUND(SUM(rejectedquantity) / 1000, 2),
            'K') AS TotalRejected,
    CONCAT(ROUND(SUM(rejectedquantity) / SUM(processedquantity) * 100,
                    2),
            '%') AS REJECTIONRATE
FROM
    manufacturingdata
GROUP BY MONTHNAME(docdate)
ORDER BY SUM(rejectedquantity) / SUM(processedquantity) DESC;

-- II. Employee-wise Rejection Rate
SELECT 
    empname AS ENAME,
    CONCAT(ROUND(SUM(PROCESSEDQUANTITY)/1000000, 2), "M") AS TOTALPROCESSED,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY)/1000,3), "K") AS TOTALREJECTED,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / SUM(PROCESSEDQUANTITY) * 100,
                    2),
            '%') AS REJECTIONRATE
FROM
    manufacturingdata
GROUP BY ENAME
ORDER BY SUM(REJECTEDQUANTITY) DESC;

-- III. TOP 20 EMPCODE-WISE REJECTION RATE
SELECT 
    empcode AS ecode,
    CONCAT(ROUND(SUM(processedquantity) / 1000, 2),
            'K') AS totalprocessed,
    CONCAT(ROUND(SUM(rejectedquantity) / 1000, 2),
            'K') AS totalrejected,
    CONCAT(ROUND(SUM(rejectedquantity) / SUM(processedquantity) * 100,
                    2),
            '%') AS REJECTIONRATE
FROM
    manufacturingdata
GROUP BY ecode
ORDER BY SUM(rejectedquantity) / SUM(processedquantity) DESC
LIMIT 20;

-- IV. TOP 20 MACHINE CODE-WISE REJECTION RATE
SELECT 
    MACHINECODE AS MCODE,
    CONCAT(ROUND(SUM(PROCESSEDQUANTITY) / 1000000, 2),
            'M') AS TOTALPROCESSED,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000, 2),
            'K') AS TOTALREJECTED,
    CONCAT(ROUND(SUM(rejectedquantity) / SUM(processedquantity) * 100,
                    2),
            '%') AS REJECTIONRATE
FROM
    manufacturingdata
GROUP BY MCODE
ORDER BY SUM(REJECTEDQUANTITY) DESC
LIMIT 20;

-- V. MACHINE COST VS REJECTION RATE BY MACHINE CODE
SELECT 
    MACHINECODE AS MCODE,
    CONCAT(ROUND(SUM(PROCESSEDQUANTITY) / 1000000, 2),
            'M') AS TOTALPROCESSED,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000, 2),
            'K') AS TOTALREJECTED,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / SUM(PROCESSEDQUANTITY) * 100,
                    2),
            '%') AS REJECTIONRATE,
    CONCAT(ROUND(SUM(PERDAYMACHINECOST) / 1000000, 2),
            'M') AS COST
FROM
    manufacturingdata
GROUP BY MCODE
ORDER BY SUM(REJECTEDQUANTITY) DESC , SUM(PERDAYMACHINECOST) DESC;

## 9. MANUFACTURED VS REJECTED QUANTITY
SELECT 
    BUYER,
    DELIVERYPERIOD AS DELIVERY,
    CONCAT(ROUND(SUM(MANUFACTUREDQUANTITY) / 1000000, 2),
            'M') AS MQUANTITY,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000, 2),
            'K') AS RQUANTITY
FROM
    manufacturingdata
GROUP BY BUYER , DELIVERY
ORDER BY SUM(MANUFACTUREDQUANTITY) DESC , SUM(REJECTEDQUANTITY) DESC;

## 10. DEPARTMENT-WISE MANUFACTURED VS REJECTED QUANTITY
SELECT 
    DEPARTMENTNAME AS DEPARTMENT,
    CONCAT(ROUND(SUM(MANUFACTUREDQUANTITY) / 1000000, 2),
            'M') AS MQUANTITY,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / 1000, 2),
            'K') AS RQUANTITY,
    CONCAT(ROUND(SUM(REJECTEDQUANTITY) / SUM(PROCESSEDQUANTITY) * 100,
                    2),
            '%') AS REJECTIONRATE
FROM
    manufacturingdata
GROUP BY DEPARTMENTNAME
ORDER BY SUM(REJECTEDQUANTITY) / SUM(PROCESSEDQUANTITY) DESC;

