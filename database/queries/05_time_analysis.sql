/*
PROJET CLASSICMODELS - PARTIE 3 : ANALYSE TEMPORELLE
Objectif : Préparer les données pour les graphiques Python
*/

USE classicmodels;

-- ---------------------------------------------------------
-- 1. Évolution du Chiffre d'Affaires par Année et Mois
-- ---------------------------------------------------------
SELECT 
    DATE_FORMAT(o.orderDate, '%Y-%m') AS Mois,
    SUM(od.quantityOrdered * od.priceEach) AS Chiffre_Affaires
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE o.status != 'Cancelled'
GROUP BY DATE_FORMAT(o.orderDate, '%Y-%m')
ORDER BY Mois;