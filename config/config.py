import os

# ====================================================
# 1. CONFIGURATION DE LA BASE DE DONNÉES (MySQL)
# ====================================================
# Modifie 'root' ou le mot de passe selon votre propre installation MySQL
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',          
    'password': '',          # Laisse le vide si tu vous n'avez  pas de mot de passe
    'database': 'classicmodels',
    'port': 3306
}

# ====================================================
# 2. GESTION DES CHEMINS (PATHS)
# ====================================================
# Cette partie permet à votre code de fonctionner sur n'importe quel ordinateur
# Elle calcule automatiquement où se trouve votre projet.

# Le dossier où se trouve ce fichier config.py
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Le dossier racine du projet (un cran au-dessus de config/)
PROJECT_ROOT = os.path.dirname(BASE_DIR)

# Les chemins vers tes dossiers importants
DIR_DATA = os.path.join(PROJECT_ROOT, 'data')
DIR_EXPORTS = os.path.join(PROJECT_ROOT, 'src', 'exports')
DIR_REPORTS = os.path.join(PROJECT_ROOT, 'reports')
DIR_IMAGES = os.path.join(PROJECT_ROOT, 'visualizations')

# ====================================================
# 3. PARAMÈTRES D'ANALYSE
# ====================================================
# Tu peux mettre ici des constantes utiles pour tes calculs
ANNEE_ANALYSE = 2004
TVA = 0.20