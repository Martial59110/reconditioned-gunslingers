# ✏️ **Correction Twins**

## **État actuel des éléments :**

### **Scripts SQL**
- Le fichier `create-db-script.sql` fonctionne correctement.
- Les procédures et les triggers sont opérationnels.
- Le peuplement de la base de données est également fonctionnel.
- L'exactitude des données correspond bien au jeu Cluedo.
- Il n'y a pas d'erreurs dans la création de la base de données, des tables, des utilisateurs et leurs privilèges, ainsi que dans les procédures, triggers et peuplement.



## **Problèmes relevés :**

### **Dictionnaire de données**
- Le dictionnaire de données **ne correspond pas** aux tables, ni au MCD, MLD, et MPD.
  - **Exemple** : Dans le dictionnaire, la colonne `pseudo` ne correspond pas à la colonne `pseudo_users` de la table `utilisateurs`.

### **MCD**
- Le MCD n’est pas valide, car certaines colonnes ne correspondent pas aux tables.

### **MLD**
- Le MLD présente des erreurs :
  - La colonne `heure_arrive` n’est pas identifiée comme une clé primaire (composée), car elle n’est ni soulignée ni mise en gras.

### **MPD**
- Le MPD est incorrect :
  - Certains types de données ne correspondent pas à ceux des tables.

### **RBAC et Docker**
- Aucun système **RBAC** (Role-Based Access Control) n’est mis en place.
- Absence de **Docker** pour la gestion des environnements.

### **README.md**
- Le fichier `README.md` est présent mais manque de contenu.



## **Problèmes dans les requêtes SQL :**

### **Requête : "Lister chaque joueur et son personnage associé"**
- **Problème** :
  - Dans le `WHERE`, le `nom_role` utilise "Enqueteur" au lieu de "ENQ".

### **Requête : "Afficher les pièces où aucun personnage n'est allé"**
- **Problème** :
  - La table `pieces` n’existe pas (la table correcte est `salles`).

### **Requête : "Compter le nombre d'objets par pièce"**
- **Problèmes identifiés** :
  - Dans le `INNER JOIN`, l’alias `s` de la table `salles` n’est pas réutilisé dans le `GROUP BY`.
  - Une faute d’orthographe : il manque un "s" dans la table `salles` dans le `GROUP BY`.
  - Absence d’un point-virgule (`;`) à la fin.

### **Requête : "Ajouter une pièce"**
- **Problème** :
  - Fonctionnelle, mais l'exemple donné tente d'insérer un ID déjà existant, ce qui génère une erreur.

### **Requête : "Supprimer une pièce"**
- **Problème** :
  - Dans le `WHERE`, le nom de la table `salles` est mal écrit, et la colonne à utiliser n’est pas précisée.




## **Résumé des points à corriger :**
- MCD, MLD, MPD et dictionnaire de données à ajuster pour correspondre aux tables.
- Corrections à apporter aux requêtes SQL.
- Amélioration du contenu du `README.md`.
