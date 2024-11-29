init database = ok ça fonctionne
RG = ok
dictionnaire = KO, ne correspond pas au fichier init database
Rbac = aucun
MCD = ok mais ne correspond pas au fichier init_database
MLD = ko car heure_arrive est une clé primaire elel doit donc être en gras et souligné
MPD = ok
docker = non
requête = présente 
procédure = ok
trigger = ok
peuplement = ok
exactitude = ok
erreur = ok
readme = ok

Requête "Lister chaque joueur et son personnage associé" le nom de rôle ne correspond pas

Requête "Afficher les pièces où aucun personnage n'est allé" ne marche pas car la table pieces n'existe pas

Requête "Compter le nombre d'objets par pièce " Dans votre INNER JOIN, vous avez donné l'alias s à la table salles. Il faut donc utiliser cet alias pour référencer ses colonnes.
Par exemple, s.nom_salle au lieu de salle.nom_salle. et il manque un point virgule à la fin.

Requête "Ajouter une pièce " fonctionnel mais insère une donnée avec un id déjà existant donc message erreur
Requête "Supprimer une pièce " erreur nom de la table dans le Where + colonne pas précisée