USE classicmodels;

-- =============================================
-- NETTOYAGE (On efface les anciennes versions pour éviter les erreurs)
-- =============================================
DROP PROCEDURE IF EXISTS CalculateCommission;
DROP PROCEDURE IF EXISTS CheckLowStock;
DROP FUNCTION IF EXISTS CustomerLifetimeValue;
DROP TRIGGER IF EXISTS AuditNewOrder;
DROP TRIGGER IF EXISTS PreventStockOverrun;
DROP TABLE IF EXISTS Orders_Audit;

-- =============================================
-- 1. PROCÉDURE STOCKÉE : Calcul des Commissions
-- =============================================
DELIMITER $$
CREATE PROCEDURE CalculateCommission(IN employee_id INT, OUT total_commission DECIMAL(10,2))
BEGIN
    SELECT SUM(od.quantityOrdered * od.priceEach) * 0.05 INTO total_commission
    FROM customers c
    JOIN orders o ON c.customerNumber = o.customerNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    WHERE c.salesRepEmployeeNumber = employee_id 
    AND o.status = 'Shipped';
END$$
DELIMITER ;

-- =============================================
-- 2. PROCÉDURE STOCKÉE : Gestion des Stocks (Alerte)
-- =============================================
DELIMITER $$
CREATE PROCEDURE CheckLowStock(IN threshold INT)
BEGIN
    SELECT productCode, productName, quantityInStock
    FROM products
    WHERE quantityInStock < threshold;
END$$
DELIMITER ;

-- =============================================
-- 3. FONCTION : Customer Lifetime Value (CLV)
-- =============================================
-- Astuce pour éviter l'erreur 1418 sur les fonctions
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $$
CREATE FUNCTION CustomerLifetimeValue(cust_id INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_spent DECIMAL(10,2);
    SELECT SUM(od.quantityOrdered * od.priceEach) INTO total_spent
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    WHERE o.customerNumber = cust_id AND o.status != 'Cancelled';
    
    RETURN IFNULL(total_spent, 0);
END$$
DELIMITER ;

-- =============================================
-- 4. TRIGGER : Audit des Commandes
-- =============================================
CREATE TABLE IF NOT EXISTS Orders_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    orderNumber INT,
    action_type VARCHAR(50),
    action_date DATETIME,
    user_id VARCHAR(50)
);

DELIMITER $$
CREATE TRIGGER AuditNewOrder
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO Orders_Audit (orderNumber, action_type, action_date, user_id)
    VALUES (NEW.orderNumber, 'INSERT - New Order Created', NOW(), USER());
END$$
DELIMITER ;

-- =============================================
-- 5. TRIGGER : Validation du Stock
-- =============================================
DELIMITER $$
CREATE TRIGGER PreventStockOverrun
BEFORE INSERT ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    SELECT quantityInStock INTO current_stock FROM products WHERE productCode = NEW.productCode;
    
    IF current_stock < NEW.quantityOrdered THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur : Stock insuffisant pour ce produit';
    END IF;
END$$
DELIMITER ;

-- =============================================
-- 6. TRIGGER : Mise à jour du statut du client
-- =============================================

-- 1. je crée la colonne 'customerLevel' dans la table clients
ALTER TABLE customers ADD COLUMN customerLevel VARCHAR(20) DEFAULT 'Standard';

-- 2. LE TRIGGER : Mise à jour automatique du niveau
DROP TRIGGER IF EXISTS UpdateCustomerLevel;

DELIMITER $$
CREATE TRIGGER UpdateCustomerLevel
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(10,2);

    -- je calcule le total payé à vie par ce client
    SELECT SUM(amount) INTO total_paid
    FROM payments
    WHERE customerNumber = NEW.customerNumber;

    -- je met à jour son niveau selon le montant
    IF total_paid > 100000 THEN
        UPDATE customers SET customerLevel = 'VIP' WHERE customerNumber = NEW.customerNumber;
    ELSEIF total_paid > 50000 THEN
        UPDATE customers SET customerLevel = 'Gold' WHERE customerNumber = NEW.customerNumber;
    ELSE
        UPDATE customers SET customerLevel = 'Standard' WHERE customerNumber = NEW.customerNumber;
    END IF;
END$$
DELIMITER ;