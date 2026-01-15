-- ============================================
-- REQUÊTE 3 : ÉVOLUTION MENSUELLE CA (Tendances)
-- ============================================
-- Description : Analyse l'évolution du chiffre d'affaires mois par mois
--               avec calcul des variations absolues et relatives
-- 
-- Objectif : Suivre les tendances commerciales :
--   - Croissance ou décroissance mensuelle
--   - Saisonnalité éventuelle
--   - Alertes sur baisses significatives
--
-- Tables utilisées :
--   - Sales.Orders (pour OrderDate)
--   - Sales.OrderLines (pour Quantity, UnitPrice)
--
-- Techniques SQL :
--   - FORMAT() pour formater les dates en yyyy-MM
--   - LAG() pour accéder au mois précédent
--   - Window Functions avec ORDER BY temporel
--
-- Auteur : Formation SQL Dashboard
-- Date : Janvier 2026
-- Base : WideWorldImporters (SQL Server)
-- ============================================

WITH CA_Mois AS (
    -- Calcul du CA par mois (format yyyy-MM)
    SELECT 
        FORMAT(O.OrderDate, 'yyyy-MM') as Mois, 
        SUM(OL.Quantity * OL.UnitPrice) AS CA_Mois
    FROM Sales.Orders as O
    INNER JOIN Sales.OrderLines as OL ON O.OrderID = OL.OrderID
    WHERE YEAR(O.OrderDate) = 2016
    GROUP BY FORMAT(O.OrderDate, 'yyyy-MM')
),
CA_Mois_Precedent AS (
    -- Ajout du CA du mois précédent avec LAG()
    SELECT 
        Mois, 
        CA_Mois, 
        LAG(CA_Mois) OVER (ORDER BY Mois) as CA_Mois_Precedent
    FROM CA_Mois
)
-- Calcul des évolutions (absolue et en %)
SELECT 
    Mois,
    CA_Mois,
    CA_Mois_Precedent,
    CA_Mois - CA_Mois_Precedent as Evolution_Absolue,
    ((CA_Mois - CA_Mois_Precedent) / CA_Mois_Precedent) * 100 as Evolution_Pourcent
FROM CA_Mois_Precedent
ORDER BY Mois;

-- ============================================
-- NOTES IMPORTANTES :
-- ============================================
-- ⚠️ Premier mois (2016-01) :
--    - CA_Mois_Precedent = NULL (pas de mois avant)
--    - Evolution_Absolue = NULL
--    - Evolution_Pourcent = NULL
--    → C'est normal et attendu !
--
-- 💡 Gestion des NULL en production :
--    Option 1 : Laisser NULL (honnêteté - il n'y a pas de mois précédent)
--    Option 2 : Filtrer avec WHERE CA_Mois_Precedent IS NOT NULL
--    Option 3 : Remplacer par 0 avec COALESCE (moins recommandé)
--
-- 📊 Pour dashboard propre, ajouter :
--    WHERE CA_Mois_Precedent IS NOT NULL
--    (exclut janvier, affiche uniquement les mois avec évolution)
--
-- 💡 Résultat attendu : 5 lignes (janvier à mai 2016)
--    Utilisation : Reporting mensuel, détection tendances
-- ============================================
