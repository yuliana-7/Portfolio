/*
Cleaning data in SQL
SQL version used: PostgreSQL
*/

SELECT  COUNT(*) OVER() AS total_row_count, *
  FROM nashvillehousing;

-- Change date format
SELECT saledate, 
       CAST(TO_CHAR(saledate, 'YYYY-MM-DD') AS DATE)
  FROM nashvillehousing

ALTER TABLE nashvillehousing 
ADD COLUMN saledateconverted DATE;

UPDATE nashvillehousing 
SET saledateconverted = CAST(TO_CHAR(saledate, 'YYYY-MM-DD') AS DATE);

-- Populate empty values in Property Address data, based on parcelid
SELECT * 
  FROM nashvillehousing
 WHERE propertyaddress = '';

SELECT n1."UniqueID ", n1.parcelid, n1.propertyaddress, n2.parcelid, n2.propertyaddress,
       CASE WHEN n1.propertyaddress  = '' THEN n2.propertyaddress 
       ELSE n1.propertyaddress 
       END AS propertyaddress2, n1.addressupdated
  FROM nashvillehousing n1
  JOIN nashvillehousing n2 
    ON n1.parcelid = n2.parcelid AND n1."UniqueID "  <> n2."UniqueID ";

ALTER TABLE nashvillehousing 
ADD COLUMN propertyaddressupdated VARCHAR(50);

UPDATE nashvillehousing
SET propertyaddressupdated = propertyaddress;

WITH updatedaddress AS 
      (SELECT n1."UniqueID ", n1.parcelid AS parcelid1, n1.propertyaddress AS address1, n2.parcelid AS parcelid2, n2.propertyaddress AS address2,
              CASE WHEN n1.propertyaddress  = '' THEN n2.propertyaddress 
              ELSE n1.propertyaddress 
              END AS propertyaddress2
         FROM nashvillehousing n1
         JOIN nashvillehousing n2 
           ON n1.parcelid = n2.parcelid AND n1."UniqueID "  <> n2."UniqueID "
)

UPDATE nashvillehousing n
SET propertyaddressupdated = propertyaddress2
FROM updatedaddress u
WHERE n.parcelid = u.parcelid1 AND n.propertyaddress = '';

SELECT parcelid, propertyaddress, propertyaddressupdated, 
       COUNT(*) OVER() AS total_row_count, 
       (SELECT COUNT(propertyaddress)
        FROM nashvillehousing
        WHERE propertyaddress = '') AS missing_address,
        COUNT(propertyaddressupdated) OVER() AS propertyaddressupdated_count
  FROM nashvillehousing;

-- Separate property address and owner address into separate columns for address, city and state
SELECT propertyaddress, 
       SUBSTRING(propertyaddressupdated, strpos(propertyaddressupdated, ',') + 2),
       SUBSTRING(propertyaddressupdated, 1, strpos(propertyaddressupdated, ',') - 1),
       owneraddress,
       SPLIT_PART(owneraddress, ',', 1),
       SPLIT_PART(owneraddress, ',', 2),
       SPLIT_PART(owneraddress, ',', 3)
  FROM nashvillehousing;

ALTER TABLE nashvillehousing 
ADD COLUMN property_city VARCHAR(50),
ADD COLUMN propertyaddress_split VARCHAR(50),
ADD COLUMN owneraddress_split VARCHAR(50),
ADD COLUMN owner_city VARCHAR(50),
ADD COLUMN owner_state VARCHAR(50);

UPDATE nashvillehousing
SET property_city = SUBSTRING(propertyaddressupdated, strpos(propertyaddressupdated, ',') + 2);

UPDATE nashvillehousing
SET propertyaddress_split = SUBSTRING(propertyaddressupdated, 1, strpos(propertyaddressupdated, ',') - 1);

UPDATE nashvillehousing
SET owneraddress_split = SPLIT_PART(owneraddress, ',', 1);

UPDATE nashvillehousing
SET owner_city = SPLIT_PART(owneraddress, ',', 2);

UPDATE nashvillehousing
SET owner_state = SPLIT_PART(owneraddress, ',', 3);

-- Standardise the values in the soldasvacant column
SELECT DISTINCT soldasvacant, 
       count(soldasvacant)
  FROM nashvillehousing
 GROUP BY soldasvacant
 ORDER BY count(soldasvacant);

SELECT soldasvacant,
       CASE WHEN soldasvacant = 'Y' THEN 'Yes'
       WHEN soldasvacant = 'N' THEN 'No'
       ELSE soldasvacant 
       END AS soldasvacant_fixed
  FROM nashvillehousing;

ALTER TABLE nashvillehousing
ADD COLUMN soldasvacant_fixed VARCHAR(50);

UPDATE nashvillehousing
SET soldasvacant_fixed = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
                         WHEN soldasvacant = 'N' THEN 'No'
                         ELSE soldasvacant 
                         END;
                        
SELECT DISTINCT soldasvacant_fixed, 
       count(soldasvacant_fixed)
  FROM nashvillehousing
 GROUP BY soldasvacant_fixed
 ORDER BY count(soldasvacant_fixed);

-- Standardise the number format in saleprice
SELECT REPLACE(REPLACE(saleprice, '$', ''), ',', '') :: BIGINT 
  FROM nashvillehousing
 ORDER BY saleprice;

ALTER TABLE nashvillehousing
ADD COLUMN saleprice_fixed BIGINT;

UPDATE nashvillehousing
SET saleprice_fixed = REPLACE(REPLACE(saleprice, '$', ''), ',', '') :: BIGINT;

SELECT SUM(saleprice_fixed)
  FROM nashvillehousing;

SELECT saleprice, saleprice_fixed
  FROM nashvillehousing
 ORDER BY saleprice;

-- Delete unnecessare columns
ALTER TABLE nashvillehousing
DROP COLUMN propertyaddress
DROP COLUMN saledate
DROP COLUMN saleprice
DROP COLUMN soldasvacant;