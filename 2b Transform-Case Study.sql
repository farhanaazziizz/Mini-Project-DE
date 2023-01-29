/*Product Analysis*/
select
	a.CustomerID, a.OrderDate, c.ProductName, b.Quantity, 
	(b.UnitPrice-(b.UnitPrice*b.Discount)) AS UnitPriceDiscount, (b.Quantity*(b.UnitPrice-(b.UnitPrice*b.Discount))) AS TotalPrice,
	d.CategoryName
from
	Orders a
	join [Order Details] b
	on a.OrderID = b.OrderID
	join Products c
	on b.ProductID = c.ProductID
	join Categories d
	on c.CategoryID = d.CategoryID;

/*Shipper  Analysis*/
select
	a.OrderDate, a.CustomerID, a.ShipName, a.ShipCountry, b.CompanyName
from
	Orders a
	join Shippers b
	on a.ShipVia = b.ShipperID
where
	Year(a.OrderDate) = 1997;

/*Customer  Analysis*/
select
	a.OrderDate, c.CompanyName, c.ContactTitle, c.City, c.Country,
	b.Quantity, (b.Quantity*(b.UnitPrice-(b.UnitPrice*b.Discount))) AS TotalPrice
from
	Orders a
	join [Order Details] b
	on a.OrderID = b.OrderID
	join Customers c
	on a.CustomerID = c.CustomerID