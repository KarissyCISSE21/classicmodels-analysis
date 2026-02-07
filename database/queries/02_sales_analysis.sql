/*
PROJET CLASSICMODELS - PARTIE 1 (Suite)
Analyse des Ventes, Produits et Clients
*/

USE classicmodels;

-- ---------------------------------------------------------
-- 1. Chiffre d'affaires total et Panier moyen
-- ---------------------------------------------------------
SELECT 
    SUM(quantityOrdered * priceEach) AS Chiffre_Affaires_Total,
    SUM(quantityOrdered * priceEach) / COUNT(DISTINCT orderNumber) AS Panier_Moyen
FROM orderdetails;

-- ---------------------------------------------------------
-- 2. Les 10 produits les plus vendus (Best-Sellers)
-- ---------------------------------------------------------
SELECT 
    p.productName, 
    p.productLine,
    SUM(od.quantityOrdered) AS Total_Vendus
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productName, p.productLine
ORDER BY Total_Vendus DESC
LIMIT 10;

-- ---------------------------------------------------------
-- 3. Les 5 meilleurs clients (Gros acheteurs)
-- ---------------------------------------------------------
SELECT 
    c.customerName, 
    c.country,
    SUM(od.quantityOrdered * od.priceEach) AS Total_Achats
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE o.status != 'Cancelled'  -- On exclut les commandes annulées
GROUP BY c.customerName, c.country
ORDER BY Total_Achats DESC
LIMIT 5;