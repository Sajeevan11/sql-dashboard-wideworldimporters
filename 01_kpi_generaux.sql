-- ============================================
-- REQUÊTE 1 : KPI GÉNÉRAUX
-- ============================================
-- Description : Vue d'ensemble des métriques business 2015-2016
--               Permet de comparer les performances annuelles
-- 
-- Objectif : Afficher en une ligne les KPI clés pour le management :
--   - Chiffre d'affaires total
--   - Nombre de clients actifs
--   - Nombre de commandes
--   - Panier moyen
--   - Évolution vs année précédente
--
-- Tables utilisées :
--   - Sales.Orders (pour OrderDate, CustomerID, OrderID)
--   - Sales.OrderLines (pour Quantity, UnitPrice)
--
-- Techniques SQL :
--   - CTE pour structurer le calcul
--   - Pivot manuel avec MAX + CASE WHEN
--   - Agrégations multiples (SUM, COUNT DISTINCT)
--
-- Auteur : Formation SQL Dashboard
-- Date : Janvier 2026
-- Base : WideWorldImporters (SQL Server)
-- ============================================

WITH KPI_Par_Annee AS (
    -- Calcul des métriques par année (2015 et 2016)
    SELECT 
        YEAR(O.OrderDate) as Année,
        SUM(OL.Quantity * OL.UnitPrice) as CA,
        COUNT(DISTINCT O.CustomerID) as Nb_Clients,
        COUNT(DISTINCT O.OrderID) as Nb_Commandes
    FROM Sales.Orders as O 
    INNER JOIN Sales.OrderLines as OL ON O.OrderID = OL.OrderID
    WHERE YEAR(O.OrderDate) IN (2015, 2016)
    GROUP BY YEAR(O.OrderDate)
)
-- Transformation en une ligne avec colonnes par année (pivot)
SELECT 
    -- Métriques 2016
    MAX(CASE WHEN Année = 2016 THEN CA END) as CA_Total_2016,
    MAX(CASE WHEN Année = 2016 THEN Nb_Clients END) as Nb_Client_Actif_2016,
    MAX(CASE WHEN Année = 2016 THEN Nb_Commandes END) as Nb_Commandes_2016,
    MAX(CASE WHEN Année = 2016 THEN CA END) / 
        MAX(CASE WHEN Année = 2016 THEN Nb_Commandes END) as Panier_Moyen_2016,
    
    -- Métriques 2015 (pour comparaison)
    MAX(CASE WHEN Année = 2015 THEN CA END) as CA_Total_2015,
    
    -- Évolutions
    MAX(CASE WHEN Année = 2016 THEN CA END) - 
        MAX(CASE WHEN Année = 2015 THEN CA END) as Evolution_CA_Absolue,
    ((MAX(CASE WHEN Année = 2016 THEN CA END) - 
        MAX(CASE WHEN Année = 2015 THEN CA END)) / 
        MAX(CASE WHEN Année = 2015 THEN CA END)) * 100 as Evolution_CA_Pourcent
FROM KPI_Par_Annee;

-- ============================================
-- NOTES IMPORTANTES :
-- ============================================
-- ⚠️ Les données 2016 sont partielles (janvier à mai uniquement)
--    L'évolution négative reflète cette incomplétude, pas une baisse réelle.
--    Pour une comparaison équitable, il faudrait comparer :
--    - Janvier-Mai 2015 vs Janvier-Mai 2016
--
-- 💡 Résultat attendu : 1 ligne avec 7 colonnes
--    Utile pour : Dashboard management, reporting mensuel
-- ============================================
