--------------------------------------------------------------------------------------------------------
-- Connexion à PostgreSQL en tant qu'utilisateur par défaut : 
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
    id_role INTEGER NULL,
    id_personnage INTEGER NULL,
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
    heure_arrivee TIME NOT NULL DEFAULT NOW(),
    heure_sortie TIME NULL,
    PRIMARY KEY (id_personnage, id_salle, heure_arrivee)
);

--------------------------------------------------------------------------------------------------------
-- Création de la table position_actuelle :
--------------------------------------------------------------------------------------------------------

CREATE TABLE position_actuelle (
    id_personnage INTEGER PRIMARY KEY REFERENCES personnages (id_personnage),
    id_salle INTEGER REFERENCES salles (id_salle),
    heure_arrivee TIME NOT NULL DEFAULT NOW()
);

--------------------------------------------------------------------------------------------------------
-- Accorde des privilèges à l'utilisateur admin_simpluedo :
--------------------------------------------------------------------------------------------------------

GRANT INSERT, UPDATE, DELETE, SELECT ON TABLE roles, personnages, utilisateurs, salles, objets, visiter, position_actuelle TO admin_simpluedo;

--------------------------------------------------------------------------------------------------------
-- Révoque les privilèges pour PUBLIC :
--------------------------------------------------------------------------------------------------------

REVOKE ALL ON TABLE roles, personnages, utilisateurs, salles, objets, visiter, position_actuelle FROM PUBLIC;

--------------------------------------------------------------------------------------------------------
-- Création de procédures stockées :
--------------------------------------------------------------------------------------------------------

-- 1. Ajouter un objet à une salle passée en paramètre
CREATE OR REPLACE FUNCTION ajouter_objet(nom_objet VARCHAR, nom_salle VARCHAR)
RETURNS VOID AS $$
DECLARE
    salle_id INTEGER;
BEGIN
    -- Récupération de l'ID de la salle
    SELECT id_salle INTO salle_id
    FROM salles
    WHERE nom_salle = nom_salle;

    -- Si la salle n'existe pas, on lève une exception
    IF salle_id IS NULL THEN
        RAISE EXCEPTION 'La salle "%" n''existe pas.', nom_salle;
    END IF;

    -- Ajout de l'objet dans la salle
    INSERT INTO objets (nom_objet, id_salle)
    VALUES (nom_objet, salle_id);
END;
$$ LANGUAGE plpgsql;

-- 2. Lister les objets d'une salle
CREATE OR REPLACE FUNCTION lister_objets(nom_salle VARCHAR)
RETURNS TABLE (nom_objet VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT o.nom_objet
    FROM objets o
    JOIN salles s ON o.id_salle = s.id_salle
    WHERE s.nom_salle = nom_salle;
END;
$$ LANGUAGE plpgsql;

-- 3. Gérer l'entrée d'un personnage dans une salle
CREATE OR REPLACE FUNCTION gerer_entree_personnage(id_personnage_input INTEGER, id_salle_input INTEGER)
RETURNS VOID AS $$
BEGIN
    -- Complète l'heure de sortie dans visiter pour le déplacement précédent
    UPDATE visiter
    SET heure_sortie = NOW()
    WHERE id_personnage = id_personnage_input
    AND heure_sortie IS NULL;

    -- Insère le nouveau déplacement dans visiter
    INSERT INTO visiter (id_personnage, id_salle, heure_arrivee)
    VALUES (id_personnage_input, id_salle_input, NOW());

    -- Met à jour ou insère dans position_actuelle
    INSERT INTO position_actuelle (id_personnage, id_salle, heure_arrivee)
    VALUES (id_personnage_input, id_salle_input, NOW())
    ON CONFLICT (id_personnage)
    DO UPDATE SET id_salle = EXCLUDED.id_salle, heure_arrivee = EXCLUDED.heure_arrivee;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------
-- Création de triggers pour automatiser les mises à jour :
--------------------------------------------------------------------------------------------------------

-- Trigger pour gérer les déplacements des personnages
CREATE OR REPLACE FUNCTION trigger_update_position_actuelle()
RETURNS TRIGGER AS $$
BEGIN
    -- Complète l'heure de sortie dans visiter
    UPDATE visiter
    SET heure_sortie = NEW.heure_arrivee
    WHERE id_personnage = NEW.id_personnage
    AND heure_sortie IS NULL;

    -- Met à jour ou insère dans position_actuelle
    INSERT INTO position_actuelle (id_personnage, id_salle, heure_arrivee)
    VALUES (NEW.id_personnage, NEW.id_salle, NEW.heure_arrivee)
    ON CONFLICT (id_personnage)
    DO UPDATE SET id_salle = EXCLUDED.id_salle, heure_arrivee = EXCLUDED.heure_arrivee;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_position_actuelle_trigger
AFTER INSERT ON visiter
FOR EACH ROW
EXECUTE FUNCTION trigger_update_position_actuelle();

--------------------------------------------------------------------------------------------------------

--> UUID PRIMARY KEY : permet de générer des identifiants uniques pour assurer une unicité globale. 
--> VARCHAR( ) : type de données pour stocker du texte avec une limite de ( ) caractères.
--> NOT NULL : contrainte pour s’assurer qu’aucune valeur est NULL.
--> TIMESTAMPZ : type de données pour les dates, les heures et incluant les fuseaux horaire.
--> INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY : génère automatiquement des identifiants uniques pour chaque ligne en incrémentant la valeur de manière séquentielle. 
    --> Remplace l’utilisation de SERIAL pour une meilleure conformité avec le standard SQL.
--> FOREIGN KEY : assure que les valeurs d’une colonne existent dans une colonne de référence d’une autre table.
--> REFERENCES : associe la clé étrangère à la clé primaire d’une autre table.
