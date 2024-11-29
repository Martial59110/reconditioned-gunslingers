# ✏️ Correction Twins

Le fichier create-db-script.sql fonctionne.  
Les règles de gestion son correctes.  
Le dictionnaire de données ne correspond pas aux tables ainsi qu'au MCD, MLD et MPD.  
Exemple : Dans le dictionnaire de données la colonne "pseudo" ne correspond pas à la colonne "pseudo_users" de la table utilisateurs.  
Pas de RBAC.  
Le MCD n'est pas bon car les colonnes ne correspondent pas toutes aux tables.  
Le MLD n'est pas bon car la colonne "heure_arrive" n'est pas considérée comme une clé primaire (composée) car elle n'est pas soulignée et mise en gras.  
MPD : Le MPD n'est pas bon car certains type de données ne correspondent pas au type de données inscrit dans les tables.  
Pas de Docker.  
Les procédures fonctionnent.  
Les triggers fonctionnent.  
Le peuplement fonctionne.  
L'exactitude des données correspondent bien au jeu cluedo.  
Il n'y a pas d'erreur dans la création de la database de ses tables, users et leurs privilèges, procédures, triggers et le peuplement.  
Le README.md est bien présent cependant il manque un peu de contenu.  

Les requêtes sont bien séparées et présentes dans le README.md mais certaines requêtes ne fonctionnent pas :  
La requête "Lister chaque joueur et son personnage associé" ne fonctionne pas car le "nom_role" dans le WHERE ne correspond pas (utilise "Enqueteur" au lieu de "ENQ").  

La requête "Afficher les pièces où aucun personnage n'est allé" ne fonctionne pas car la table "pieces" n'existe pas (normalement table salles).  

La requête "Compter le nombre d'objets par pièce" ne fonctionne pas car dans le INNER JOIN L'alias "s" de la table "salles" n'est réutilisé dans GROUP BY "salle.nom_salle", de plus il manque un "s" dans la table "salles" dans le GROUP BY. Il manque également un ";".  

La requête "Ajouter une pièce" est fonctionnelle mais dans l'exemple donné la requêtes tente d'insérer un id déjà existant. Il y'a donc un message d'erreur.  

La requête "Supprimer une pièce" ne fonctionne pas car dans le WHERE le nom de la table salles est mal écrite et la colonne n'est pas précisée.  