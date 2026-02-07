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