-- ============================================
-- REQUÊTE 5 : TOP 3 PRODUITS PAR CATÉGORIE
-- ============================================
-- Description : Identifie les 3 produits les plus vendus dans chaque
--               catégorie de produits en 2016
-- 
-- Objectif : Permettre une analyse multi-dimensionnelle :
--   - Identifier les best-sellers PAR catégorie
--   - Comparer la performance des produits au sein de leur segment
--   - Détecter les catégories avec forte concentration sur quelques produits
--
-- Tables utilisées :
--   - Warehouse.StockItems (pour StockItemName)
--   - Warehouse.StockItemStockGroups (table de liaison many-to-many)
--   - Warehouse.StockGroups (pour StockGroupName/catégorie)
--   - Sales.OrderLines (pour Quantity, UnitPrice)
--   - Sales.Orders (pour OrderDate)
--
-- Techniques SQL :
--   - PARTITION BY pour classement par groupe
--   - RANK() pour respect des ex-aequo
--   - Jointures multiples (5 tables)
--   - Filtrage sur Window Function (nécessite CTE)
--
-- Auteur : Formation SQL Dashboard
-- Date : Janvier 2026
-- Base : WideWorldImporters (SQL Server)
-- ============================================

WITH KPI AS (
    -- Calcul du CA par produit avec sa catégorie
    SELECT 
        SG.StockGroupName, 
        SI.StockItemName, 
        SUM(OL.Quantity * OL.UnitPrice) as CA_Produit
    FROM Warehouse.StockItems AS SI
    INNER JOIN Warehouse.StockItemStockGroups as SISG ON SI.StockItemID = SISG.StockItemID
    INNER JOIN Warehouse.StockGroups as SG ON SISG.StockGroupID = SG.StockGroupID
    INNER JOIN Sales.OrderLines as OL ON SI.StockItemID = OL.StockItemID
    INNER JOIN Sales.Orders as O ON OL.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = 2016
    GROUP BY SG.StockGroupName, SI.StockItemName
),
Classement AS (
    -- Ajout du rang PAR catégorie (redémarre à 1 pour chaque catégorie)
    SELECT 
        StockGroupName,
        StockItemName,
        CA_Produit,
        RANK() OVER (PARTITION BY StockGroupName ORDER BY CA_Produit DESC) as Rang
    FROM KPI
)
-- Sélection du Top 3 de chaque catégorie
SELECT *
FROM Classement
WHERE Rang <= 3
ORDER BY StockGroupName, Rang;

-- ============================================
-- NOTES IMPORTANTES :
-- ============================================
-- 💡 PARTITION BY StockGroupName :
--    Le rang redémarre à 1 pour CHAQUE catégorie
--    → Chaque catégorie a son propre Top 3
--    Sans PARTITION BY : classement global sur tous les produits
--
-- 💡 RANK() vs ROW_NUMBER() :
--    RANK() respecte les ex-aequo :
--    - Si 2 produits ont le même CA en 2ème position → rang 2 pour les deux
--    - Le suivant aura rang 4 (pas 3)
--    ROW_NUMBER() donnerait arbitrairement rang 2 et 3 → injuste
--
-- 💡 Pourquoi CTE obligatoire :
--    On ne peut pas filtrer directement sur une Window Function
--    WHERE RANK() OVER (...) <= 3  ← ERREUR
--    Il faut d'abord calculer le rang dans une CTE, puis filtrer
--
-- 📊 Nombre de lignes :
--    ~30-40 lignes (3 produits × 10-13 catégories)
--    Certaines catégories peuvent avoir >3 lignes si ex-aequo en 3ème position
--
-- 💡 Résultat attendu : Top 3 par catégorie
--    Utilisation : Dashboard merchandising, stratégie assortiment
-- ============================================
