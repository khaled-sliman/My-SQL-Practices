                            -- DATA CLEANING PROJECT
 
 --Standardize Date Format (convert the type of date from datetime to date) 

select SaleDate
from [Nashville Housing].dbo.[Housing Prices]

alter table [Nashville Housing].dbo.[Housing Prices]
alter column saledate date;



 --Populate Property Address data (replace null values in the 'PropertyAddress' column by the right address)

select a.PropertyAddress , b.PropertyAddress , a.ParcelID , b.ParcelID
from [Nashville Housing].dbo.[Housing Prices] a
join [Nashville Housing].dbo.[Housing Prices] b
on a.ParcelID = b.ParcelID
where a.PropertyAddress is null

update A
set a.PropertyAddress = isnull(A.PropertyAddress,b.PropertyAddress)
from [Nashville Housing].dbo.[Housing Prices] a
join [Nashville Housing].dbo.[Housing Prices] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



 --Breaking out PropertyAddress into Individual Columns (Address, City, State)

alter table [Nashville Housing].dbo.[Housing Prices]
add houseaddress varchar(255);

update [Nashville Housing].dbo.[Housing Prices]
set houseaddress = substring(PropertyAddress , 1,charindex(',', PropertyAddress) -1)

alter table [Nashville Housing].dbo.[Housing Prices]
add housecity varchar(255);

update [Nashville Housing].dbo.[Housing Prices]
set housecity = substring(PropertyAddress , charindex(',', PropertyAddress)+1, 15 )

select *
from [Nashville Housing].dbo.[Housing Prices]



 --Breaking out OwnerAddress into Individual Columns (Address, City, State)

alter table [Nashville Housing].dbo.[Housing Prices]
add ownerminiaddress nvarchar(255);

update [Nashville Housing].dbo.[Housing Prices]
set ownerminiaddress = parsename(replace(owneraddress , ',' ,'.') , 3 )

alter table [Nashville Housing].dbo.[Housing Prices]
add ownercity nvarchar(255);

update [Nashville Housing].dbo.[Housing Prices]
set ownercity = parsename(replace(owneraddress , ',' , '.'), 2)

alter table [Nashville Housing].dbo.[Housing Prices]
add ownerstate nvarchar(255);

update [Nashville Housing].dbo.[Housing Prices]
set ownerstate = parsename(replace(OwnerAddress ,',' , '.' ) , 1)

select * from [Nashville Housing]..[Housing Prices]



-- Change Y and N to Yes and No in "Sold as Vacant" field

update [Nashville Housing]..[Housing Prices]
set SoldAsVacant = case when SoldAsVacant = 'n' then 'no' 
when SoldAsVacant = 'y' then 'yes'
else SoldAsVacant
end 

select  SoldAsVacant , count(SoldAsVacant)
from [Nashville Housing]..[Housing Prices]
group by SoldAsVacant



-- Remove Duplicate Rows

with rowcte as (
select ROW_NUMBER() over (
  partition by 
  [ParcelID],
  [PropertyAddress],
  [LegalReference],
  [SaleDate]
  order by [UniqueID ]

) as rownum
from [Nashville Housing]..[Housing Prices]
)

delete from rowcte where rownum != 1 



-- Delete Unused Columns

alter table [Nashville Housing]..[Housing Prices]
Drop column taxdistrict

select * from [Nashville Housing]..[Housing Prices]






