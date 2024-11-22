--------------------------------------------------------------------------------------------------------
-- Connexion à postgresql en tant qu'utilisateur par défaut : 
--------------------------------------------------------------------------------------------------------

psql postgres 

--------------------------------------------------------------------------------------------------------
-- Suppression de la base de données simpluedo si elle existe déjà :
--------------------------------------------------------------------------------------------------------

DROP DATABASE IF EXISTS simpluedo;

--------------------------------------------------------------------------------------------------------
-- Création de la base de données simpluedo :
--------------------------------------------------------------------------------------------------------

CREATE DATABASE simpluedo;

--------------------------------------------------------------------------------------------------------
-- Connexion à la base de données simpluedo :
--------------------------------------------------------------------------------------------------------

\c simpluedo

--------------------------------------------------------------------------------------------------------
-- Création d'un utilisateur et de son mot de passe :
--------------------------------------------------------------------------------------------------------

CREATE USER admin_simpluedo WITH PASSWORD 'password_simpluedo';

--------------------------------------------------------------------------------------------------------
-- Accord du privilège de création de rôle à l'utilisateur admin_simpluedo :
--------------------------------------------------------------------------------------------------------

GRANT ALL PRIVILEGES ON DATABASE simpluedo TO admin_simpluedo;

--------------------------------------------------------------------------------------------------------
-- Activation de l'extension uuid-ossp (pour les UUID) :
--------------------------------------------------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--------------------------------------------------------------------------------------------------------
-- Création de la table roles :
--------------------------------------------------------------------------------------------------------

CREATE TABLE roles (
    id_role INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_role VARCHAR(50) NOT NULL
);

--------------------------------------------------------------------------------------------------------
-- Création de la table personnages :
--------------------------------------------------------------------------------------------------------

CREATE TABLE personnages (
    id_personnage INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_personnage VARCHAR(50) NOT NULL
);

--------------------------------------------------------------------------------------------------------
-- Création de la table utilisateurs :
--------------------------------------------------------------------------------------------------------

CREATE TABLE utilisateurs (
    uuid_utilisateur UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pseudo_utilisateur VARCHAR(50) NOT NULL,
    id_role INTEGER NOT NULL,
    id_personnage INTEGER NOT NULL,
    FOREIGN KEY (id_role) REFERENCES roles (id_role) ON UPDATE CASCADE,
    FOREIGN KEY (id_personnage) REFERENCES personnages (id_personnage) ON UPDATE CASCADE
);

--------------------------------------------------------------------------------------------------------
-- Création de la table salles :
--------------------------------------------------------------------------------------------------------

CREATE TABLE salles (
    id_salle INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_salle VARCHAR(50) NOT NULL
);

--------------------------------------------------------------------------------------------------------
-- Création de la table objets :
--------------------------------------------------------------------------------------------------------

CREATE TABLE objets (
    id_objet INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nom_objet VARCHAR(50) NOT NULL,
    id_salle INTEGER NOT NULL,
    FOREIGN KEY (id_salle) REFERENCES salles (id_salle) ON UPDATE CASCADE
);

--------------------------------------------------------------------------------------------------------
-- Création de la table d'association visiter :
--------------------------------------------------------------------------------------------------------

CREATE TABLE visiter (
    id_personnage INTEGER REFERENCES personnages (id_personnage),
    id_salle INTEGER REFERENCES salles (id_salle),
    heure_arrivee TIME NOT NULL,
    heure_sortie TIME NULL,
    PRIMARY KEY (id_personnage, id_salle, heure_arrivee)
);

--------------------------------------------------------------------------------------------------------
-- Accorde des privilèges à l'utilisateur admin_simpluedo :
--------------------------------------------------------------------------------------------------------

GRANT INSERT, UPDATE, DELETE, SELECT ON TABLE roles, personnages, utilisateurs, salles, objets, visiter TO admin_simpluedo;

--------------------------------------------------------------------------------------------------------
-- Révoque les privilèges pour PUBLIC :
--------------------------------------------------------------------------------------------------------

REVOKE ALL ON TABLE roles, personnages, utilisateurs, salles, objets, visiter FROM PUBLIC;
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