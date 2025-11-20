

/*

Cleanining Data

*/

Select *
From ..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format


Select SaleDateConverted,CONVERT	(Date,SaleDate)
From ..NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT	(Date,SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
From ..NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate the Null Property Address Column


Select *
From ..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From ..NashvilleHousing a
join ..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null


Update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From ..NashvilleHousing a
join ..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Splitting Address into Adress, City, State

Select PropertyAddress
From ..NashvilleHousing
--where PropertyAddress is null
-- order by ParcelID

Select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
From ..NashvilleHousing


Alter table NashvilleHousing
Add PropertySplitAdd Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAdd = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)


Alter table NashvilleHousing
Add PropertySplitCitie Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCitie= substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))


Select *
from ..NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertySplitCity, PropertySplitCities;

Select OwnerAddress
from ..NashvilleHousing

SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM ..NashvilleHousing;

Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
from ..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Sold as Vacant field change Y to Yes and N to No

select distinct(SoldAsVacant),count(SoldAsVacant)
from ..NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant

Select SoldAsVacant,
	CASE when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end 
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end 






---------------------------------------------------------------------------------------------------------------------------------------------


-- Remove  duplicate 

with RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITiON BY ParcelID, 
				PropertyAddress,SalePrice,
				SaleDate, LegalReference
				ORDER BY 
					UniqueID) row_num
from .. NashvilleHousing
)
Select *
from RowNumCTE
where row_num>1
order by PropertyAddress


---------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns


Select *
From ..NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate, OwnerAddress, TaxDistrict, PropertyAddress