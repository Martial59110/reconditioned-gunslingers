--------------------------------------------------------------------------------------------------------
-- Lister tous les personnages du jeu :
--------------------------------------------------------------------------------------------------------

SELECT * 
FROM personnages;

--------------------------------------------------------------------------------------------------------
-- Lister chaque joueur et son personnage associé :
--------------------------------------------------------------------------------------------------------

SELECT *
FROM utilisateurs
INNER JOIN personnages ON utilisateurs.id_personnage = personnages.id_personnage;

--------------------------------------------------------------------------------------------------------
-- Afficher la liste des personnages présents dans la cuisine entre 08:00 et 09:00 :
--------------------------------------------------------------------------------------------------------

SELECT *
FROM personnages
INNER JOIN visiter ON personnages.id_personnage = visiter.id_personnage
INNER JOIN salles ON visiter.id_salle = salles.id_salle
WHERE LOWER(salles.nom_salle) = LOWER('cuisine') AND visiter.heure_arrivee BETWEEN '08:00' AND '09:00'; 

--------------------------------------------------------------------------------------------------------
-- Afficher les pièces où aucun personnage n'est allé :
--------------------------------------------------------------------------------------------------------

SELECT *
FROM salles
LEFT JOIN visiter ON salles.id_salle = visiter.id_salle
WHERE visiter.id_personnage IS NULL;

--------------------------------------------------------------------------------------------------------
-- Compter le nombre d'objets par pièce :
--------------------------------------------------------------------------------------------------------    

SELECT salles.nom_salle, COUNT(objets.id_objet)
FROM salles
LEFT JOIN objets ON salles.id_salle = objets.id_salle
GROUP BY salles.nom_salle ORDER BY COUNT(objets.id_objet);

--------------------------------------------------------------------------------------------------------
-- Ajouter une pièce :
-------------------------------------------------------------------------------------------------------- 

INSERT INTO salles (nom_salle) VALUES ('nouvelle salle');

--------------------------------------------------------------------------------------------------------
-- Modifier un objet :
-------------------------------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------------------------------
-- Supprimer une pièce:
-------------------------------------------------------------------------------------------------------- 