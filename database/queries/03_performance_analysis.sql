/*
PROJET CLASSICMODELS - PARTIE 1 (Fin)
Performance des Employés et Rentabilité des Gammes
*/

USE classicmodels;

-- ---------------------------------------------------------
-- 1. Le meilleur vendeur (Chiffre d'affaires généré)
-- ---------------------------------------------------------
SELECT 
    e.firstName, 
    e.lastName, 
    e.jobTitle,
    SUM(od.quantityOrdered * od.priceEach) AS Chiffre_Affaires
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE o.status != 'Cancelled'
GROUP BY e.employeeNumber
ORDER BY Chiffre_Affaires DESC
LIMIT 1;

-- ---------------------------------------------------------
-- 2. La gamme de produits la plus rentable
-- ---------------------------------------------------------
SELECT 
    p.productLine, 
    SUM(od.quantityOrdered * od.priceEach) AS Total_Ventes
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
WHERE o.status != 'Cancelled'
GROUP BY p.productLine
ORDER BY Total_Ventes DESC;