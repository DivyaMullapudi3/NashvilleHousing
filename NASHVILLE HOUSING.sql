

-- Cleaning Data in SQL Queries

select *
from [Portfolio project]..NashvilleHousing

--Standardize date format

select SaleDate, CONVERT(Date,SaleDate)
from [Portfolio project]..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDate2 Date;

Update NashvilleHousing
Set SaleDate2 = CONVERT(Date,SaleDate)

select SaleDate2, CONVERT(Date,SaleDate)
from [Portfolio project]..NashvilleHousing

--populate property address data

select *
from [Portfolio project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
from [Portfolio project]..NashvilleHousing a
join [Portfolio project]..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from [Portfolio project]..NashvilleHousing a
join [Portfolio project]..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null

select *
from NashvilleHousing
where PropertyAddress is null

-- Breaking out address into individual columns ( address,city,state)

select propertyaddress
from [Portfolio project]..NashvilleHousing

select   
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as address,
SUBSTRING(propertyaddress,CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) AS ADDRESS
from [Portfolio project]..NashvilleHousing

--SELECT
--CHARINDEX(',', propertyaddress)
--from [Portfolio project]..NashvilleHousing

ALTER TABLE NashvilleHousing
Add Propertysplitaddress NVARCHAR(255);

Update NashvilleHousing
Set Propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

ALTER TABLE NashvilleHousing
Add Propertysplitcity NVARCHAR(255);

Update NashvilleHousing
Set Propertysplitcity = SUBSTRING(propertyaddress,CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress))

select *
from NashvilleHousing

--OWNER ADDRESS

SELECT 
PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
Add Ownersplitaddress NVARCHAR(255);

Update NashvilleHousing
Set Ownersplitaddress = PARSENAME(REPLACE(OWNERADDRESS,',','.'),3)

ALTER TABLE NashvilleHousing
Add Ownerysplitcity NVARCHAR(255);

Update NashvilleHousing
Set Ownerysplitcity = PARSENAME(REPLACE(OWNERADDRESS,',','.'),2)

ALTER TABLE NashvilleHousing
Add Ownersplitstate NVARCHAR(255);

Update NashvilleHousing
Set Ownersplitstate = PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)

select *
from NashvilleHousing

--change y and n to yes and ni in "sold as vacant" field

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing 
GROUP BY SoldAsVacant
ORDER BY 2

select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from NashvilleHousing

UPDATE NASHVILLEHOUSING
SET SOLDASVACANT = CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

-- REMOVE DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing

--DELETE UNUSED COLUMNS

Select *
from NashvilleHousing

alter table NashvilleHousing
DROP COLUMN Owneraddress, propertyaddress, taxdistrict, saledate







