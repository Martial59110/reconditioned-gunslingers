

# Sommaire du dépôt

1. [Règles gestion](/doc/regles-de-gestion.md) 📄 
2. [Dictionnaire de données](/doc/bdd/dictionnaire-de-donnees.md) 📄 
3. [MCD](/doc/bdd/MCD.jpg) 📄 
4. [MLD](/doc/bdd/MLD.jpg) 📄 
5. [MPD](/doc/bdd/MPD.jpg) 📄 
6. [BDD initialisation](/doc/bdd/bdd-init.sql) 📄 
7. [Requêtes](/doc/bdd/requetes.sql) 📄 
8. [Dossier sauvegardes](/doc/bdd/sauvegardes/) 📁


# Table des Matières
1. [Contexte du Projet](#contexte-du-projet)
2. [Objectifs de la Mission](#objectifs-de-la-mission)
3. [Règles de la Base de Données](#règles-de-la-base-de-données)
4. [Peuplement des Données](#peuplement-des-données)
5. [Requêtes SQL à Réaliser](#requêtes-sql-à-réaliser)
6. [Procédures Stockées](#procédures-stockées)
7. [Triggers](#triggers)
8. [Contraintes Techniques](#contraintes-techniques)
9. [Livrables](#livrables)
10. [Critères de Performance](#critères-de-performance)

## Contexte du Projet

Bienvenue sur **Simpluedo** 🕵️‍♂️, un projet inspiré du célèbre jeu de société **Cluedo**. L'objectif est de créer une plateforme permettant de gérer une partie de ce jeu en enregistrant les mouvements des personnages dans un manoir, leurs interactions avec les pièces, et les objets présents.

### Mission Actuelle

La première étape consiste à concevoir et à mettre en place une **base de données relationnelle** qui stockera toutes les informations nécessaires pour gérer une partie. Ce projet est structuré en différentes phases, la phase actuelle étant dédiée à la conception et à l'implémentation des données.


## Objectifs de la Mission

1. **Analyse des Besoins**
   - Comprendre les relations entre les entités telles que les joueurs, personnages, pièces, et objets.
   - Identifier les contraintes spécifiques liées au jeu Simpluedo (e.g., un seul maître de jeu par partie).

2. **Modélisation de la Base de Données**
   - Concevoir un **Modèle Conceptuel de Données (MCD)**, un **Modèle Logique de Données (MLD)** et un **Modèle Physique de Données (MPD)**.
   - Assurer que le modèle respecte les règles métier (par exemple, gestion des rôles et des déplacements des personnages).

3. **Implémentation de la Base de Données**
   - Générer la structure SQL basée sur le MPD.
   - Configurer les contraintes d'intégrité, les clés primaires et étrangères.

4. **Mise en Place de Fonctions Avancées**
   - Création de procédures stockées pour automatiser les opérations fréquentes.
   - Mise en œuvre de triggers pour tenir à jour les informations en temps réel.



## Règles de la Base de Données

- Chaque **joueur** doit avoir un rôle (Maître du jeu, utilisateur ou observateur).
- **Un seul maître de jeu** est autorisé par partie.
- Chaque joueur, sauf les observateurs, doit avoir un personnage.
- Les **personnages** peuvent se déplacer dans différentes **pièces** du manoir et y revenir à plusieurs reprises.
- Une pièce peut contenir une **liste d'objets**, qui peut être modifiée pendant la partie.



## Peuplement des Données

- Les données initiales concernant les personnages, pièces, et objets doivent correspondre à celles du jeu **Cluedo original**.
- Utiliser des scripts SQL pour insérer les données de peuplement.


## Requêtes SQL à Réaliser

1. Lister tous les personnages du jeu.
2. Lister chaque joueur et son personnage associé.
3. Afficher les personnages présents dans la cuisine entre 08:00 et 09:00.
4. Afficher les pièces où **aucun personnage** n’est allé.
5. Compter le nombre d’objets par pièce.
6. Ajouter une pièce.
7. Modifier un objet.
8. Supprimer une pièce.



## Procédures Stockées

1. Lister tous les objets présents dans une pièce donnée (paramètre : nom de la pièce).
2. Ajouter un objet à une pièce spécifiée (paramètres : nom de l’objet et nom de la pièce).



## Triggers

- Une **table supplémentaire** devra enregistrer la localisation en temps réel de chaque personnage.
- Mettre à jour cette table via un trigger à chaque fois qu’un personnage entre ou sort d’une pièce.



## Contraintes Techniques

- Le NoSQL est **interdit** pour ce projet.
- Implémentation d’un système de **contrôle RBAC** (Role-Based Access Control) pour gérer les permissions.
- Seul l’administrateur peut effectuer des modifications ou ajouts dans la base.


## Livrables

1. **Modèles de Données** : MCD, MLD, MPD.
2. Scripts SQL pour :
   - Générer la structure de la base.
   - Peupler les données.
3. Requêtes SQL documentées dans le `README.md`.
4. **Dépôt GitHub** contenant :
   - Le dictionnaire de données.
   - Les modèles de données.
   - Les scripts SQL.
   - Les requêtes SQL documentées.
5. (Optionnel) Environnement Docker pour faciliter l’installation.



## Critères de Performance

- Installation de l’environnement sans erreur.
- Exactitude des relations entre les tables.
- Triggers fonctionnels et corrects.
- Documentation claire et complète des requêtes.
- Requêtes SQL exécutées avec succès.



