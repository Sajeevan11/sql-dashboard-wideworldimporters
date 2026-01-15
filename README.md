# 📊 E-Commerce Sales Analytics Dashboard - SQL

![SQL](https://img.shields.io/badge/SQL-Server-red)
![Status](https://img.shields.io/badge/Status-Complete-success)
![Level](https://img.shields.io/badge/Level-Advanced-blue)

> Projet d'analyse de données commerciales utilisant SQL avancé sur la base de données **WideWorldImporters** (Microsoft SQL Server)

---

## 🎯 Objectif du Projet

Créer un **dashboard d'analyse commerciale complet** avec 5 requêtes SQL professionnelles couvrant :
- 📈 KPIs généraux et évolutions
- 🏆 Analyse produits (best-sellers, parts de marché)
- 📅 Tendances temporelles (Month-over-Month)
- 👥 Segmentation clients (RFM simplifié)
- 📊 Performance multi-dimensionnelle (par catégorie)

---

## 🗂️ Structure du Projet

```
📁 sql-dashboard-wideworldimporters/
│
├── 📄 README.md                          # Ce fichier
├── 📄 01_kpi_generaux.sql               # Métriques business clés
├── 📄 02_top_10_produits.sql            # Best-sellers + parts de marché
├── 📄 03_evolution_mensuelle_ca.sql     # Tendances MoM
├── 📄 04_segmentation_clients.sql       # Classification RFM
└── 📄 05_top_3_par_categorie.sql        # Performance par catégorie
```

---

## 📊 Base de Données

**Nom :** WideWorldImporters (Microsoft)  
**Type :** E-commerce / Retail  
**Période analysée :** 2016 (janvier à mai)  
**Tables principales :**
- `Sales.Orders` (commandes)
- `Sales.OrderLines` (lignes de commande)
- `Sales.Customers` (clients)
- `Warehouse.StockItems` (produits)
- `Warehouse.StockGroups` (catégories)

---

## 🔍 Description des Requêtes

### 📄 Requête 1 : KPI Généraux

**Objectif :** Vue d'ensemble des performances business  
**Résultat :** 1 ligne avec 7 métriques clés

**Métriques calculées :**
- Chiffre d'affaires total 2016
- Nombre de clients actifs
- Nombre de commandes
- Panier moyen
- Évolution vs 2015 (absolue et %)

**Techniques SQL utilisées :**
- CTE (Common Table Expressions)
- Pivot manuel (`MAX` + `CASE WHEN`)
- Agrégations multiples (`SUM`, `COUNT DISTINCT`)

**Cas d'usage :** Dashboard management, reporting mensuel

---

### 📄 Requête 2 : Top 10 Produits

**Objectif :** Identifier les best-sellers et leur contribution au CA  
**Résultat :** 10 lignes (produits les plus vendus)

**Colonnes :**
- Nom du produit
- Catégorie
- CA généré
- Nombre de ventes
- **Part de marché** (%)
- Rang

**Techniques SQL utilisées :**
- `ROW_NUMBER()` pour classement strict
- `SUM() OVER()` pour calcul de part de marché (Window Function)
- Jointures multiples (5 tables)

**Cas d'usage :** Stratégie produits, gestion des stocks

---

### 📄 Requête 3 : Évolution Mensuelle CA

**Objectif :** Suivre les tendances commerciales mois par mois  
**Résultat :** 5 lignes (janvier à mai 2016)

**Colonnes :**
- Mois (format yyyy-MM)
- CA du mois
- CA du mois précédent
- Évolution absolue
- **Évolution en %** (MoM)

**Techniques SQL utilisées :**
- `LAG()` pour accéder au mois précédent (Window Function)
- `FORMAT()` pour dates
- Calculs d'évolutions temporelles

**Cas d'usage :** Détection de tendances, alertes sur baisses

---

### 📄 Requête 4 : Segmentation Clients

**Objectif :** Classer les clients selon leur comportement (RFM simplifié)  
**Résultat :** 663 lignes (tous les clients actifs)

**Segments définis :**
- 🌟 **VIP** : CA ≥ 100K ET Commandes ≥ 50
- ✅ **Régulier** : CA ≥ 50K OU Commandes ≥ 30
- 🟡 **Occasionnel** : Actif récemment (≤60 jours)
- ⚠️ **Inactif** : Peu d'achats ou longtemps sans commander

**Techniques SQL utilisées :**
- `CASE WHEN` multi-conditions pour segmentation
- `DATEDIFF()` pour calcul de récence
- `MAX()` pour dernière commande

**Cas d'usage :** Campagnes marketing ciblées, prévention churn

---

### 📄 Requête 5 : Top 3 Produits par Catégorie

**Objectif :** Analyse multi-dimensionnelle (catégorie × produit)  
**Résultat :** ~30-40 lignes (3 produits par catégorie)

**Colonnes :**
- Catégorie
- Nom du produit
- CA généré
- **Rang dans la catégorie** (1-3)

**Techniques SQL utilisées :**
- `RANK()` pour respecter les ex-aequo
- **`PARTITION BY`** pour classement par groupe (le rang redémarre par catégorie)
- Filtrage sur Window Function (nécessite CTE)

**Cas d'usage :** Dashboard merchandising, stratégie assortiment

---

## 💡 Compétences Techniques Démontrées

### SQL Avancé
✅ **Window Functions** (ROW_NUMBER, RANK, LAG, SUM/AVG OVER)  
✅ **Common Table Expressions (CTE)** multiples et enchaînées  
✅ **PARTITION BY** (classement par groupe)  
✅ **Pivot manuel** (MAX + CASE WHEN)  
✅ **CASE WHEN** multi-conditions (logique métier complexe)  
✅ **Agrégations complexes** (SUM, COUNT, MAX, AVG)  
✅ **Jointures multiples** (jusqu'à 5 tables)  
✅ **Fonctions temporelles** (DATEDIFF, FORMAT, YEAR)

### Business Intelligence
✅ Analyse KPI (CA, clients actifs, panier moyen)  
✅ Calcul de parts de marché  
✅ Évolutions temporelles (MoM, YoY)  
✅ Segmentation clients (RFM)  
✅ Analyse multi-dimensionnelle

### Bonnes Pratiques
✅ Code commenté et documenté  
✅ Structure claire avec CTE  
✅ Nommage explicite des colonnes  
✅ Gestion des cas limites (NULL, ex-aequo)

---

## 🚀 Comment Utiliser ce Projet

### Prérequis
- SQL Server (2016+) ou Azure SQL Database
- Base de données **WideWorldImporters** installée
- Outil de requêtage (SSMS, Azure Data Studio, VS Code...)

### Exécution
1. Ouvrir chaque fichier `.sql` dans votre éditeur
2. Se connecter à la base WideWorldImporters
3. Exécuter la requête (F5 ou Ctrl+E)
4. Analyser les résultats

### Adaptation
Ces requêtes sont **facilement adaptables** :
- Changer les années analysées (`WHERE YEAR = 2016` → 2017, 2018...)
- Modifier les seuils de segmentation (VIP, Régulier...)
- Ajuster les Top N (Top 10 → Top 20...)
- Appliquer à d'autres bases e-commerce similaires

---

## 📈 Résultats Clés (Exemples)

### KPI 2016 (janvier-mai)
- 💰 CA Total : ~239M€
- 👥 Clients Actifs : 663
- 📦 Commandes : 9,617
- 🛒 Panier Moyen : ~2,432€

### Top 3 Produits
1. **Air cushion machine (Blue)** - 1,44M€ (3.88%)
2. **10 mm Anti static bubble wrap** - 846K€ (2.55%)
3. **20 mm Double sided bubble wrap** - 853K€ (2.30%)

### Segmentation Clients
- 🌟 VIP : X clients → Y% du CA
- ✅ Réguliers : X clients → Y% du CA
- 🟡 Occasionnels : X clients → Y% du CA
- ⚠️ Inactifs : X clients → Y% du CA

---

## 🎓 Contexte Pédagogique

Ce projet a été réalisé dans le cadre d'une **formation intensive SQL avancé** avec les objectifs suivants :
- Maîtriser les Window Functions en contexte réel
- Pratiquer la structuration de requêtes complexes avec CTE
- Développer une pensée "business" dans l'analyse de données
- Créer un portfolio projet présentable en entretien

**Durée de réalisation :** ~10 heures (5 sessions de 2h)  
**Niveau :** Intermédiaire → Avancé

---

## 📚 Ressources

- [Documentation WideWorldImporters](https://learn.microsoft.com/en-us/sql/samples/wide-world-importers-what-is)
- [SQL Server Window Functions](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql)
- [Common Table Expressions (CTE)](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql)

---

## 👤 Auteur

**Formation SQL Dashboard - Janvier 2026**

Développé dans le cadre d'un projet d'apprentissage SQL avancé avec focus sur :
- Window Functions
- CTE
- Analyse business intelligence

---

## 📝 Licence

Ce projet est à usage éducatif et portfolio. La base de données WideWorldImporters est fournie par Microsoft sous licence libre.

---

## 🙏 Remerciements

- Microsoft pour la base de données WideWorldImporters
- Formation SQL intensive pour l'encadrement pédagogique

---

**⭐ N'hésitez pas à explorer les requêtes et à les adapter à vos besoins !**
