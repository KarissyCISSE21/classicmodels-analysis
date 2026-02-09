/*
PROJET CLASSICMODELS - PARTIE 2 : REQUÊTES AVANCÉES
Auteur: CISSE KARISSY
*/

USE classicmodels;

-- ---------------------------------------------------------
-- 1. Analyse des Ventes avec WINDOW FUNCTIONS
-- Objectif : Classer les produits par montant de vente pour chaque année
-- ---------------------------------------------------------
SELECT 
    YEAR(o.orderDate) AS Annee,
    p.productName,
    SUM(od.quantityOrdered * od.priceEach) AS Total_Ventes,
    -- Fonction de fenêtrage pour le rang
    RANK() OVER (
        PARTITION BY YEAR(o.orderDate) 
        ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC
    ) AS Rang_Annuel
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE o.status = 'Shipped'
GROUP BY YEAR(o.orderDate), p.productName;


-- ---------------------------------------------------------
-- 2. Hiérarchie Organisationnelle (CTE RÉCURSIF)
-- Objectif : Afficher l'arbre hiérarchique (Qui est le chef de qui ?)
-- ---------------------------------------------------------
WITH RECURSIVE Organigramme AS (
    -- Cas de base : Le Président (Il n'a pas de chef, reportsTo est NULL)
    SELECT 
        employeeNumber, 
        lastName, 
        firstName, 
        jobTitle, 
        reportsTo, 
        1 as Niveau
    FROM employees
    WHERE reportsTo IS NULL
    
    UNION ALL
    
    -- Partie Récursive : On cherche les employés qui répondent aux chefs trouvés
    SELECT 
        e.employeeNumber, 
        e.lastName, 
        e.firstName, 
        e.jobTitle, 
        e.reportsTo, 
        o.Niveau + 1
    FROM employees e
    INNER JOIN Organigramme o ON e.reportsTo = o.employeeNumber
)
SELECT * FROM Organigramme
ORDER BY Niveau, reportsTo;

-- ----------------------------------------------------------
-- 3. Segmentation VIP avec Jointure de 6 Tables
-- Objectif : Voir les clients VIP, leur gamme préférée et leur délai moyen de paiement
-- ----------------------------------------------------------
SELECT 
    c.customerName,
    pl.productLine AS Gamme_Preferee,
    COUNT(DISTINCT o.orderNumber) AS Nb_Commandes,
    SUM(od.quantityOrdered * od.priceEach) AS Total_Achats,
    AVG(DATEDIFF(p.paymentDate, o.orderDate)) AS Delai_Moyen_Paiement_Jours
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products pr ON od.productCode = pr.productCode
JOIN productlines pl ON pr.productLine = pl.productLine
JOIN payments p ON c.customerNumber = p.customerNumber
WHERE o.status = 'Shipped'
GROUP BY c.customerName, pl.productLine
HAVING Total_Achats > 5000
ORDER BY Total_Achats DESC;

-- ------------------------------------------------------------
-- 4. Identification des Nouveaux Clients (Sous-requête corrélée)
-- Objectif : Lister les commandes qui sont les TOUTES PREMIÈRES d'un client
-- ------------------------------------------------------------
SELECT 
    o.orderNumber,
    o.orderDate,
    c.customerName,
    o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
WHERE o.orderDate = (
    -- Ici, la sous-requête cherche la date min pour CE client spécifique (corrélée)
    SELECT MIN(o2.orderDate)
    FROM orders o2
    WHERE o2.customerNumber = o.customerNumber
)
ORDER BY o.orderDate DESC;

-- --------------------------------------------------------
-- 5.Rapport Pivot (Cross-Tab) des Ventes par Trimestre
-- --------------------------------------------------------
SELECT 
    pl.productLine AS Gamme,
    -- Trimestre 1
    SUM(CASE WHEN QUARTER(o.orderDate) = 1 THEN od.quantityOrdered * od.priceEach ELSE 0 END) AS T1,
    -- Trimestre 2
    SUM(CASE WHEN QUARTER(o.orderDate) = 2 THEN od.quantityOrdered * od.priceEach ELSE 0 END) AS T2,
    -- Trimestre 3
    SUM(CASE WHEN QUARTER(o.orderDate) = 3 THEN od.quantityOrdered * od.priceEach ELSE 0 END) AS T3,
    -- Trimestre 4
    SUM(CASE WHEN QUARTER(o.orderDate) = 4 THEN od.quantityOrdered * od.priceEach ELSE 0 END) AS T4,
    -- Total Annuel
    SUM(od.quantityOrdered * od.priceEach) AS Total_Annuel
FROM products p
JOIN productlines pl ON p.productLine = pl.productLine
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
WHERE o.status != 'Cancelled' AND YEAR(o.orderDate) = 2004 -- On filtre sur une année (ex: 2004)
GROUP BY pl.productLine;