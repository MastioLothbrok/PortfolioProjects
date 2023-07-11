/*
Cleaning Data in SQL Queries
*/

SELECT * 
FROM NashvilleHousing.dbo.NashHous 

-- Standardize date format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM NashvilleHousing.dbo.NashHous 

ALTER TABLE NashHous
ADD SaleDateConverted Date

UPDATE NashHous 
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing.dbo.NashHous 

--Populate property adress data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.NashHous a
JOIN NashvilleHousing.dbo.NashHous b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.NashHous a
JOIN NashvilleHousing.dbo.NashHous b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking out adress into individual (Address, City, State)

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM NashHous

ALTER TABLE NashHous
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashHous 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashHous
ADD PropertySplitCity Nvarchar(255)

UPDATE NashHous 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT OwnerAddress
FROM NashHous

SELECT 
OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM NashHous


ALTER TABLE NashHous
ADD OwnerSplitAddress Nvarchar(255)

UPDATE NashHous 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)


ALTER TABLE NashHous
ADD OwnerSplitCity Nvarchar(255)

UPDATE NashHous 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)


ALTER TABLE NashHous
ADD OwnerSplitState Nvarchar(255)

UPDATE NashHous 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)



SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant) as C
FROM NashHous
GROUP BY SoldAsVacant
ORDER BY C DESC

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashHous

UPDATE NashHous
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
				   WHEN SoldAsVacant = 'N' THEN 'No'
				   ELSE SoldAsVacant
				   END

--Remove Columns

ALTER TABLE NashHous
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

ALTER TABLE NashHous
DROP COLUMN SaleDate

SELECT *
FROM NashHous