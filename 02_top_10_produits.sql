-- ============================================
-- REQUÊTE 2 : TOP 10 PRODUITS (Part de marché)
-- ============================================
-- Description : Identifie les 10 produits les plus vendus en 2016
--               avec leur contribution au chiffre d'affaires total
-- 
-- Objectif : Permettre au management d'identifier :
--   - Les produits stars (best-sellers)
--   - Leur poids dans le CA global
--   - Les catégories les plus performantes
--
-- Tables utilisées :
--   - Warehouse.StockItems (pour StockItemName)
--   - Warehouse.StockItemStockGroups (table de liaison)
--   - Warehouse.StockGroups (pour StockGroupName/catégorie)
--   - Sales.OrderLines (pour Quantity, UnitPrice)
--   - Sales.Orders (pour OrderDate)
--
-- Techniques SQL :
--   - CTE multiples pour structure claire
--   - ROW_NUMBER() pour classement strict
--   - SUM() OVER() pour calcul de part de marché
--   - Jointures multiples (5 tables)
--
-- Auteur : Formation SQL Dashboard
-- Date : Janvier 2026
-- Base : WideWorldImporters (SQL Server)
-- ============================================

WITH CA_Produit AS (
    -- Calcul du CA par produit avec sa catégorie
    SELECT 
        SI.StockItemID,
        SI.StockItemName, 
        SG.StockGroupName, 
        SUM(OL.Quantity * OL.UnitPrice) AS CA_Produit,
        COUNT(OL.OrderID) AS Nb_Ventes
    FROM Warehouse.StockItems AS SI
    INNER JOIN Warehouse.StockItemStockGroups AS SISG ON SI.StockItemID = SISG.StockItemID
    INNER JOIN Warehouse.StockGroups AS SG ON SISG.StockGroupID = SG.StockGroupID
    INNER JOIN Sales.OrderLines AS OL ON SI.StockItemID = OL.StockItemID
    INNER JOIN Sales.Orders AS O ON OL.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = 2016
    GROUP BY SI.StockItemID, SI.StockItemName, SG.StockGroupName
),
Classement AS (
    -- Ajout du rang et calcul de la part de marché
    SELECT 
        StockItemName, 
        StockGroupName,
        CA_Produit,
        Nb_Ventes, 
        ROW_NUMBER() OVER (ORDER BY CA_Produit DESC) as Rang,
        -- Part de marché : CA produit / CA total tous produits * 100
        CA_Produit / SUM(CA_Produit) OVER() * 100 as Part_Marche_Pourcent
    FROM CA_Produit
)
-- Sélection du Top 10
SELECT *
FROM Classement
WHERE Rang <= 10
ORDER BY Rang ASC;

-- ============================================
-- NOTES IMPORTANTES :
-- ============================================
-- 💡 ROW_NUMBER vs RANK :
--    On utilise ROW_NUMBER() pour avoir exactement 10 produits
--    (même si ex-aequo, un seul est sélectionné)
--
-- 💡 SUM() OVER() :
--    Permet de calculer le CA total sans GROUP BY supplémentaire
--    La fenêtre vide () signifie "sur toutes les lignes"
--
-- 💡 Résultat attendu : 10 lignes
--    Part de marché totale ≠ 100% (normal, c'est le top 10, pas tous les produits)
--
-- 📊 Utilisation : Dashboard commercial, réunion direction
-- ============================================
