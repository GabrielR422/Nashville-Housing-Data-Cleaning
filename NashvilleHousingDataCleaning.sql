-- Cleaning Data in SQL Queries

Select *
From NashvileHousing.dbo.NashvilleHousing$


-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From NashvileHousing.dbo.NashvilleHousing$

--Update NashvilleHousing$
--Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing$
ADD SaleDateConverted Date;

Update NashvilleHousing$
Set SaleDateConverted = CONVERT(Date, SaleDate)


-- Populate Property Adress data

Select *
From NashvileHousing.dbo.NashvilleHousing$
-- Where PropertyAddress is Null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvileHousing.dbo.NashvilleHousing$ a
JOIN NashvileHousing.dbo.NashvilleHousing$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvileHousing.dbo.NashvilleHousing$ a
JOIN NashvileHousing.dbo.NashvilleHousing$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvileHousing.dbo.NashvilleHousing$


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

From NashvileHousing.dbo.NashvilleHousing$


Alter Table NashvilleHousing$
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing$
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing$
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing$
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From NashvileHousing.dbo.NashvilleHousing$





Select OwnerAddress
From NashvileHousing.dbo.NashvilleHousing$

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From NashvileHousing.dbo.NashvilleHousing$


Alter Table NashvilleHousing$
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing$
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table NashvilleHousing$
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing$
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing$
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing$
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
From NashvileHousing.dbo.NashvilleHousing$




-- Change Y and N to Yes and No in SoldAsVacant field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvileHousing.dbo.NashvilleHousing$
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From NashvileHousing.dbo.NashvilleHousing$

Update NashvilleHousing$
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End


-- Remove Duplicates (for learning purposes)


With RowNumCTE As(
Select *,
	ROW_NUMBER() Over (
	Partition By ParcelID, 
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) row_num

From NashvileHousing.dbo.NashvilleHousing$
)
--Delete
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns (for learning purposes)

Select *
From NashvileHousing.dbo.NashvilleHousing$

ALTER TABLE NashvileHousing.dbo.NashvilleHousing$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate