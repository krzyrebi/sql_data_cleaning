Select * 
from HousingData

-- Standarize Date Format

Alter Table HousingData
Add SaleDateConverted Date

Update HousingData
Set SaleDateConverted = Convert(Date, SaleDate)


Select SaleDate, SaleDateConverted
from HousingData



-- Populate Property Address

Select * 
from HousingData
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingData a
join HousingData b
on a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



Update a
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingData a
join HousingData b
on a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Address to several columns


Select PropertyAddress 
from HousingData
order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) as City
from HousingData


Alter Table HousingData
Add SplitCity varchar(255),
SplitAddress varchar(255)

Update HousingData
Set SplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
SplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress))


-- Owner Address

Select OwnerAddress 
from HousingData

Select
Parsename(Replace(OwnerAddress, ',', '.'), 3),
Parsename(Replace(OwnerAddress, ',', '.'), 2),
Parsename(Replace(OwnerAddress, ',', '.'), 1)
from HousingData

Alter Table HousingData
Add OwnerStreet varchar(255),
OwnerCity varchar(255),
OwnerState varchar(255)

Update HousingData
Set OwnerStreet = Parsename(Replace(OwnerAddress, ',', '.'), 3),
OwnerCity = Parsename(Replace(OwnerAddress, ',', '.'), 2),
OwnerState = Parsename(Replace(OwnerAddress, ',', '.'), 1)


-- Standarize SoldasVacant column

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from HousingData
Group By SoldasVacant

Select SoldAsVacant,
Case 
When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant 
End
from HousingData


Update HousingData
Set SoldAsVacant = Case 
When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant 
End

--remove duplicates

With duplicatesCTE as (
Select 
ParcelID,
SaleDate,
SalePrice,
ROW_NUMBER() OVER (Partition by ParcelID,
SaleDate,
SalePrice Order by ParcelID) as row_num
from HousingData
)

Delete from duplicatesCTE
where row_num>1












