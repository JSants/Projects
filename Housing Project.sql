-- Standarsing the date format
Select SaleDate from housingdata;
alter table housingdata
Add DateOfSale date;
Update housingdata
SET DateOfSale = convert(SaleDate, date);
Select DateOfSale from housingdata;
alter table housingdata
drop column SaleDate;

-- Populating the PropertyAddress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress)
from housingdata a
join housingdata b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

Update a
SET PropertyAddress = isnull(a.PropertyAddress)
from housingdata a
join housingdata b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

-- Breaking the address into different columns
alter table housingdata
Add AddressOfProperty Nvarchar(255);
Update housingdata
SET AddressOfProperty = substring(PropertyAddress, 1, locate(',', PropertyAddress) -1);
alter table housingdata
Add PropertyCity Nvarchar(255);
Update housingdata
SET PropertyCity = substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress));
Select * from housingdata;
alter table housingdata
drop column PropertyAddress;

alter table housingdata
Add AddressOfOwner Nvarchar(255);
Update housingdata
SET AddressOfOwner = substring_index(OwnerAddress, ',', 1);
alter table housingdata
Add OwnerCity Nvarchar(255);
Update housingdata
SET OwnerCity = substring_index((substring_index(OwnerAddress, ',', 2)), ',', -1);
alter table housingdata
Add OwnerState Nvarchar(255);
Update housingdata
SET OwnerState = substring_index(OwnerAddress, ',', -1);
alter table housingdata
drop column OwnerAddress;

-- Change 'Y' and 'N' to 'Yes and 'No'
Update housingdata
SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
        else SoldAsVacant
        end;

-- Remove Duplicates

With RowNumCTE as(
Select *,
	row_number() over (
    partition by ParcelID, 
		AddressOfProperty, 
		SalePrice, 
		DateOfSale, 
		LegalReference 
		order by 
			UniqueID) row_num
from housingdata
)
delete
from RowNumCTE
where row_num > 1;