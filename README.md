#  ClassicModels Data Analysis Project

Ce projet est une analyse complète de la base de données **ClassicModels** (vente de modèles réduits). Il combine SQL pour l'extraction des données et Python pour la visualisation et les analyses avancées (segmentation client, prédictions, logistique).

##  Structure du Projet

Voici l'organisation des fichiers :

* **`config/`** : Fichiers de configuration du projet.
* **`database/`** : Contient tous les scripts liés à la base de données.
    * **`queries/`** :
        * `01_exploration_....sql` à `05_time_analysis.sql` : Requêtes d'analyse (Partie 1 & 2).
        * `06_automations.sql` : Procédures stockées, Triggers et Fonctions.
        * `07_tests_validation.sql` : Tests unitaires pour valider les automatisations.
    * **`schema/`** :
        * `mysqlsampledatabase.sql` : Script d'installation de la base.
        * `classicmodels_model.mwb` : Modèle relationnel (MySQL Workbench).
* **`notebooks/`** : Contient le Jupyter Notebook principal avec les analyses Python.
* **`reports/`** : Rapports générés (PDF ou autre).
* **`src/`** : Code source modulaire.
    * `Analysis/` : Scripts d'analyse Python.
    * `database/` : Modules de connexion à la BDD.
    * `exports/` : Fichiers exportés (CSV, Excel).
* **`visualizations/`** : Contient les graphiques générés (PNG) par l'analyse.
* **`README.md`** : Documentation du projet.
* **`requirements.txt`** : Liste des librairies Python nécessaires.

---

##  Installation & Configuration

Suivez ces étapes pour lancer le projet sur votre machine.

### 1. Prérequis
* **MySQL Server** et **MySQL Workbench** installés.
* **Python 3.8+** (via Anaconda ou installation standard).
* **Git** installé.

### 2. Installation de la Base de Données (SQL)
1.  Ouvrez **MySQL Workbench**.
2.  Allez dans `Server` > `Data Import`.
3.  Importez le fichier `database/schema/mysqlsampledatabase.sql`.
4.  Ouvrez et exécutez le script `database/queries/06_automations.sql` pour installer les procédures stockées et triggers.

### 3. Installation de l'environnement Python
1.  Clonez ce dépôt :
    ```bash
    git clone [https://github.com/VOTRE-NOM-UTILISATEUR/classicmodels-analysis.git](https://github.com/VOTRE-NOM-UTILISATEUR/classicmodels-analysis.git)
    cd classicmodels-analysis
    ```

2.  Installez les dépendances nécessaires :
    ```bash
    pip install pandas matplotlib seaborn mysql-connector-python
    ```

### 4. Lancer l'analyse
1.  Ouvrez le terminal dans le dossier du projet.
2.  Lancez Jupyter Notebook :
    ```bash
    jupyter notebook
    ```
3.  Ouvrez le fichier dans le dossier `notebooks/`.
4.  **Important :** Vérifiez vos identifiants de base de données (user/password) dans la cellule de connexion au début du Notebook.

---

## Aperçu des Analyses

Le projet couvre 4 axes principaux :
1.  **Exploration SQL** : Analyse des ventes, clients et produits (Fichiers 01 à 03).
2.  **Automatisation** : Calcul automatique des commissions et alertes de stock via SQL (Fichier 06).
3.  **Visualisation** : Graphiques d'évolution du CA et répartition géographique.
4.  **Analyses Avancées** (Partie 4) :
    * Segmentation Client (RFM).
    * Saisonnalité des ventes.
    * Analyse de corrélation (Prix vs Quantité).
    * Cross-Selling (Produits achetés ensemble).

---
*Projet réalisé dans le cadre du cours de Data Analysis & SQL.*
