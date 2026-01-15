-- ============================================
-- REQUÊTE 4 : SEGMENTATION CLIENTS (RFM simplifié)
-- ============================================
-- Description : Segmente les clients selon leur comportement d'achat
--               en utilisant une approche RFM simplifiée
--               (Récence, Fréquence, Montant)
-- 
-- Objectif : Identifier différents profils clients pour :
--   - Cibler les actions marketing (VIP, réactivation...)
--   - Prioriser les efforts commerciaux
--   - Prévenir le churn (clients inactifs)
--
-- Segments définis :
--   - VIP : CA ≥ 100K ET Nb_Commandes ≥ 50
--   - Régulier : CA ≥ 50K OU Nb_Commandes ≥ 30
--   - Occasionnel : Nb_Commandes < 30 ET actif récemment (≤60 jours)
--   - Inactif : Tous les autres (peu d'achats ou longtemps sans commander)
--
-- Tables utilisées :
--   - Sales.Customers
--   - Sales.Orders
--   - Sales.OrderLines
--
-- Techniques SQL :
--   - CASE WHEN multi-conditions pour segmentation
--   - DATEDIFF pour calcul de récence
--   - MAX() pour dernière commande
--   - Agrégations multiples (SUM, COUNT, MAX)
--
-- Auteur : Formation SQL Dashboard
-- Date : Janvier 2026
-- Base : WideWorldImporters (SQL Server)
-- ============================================

WITH KPI AS (
    -- Calcul des métriques par client
    SELECT 
        C.CustomerID, 
        C.CustomerName, 
        SUM(OL.Quantity * OL.UnitPrice) as CA_Total_2016, 
        COUNT(O.OrderID) as Nb_Commandes,
        MAX(O.OrderDate) as Derniere_Commande,
        DATEDIFF(day, MAX(O.OrderDate), '2016-05-31') as Jours_Depuis_Derniere_Commande
    FROM Sales.Customers as C
    INNER JOIN Sales.Orders as O ON C.CustomerID = O.CustomerID
    INNER JOIN Sales.OrderLines as OL ON O.OrderID = OL.OrderID
    WHERE YEAR(O.OrderDate) = 2016
    GROUP BY C.CustomerID, C.CustomerName
)
-- Ajout du segment avec logique métier
SELECT 
    CustomerID,
    CustomerName,
    CA_Total_2016,
    Nb_Commandes,
    Derniere_Commande,
    Jours_Depuis_Derniere_Commande,
    -- Segmentation en 4 catégories (ordre important !)
    CASE 
        WHEN CA_Total_2016 >= 100000 AND Nb_Commandes >= 50 THEN 'VIP'
        WHEN CA_Total_2016 >= 50000 OR Nb_Commandes >= 30 THEN 'Régulier'
        WHEN Nb_Commandes < 30 AND Jours_Depuis_Derniere_Commande <= 60 THEN 'Occasionnel'
        ELSE 'Inactif'
    END as Segment
FROM KPI
ORDER BY CA_Total_2016 DESC;

-- ============================================
-- NOTES IMPORTANTES :
-- ============================================
-- 💡 Ordre des conditions CASE WHEN :
--    L'ordre est crucial ! SQL évalue de haut en bas et s'arrête
--    à la première condition vraie.
--    VIP doit être testé en premier (le plus restrictif)
--
-- 💡 DATEDIFF avec '2016-05-31' :
--    On utilise la dernière date disponible dans les données
--    En production, on utiliserait GETDATE() pour la date actuelle
--
-- 💡 Pourquoi deux colonnes (Date ET Jours) :
--    - Derniere_Commande : Pour afficher "Commandé le 2016-05-28"
--    - Jours_Depuis : Pour segmentation ("Il y a 3 jours")
--
-- 📊 Analyse complémentaire possible :
--    SELECT Segment, COUNT(*) as Nb_Clients, SUM(CA_Total_2016) as CA_Segment
--    FROM [résultat]
--    GROUP BY Segment
--    → Montre la répartition clients par segment
--
-- 💡 Résultat attendu : 663 lignes (tous les clients actifs 2016)
--    Utilisation : Campagnes marketing, priorisation commerciale
-- ============================================
