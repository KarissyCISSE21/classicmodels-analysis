/*
PROJET CLASSICMODELS - PARTIE 1 : ANALYSE EXPLORATOIRE
Auteur: CISSE KARISSY
Date: 2026-02-07
*/

USE classicmodels;

-- ---------------------------------------------------------
-- 1. Volumétrie des données (Combien de lignes ?)
-- ---------------------------------------------------------
SELECT 
    (SELECT COUNT(*) FROM customers) AS Total_Clients,
    (SELECT COUNT(*) FROM employees) AS Total_Employes,
    (SELECT COUNT(*) FROM offices) AS Total_Bureaux,
    (SELECT COUNT(*) FROM orders) AS Total_Commandes;

-- ---------------------------------------------------------
-- 2. Répartition géographique des clients (Top Pays)
-- ---------------------------------------------------------
SELECT 
    country AS Pays, 
    COUNT(*) AS Nombre_Clients
FROM customers
GROUP BY country
ORDER BY Nombre_Clients DESC;

-- ---------------------------------------------------------
-- 3. Analyse des statuts de commandes
-- ---------------------------------------------------------
SELECT 
    status AS Statut_Commande, 
    COUNT(*) AS Nombre
FROM orders
GROUP BY status
ORDER BY Nombre DESC;