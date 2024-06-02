-- Selecting All Rows
select * from Project1.dbo.[NashvilleHousing]







--Standardizing the Date Format

select SaleDateConverted, Convert(DATE,SaleDate) as Date
from Project1.dbo.[NashvilleHousing]

Update [NashvilleHousing]
Set SaleDate = Convert(DATE,SaleDate)

alter table nashvillehousing
add SaleDateconverted Date;

Update [NashvilleHousing]
Set SaleDateConverted = Convert(DATE,SaleDate)


-- Property Populate Address Data

select PropertyAddress
from Project1.dbo.[NashvilleHousing]
where PropertyAddress is null

select a.parcelid, a.propertyaddress ,b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
from Project1.dbo.[NashvilleHousing] a
join Project1.dbo.[NashvilleHousing] b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
from Project1.dbo.[NashvilleHousing] a
join Project1.dbo.[NashvilleHousing] b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid
where a.propertyaddress is null






-- Breaking out address into individual columns

select propertyaddress
from Project1.dbo.[NashvilleHousing]

select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address,
substring(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) as Address
from project1.dbo.[NashvilleHousing]

alter table nashvillehousing
add PropertySplitAddress Nvarchar(250);

Update [NashvilleHousing]
Set PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

alter table nashvillehousing
add PropertySplitCity nvarchar(100);

Update [NashvilleHousing]
Set PropertySplitCity = substring(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress))

select * from 
Project1.dbo.[NashvilleHousing]

select
PARSENAME(replace(owneraddress, ',','.'), 3),
PARSENAME(replace(owneraddress, ',','.'), 2),
PARSENAME(replace(owneraddress, ',','.'), 1)
from project1.dbo.nashvillehousing

alter table nashvillehousing
add  OwnerSplitAddress Nvarchar(250);

Update [NashvilleHousing]
Set OwnerSplitAddress = PARSENAME(replace(owneraddress, ',','.'), 3)

alter table nashvillehousing
add OwnerSplitCity nvarchar(100);

Update [NashvilleHousing]
Set OwnerSplitCity = PARSENAME(replace(owneraddress, ',','.'), 2)

alter table nashvillehousing
add OwnerSplitState nvarchar(50);

Update [NashvilleHousing]
Set OwnerSplitState = PARSENAME(replace(owneraddress, ',','.'), 1)





-- Change Y and N to Yes and No

select distinct(soldasvacant), count(soldasvacant)
from Project1.dbo.[NashvilleHousing]
group by soldasvacant
order by count(soldasvacant)

select soldasvacant,
case when soldasvacant = 'Y' THEN 'Yes'
	 when soldasvacant = 'N' THEN 'No'
	 else soldasvacant
	 end
from Project1.dbo.[NashvilleHousing]

update Project1.dbo.[NashvilleHousing]
set soldasvacant = case when soldasvacant = 'Y' THEN 'Yes'
	 when soldasvacant = 'N' THEN 'No'
	 else soldasvacant
	 end







-- Check for Duplicates

with RowNumCTE AS (
Select *, ROW_NUMBER() over(
		partition by parcelID,
				     propertyaddress,
					 saleprice,
					 saledate,
					 legalreference
					 order by uniqueid
		) row_num
from Project1.dbo.[NashvilleHousing]
)

select * from RowNumCTE
--where row_num > 1
order by parcelid




-- Remove Duplicates

with RowNumCTE AS (
Select *, ROW_NUMBER() over(
		partition by parcelID,
				     propertyaddress,
					 saleprice,
					 saledate,
					 legalreference
					 order by uniqueid
		) row_num
from Project1.dbo.[NashvilleHousing]
)

delete from RowNumCTE
where row_num > 1






-- Deleting Columns

select * from Project1.dbo.[NashvilleHousing]

alter table project1.dbo.nashvillehousing
drop column propertyAddress, saledate,owneraddress, taxdistrict