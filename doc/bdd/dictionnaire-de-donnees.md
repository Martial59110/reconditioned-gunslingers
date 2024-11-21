 # 🌀 Dictionnaire de données pour Simpluedo 

| **Nom de la colonne**  | **Type**    | **Taille**   | **Description**                                  |
|-------------------------|-------------|--------------|--------------------------------------------------|
| `uuid_utilisateur`      | UUID        |              | Identifiant unique de l'utilisateur              |
| `pseudo_utilisateur`    | VARCHAR     | 50           | Pseudonyme de l'utilisateur                      |
| `id_role`               | INTEGER     |              | Identifiant du rôle attribué à l'utilisateur     |
| `nom_role`              | VARCHAR     | 50           | Nom du rôle de l'utilisateur                    |
| `id_personnage`         | INTEGER     |              | Identifiant du personnage                        |
| `nom_personnage`        | VARCHAR     | 50           | Nom du personnage                                |
| `id_salle`              | INTEGER     |              | Identifiant de la salle                          |
| `nom_salle`             | VARCHAR     | 50           | Nom de la salle                                  |
| `id_objet`              | INTEGER     |              | Identifiant de l'objet                           |
| `nom_objet`             | VARCHAR     | 50           | Nom de l'objet                                   |
| `heure_arrivee`         | TIMESTAMPZ       |              | Heure d'arrivée du personnage dans la salle      |
| `heure_sortie`          | TIMESTAMPZ        |              | Heure de sortie du personnage de la salle        |
