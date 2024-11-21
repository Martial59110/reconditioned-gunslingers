--------------------------------------------------------------------------------------------------------
-- Connexion à postgresql en tant qu'utilisateur par défaut : 
--------------------------------------------------------------------------------------------------------

psql postgres 

--------------------------------------------------------------------------------------------------------
-- Création de la base de données simpluedo : 
--------------------------------------------------------------------------------------------------------

CREATE DATABASE simpluedo;

--------------------------------------------------------------------------------------------------------
-- Création d'un utilisateur et de son mot de passe : 
--------------------------------------------------------------------------------------------------------

CREATE USER admin_simpluedo WITH PASSWORD 'password_simpluedo';

--------------------------------------------------------------------------------------------------------
-- Accord du privilège de création de rôle à l'utilisateur admin_simpluedo : 
--------------------------------------------------------------------------------------------------------

ALTER ROLE admin_simpluedo WITH CREATEROLE;

--------------------------------------------------------------------------------------------------------
-- Quitter l'interface psql : 
--------------------------------------------------------------------------------------------------------

\q

--------------------------------------------------------------------------------------------------------
-- Connexion à la base de données simpluedo avec l'identifiant admin_simpluedo en utilisant pgcli :
--------------------------------------------------------------------------------------------------------

pgcli -U admin_simpluedo -d simpluedo

--------------------------------------------------------------------------------------------------------
-- Création de la table role : 
--------------------------------------------------------------------------------------------------------

CREATE TABLE role (
    id_role INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_role VARCHAR(50) NOT NULL,
);

--------------------------------------------------------------------------------------------------------
-- Création de la table personnage :
--------------------------------------------------------------------------------------------------------

CREATE TABLE personnage (
    id_personnage INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_personnage VARCHAR(50) NOT NULL,
);

--------------------------------------------------------------------------------------------------------
-- Création de la table utilisateur : 
--------------------------------------------------------------------------------------------------------

CREATE TABLE utilisateur (
    uuid_utilisateur UUID PRIMARY KEY,
    pseudo_utilisateur VARCHAR(50) NOT NULL,
    id_role INTEGER NOT NULL,
    id_personnage INTEGER NOT NULL,
    FOREIGN KEY (id_role) REFERENCES role (id_role),
    FOREIGN KEY (id_personnage) REFERENCES personnage (id_personnage),
);

--------------------------------------------------------------------------------------------------------
-- Création de la table salle :
--------------------------------------------------------------------------------------------------------

CREATE TABLE salle (
    id_salle INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_salle VARCHAR(50) NOT NULL,
);

--------------------------------------------------------------------------------------------------------
-- Création de la table objet :
--------------------------------------------------------------------------------------------------------

CREATE TABLE objet (
    id_objet INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_objet VARCHAR(50) NOT NULL,
    id_salle INTEGER NOT NULL,
    FOREIGN KEY (id_salle) REFERENCES salle (id_salle),
);

--------------------------------------------------------------------------------------------------------
-- Création de la table d'association visiter pour les relations entre personnage et salle :
--------------------------------------------------------------------------------------------------------

CREATE TABLE visiter (
    id_visiter INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    heure_arrivee TIMESTAMPZ NOT NULL,
    heure_sortie TIMESTAMPZ NOT NULL,
    id_personnage INTEGER NOT NULL,
    id_salle INTEGER NOT NULL,
    FOREIGN KEY (id_personnage) REFERENCES personnage (id_personnage),
    FOREIGN KEY (id_salle) REFERENCES salle (id_salle),
);

--------------------------------------------------------------------------------------------------------

--> UUID PRIMARY KEY : permet de générer des identifiants uniques pour assurer une unicité globale. 
--> VARCHAR( ) : type de données pour stocker du texte avec une limite de ( ) caractères.
--> NOT NULL : contrainte pour s’assurer qu’aucune valeur est NULL.
--> TIMESTAMPZ : type de données pour les dates, les heures et incluant les fuseaux horaire.
--> INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY : génère automatiquement des identifiants uniques pour chaque ligne en incrémentant la valeur de manière séquentielle. 
    --> Remplace l’utilisation de SERIAL pour une meilleure conformité avec le standard SQL.
--> FOREIGN KEY : assure que les valeurs d’une colonne existent dans une colonne de référence d’une autre table.
--> REFERENCES : associe la clé étrangère à la clé primaire d’une autre table.

--------------------------------------------------------------------------------------------------------