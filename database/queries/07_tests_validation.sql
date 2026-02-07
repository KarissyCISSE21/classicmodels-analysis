/* 
   Description : Tests unitaires pour valider les procédures et fonctions stockées.
*/

USE classicmodels;

-- =======================================================
-- TEST 1 : Vérification du calcul de commission
-- Cas : Vendeur n°1370 (Hernandez)
-- =======================================================
CALL CalculateCommission(1370, @commission_result);
SELECT 
    1370 as 'EmployeeID', 
    'Hernandez' as 'Nom', 
    @commission_result as 'Commission_Générée ($)';

-- =======================================================
-- TEST 2 : Vérification de la fonction "Customer Lifetime Value"
-- Cas : Client n°141 (Euro+ Shopping Channel)
-- =======================================================
SELECT 
    141 as 'ClientID', 
    'Euro+ Shopping Channel' as 'Client', 
    CustomerLifetimeValue(141) as 'Total_Depensé_A_Vie ($)';

-- =======================================================
-- TEST 3 : Vérification de l'alerte Stock
-- Cas : On cherche les produits avec moins de 50 unités
-- =======================================================
CALL CheckLowStock(50);