/* 1. Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997 */
Select	
	MONTH(A.OrderDate) as Bulan, 
	COUNT(A.CustomerID) as Jumlah_Customer
From
	Orders A
	JOIN 
	Customers B ON A.CustomerID = B.CustomerID
WHERE 
	YEAR(OrderDate) = 1997
GROUP BY 
	MONTH(A.OrderDate);

/* 2. Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative */
select
	CONCAT(FirstName, LastName) EmployeeName, Title
from
	Employees
where
	Title = 'Sales Representative';

/* 3. Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997 */
select
	TOP 5
	c.ProductName,
	SUM(b.Quantity) as Total_Quantity
	
from
	Orders a
	JOIN [Order Details] b
	ON a.OrderID = b.OrderID
	JOIN Products c
	ON b.ProductID = c.ProductID
WHERE
	MONTH(a.OrderDate) = 1  AND
	YEAR(a.OrderDate) = 1997
GROUP BY 
	c.ProductName
ORDER BY
	Total_Quantity DESC;

/* 4. Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997 */
select
	a.ProductName, b.CompanyName 
from 
	Products a
	join Suppliers b
	on a.SupplierID = b.SupplierID
	join [Order Details] c
	on a.ProductID = c.ProductID
	join Orders d
	on c.OrderID = d.OrderID
where
	a.ProductName = 'Chai' AND
	year(d.OrderDate) = 1997 AND
	month(d.OrderDate) = 6;

/* 5. Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500. */
select
	case
		when (UnitPrice*Quantity) <= 100 then '<='
		when (UnitPrice*Quantity) between 100 and 250 then '100 < x <= 250'
		when (UnitPrice*Quantity) between 250 and 500 then '250 < x <= 500'
		else '> 500'
	end 'Price Range',
	count(distinct OrderID) 'Jumlah OrderID' 
from
	[Order Details]
group by 
	case
		when (UnitPrice*Quantity) <= 100 then '<='
		when (UnitPrice*Quantity) between 100 and 250 then '100 < x <= 250'
		when (UnitPrice*Quantity) between 250 and 500 then '250 < x <= 500'
		else '> 500'
	end;

/* 6. Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997 */
select
	a.CompanyName, SUM(c.Quantity) Total_Quantity
from
	Customers a
	join Orders b
	on a.CustomerID = b.CustomerID
	join [Order Details] c
	on b.OrderID = c.OrderID
where
	year(b.OrderDate) = 1997
group by
	a.CompanyName
having
	SUM(c.Quantity) > 500;

/* 7. Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997. */
WITH top_5_per_month AS (
    SELECT 
        c.ProductName,
        MONTH(a.OrderDate) AS Bulan,
        SUM(b.Quantity) AS Total_Quantity,
        ROW_NUMBER() OVER (PARTITION BY MONTH(a.OrderDate) ORDER BY SUM(b.Quantity) DESC) AS rank
    FROM Orders a
    JOIN [Order Details] b ON a.OrderID = b.OrderID
    JOIN Products c ON b.ProductID = c.ProductID
    WHERE YEAR(a.OrderDate) = 1997
    GROUP BY c.ProductName, MONTH(a.OrderDate)
)
SELECT 
	Bulan, ProductName, Total_Quantity
FROM 
	top_5_per_month
WHERE 
	rank <= 5
ORDER BY 
	Bulan ASC, Total_Quantity DESC;

/* 8. Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.*/
select
	a.OrderID, a.ProductID, b.ProductName, a.UnitPrice, a.Quantity, a.Discount, 
	(a.UnitPrice-(a.UnitPrice*a.Discount)) 'Harga Setelah Diskon'
from
	[Order Details] a
	join Products b
	on a.ProductID = b.ProductID
	join Orders c
	on a.OrderID = c.OrderID;

/* 9. Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, ShippedDate jika terdapat inputan CustomerID tertentu*/
CREATE PROCEDURE Invoice1 (@CustomerID varchar(5))
AS
BEGIN
    SELECT 
        a.CustomerID, b.CompanyName, a.OrderID, a.OrderDate, a.RequiredDate, a.ShippedDate
    FROM 
        Orders a
    JOIN Customers b
    ON a.CustomerID = b.CustomerID
    WHERE 
        a.CustomerID = @CustomerID
END

EXEC Invoice1 @CustomerID = 'LEHMS'