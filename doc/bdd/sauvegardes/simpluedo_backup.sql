--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: ajouter_objet(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ajouter_objet(nom_objet character varying, nom_salle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.ajouter_objet(nom_objet character varying, nom_salle character varying) OWNER TO postgres;

--
-- Name: gerer_entree_personnage(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerer_entree_personnage(id_personnage_input integer, id_salle_input integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.gerer_entree_personnage(id_personnage_input integer, id_salle_input integer) OWNER TO postgres;

--
-- Name: lister_objets(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lister_objets(nom_salle character varying) RETURNS TABLE(nom_objet character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT o.nom_objet
    FROM objets o
    JOIN salles s ON o.id_salle = s.id_salle
    WHERE s.nom_salle = nom_salle;
END;
$$;


ALTER FUNCTION public.lister_objets(nom_salle character varying) OWNER TO postgres;

--
-- Name: trigger_update_position_actuelle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_update_position_actuelle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.trigger_update_position_actuelle() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: objets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objets (
    id_objet integer NOT NULL,
    nom_objet character varying(50) NOT NULL,
    id_salle integer NOT NULL
);


ALTER TABLE public.objets OWNER TO postgres;

--
-- Name: objets_id_objet_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.objets ALTER COLUMN id_objet ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.objets_id_objet_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: personnages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personnages (
    id_personnage integer NOT NULL,
    nom_personnage character varying(50) NOT NULL
);


ALTER TABLE public.personnages OWNER TO postgres;

--
-- Name: personnages_id_personnage_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.personnages ALTER COLUMN id_personnage ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.personnages_id_personnage_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: position_actuelle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.position_actuelle (
    id_personnage integer NOT NULL,
    id_salle integer,
    heure_arrivee time without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.position_actuelle OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_role integer NOT NULL,
    nom_role character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id_role ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: salles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salles (
    id_salle integer NOT NULL,
    nom_salle character varying(50) NOT NULL
);


ALTER TABLE public.salles OWNER TO postgres;

--
-- Name: salles_id_salle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.salles ALTER COLUMN id_salle ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.salles_id_salle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateurs (
    uuid_utilisateur uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    pseudo_utilisateur character varying(50) NOT NULL,
    id_role integer,
    id_personnage integer
);


ALTER TABLE public.utilisateurs OWNER TO postgres;

--
-- Name: visiter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visiter (
    id_personnage integer NOT NULL,
    id_salle integer NOT NULL,
    heure_arrivee time without time zone DEFAULT now() NOT NULL,
    heure_sortie time without time zone
);


ALTER TABLE public.visiter OWNER TO postgres;

--
-- Data for Name: objets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.objets (id_objet, nom_objet, id_salle) FROM stdin;
1	Poignard	3
2	Revolver	5
3	Chandelier	1
4	Corde	6
5	Clé anglaise	4
6	Matraque	2
\.


--
-- Data for Name: personnages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personnages (id_personnage, nom_personnage) FROM stdin;
1	Colonel MOUTARDE
2	Docteur OLIVE
3	Professeur VIOLET
4	Madame PERVENCHE
5	Mademoiselle ROSE
6	Madame LEBLANC
\.


--
-- Data for Name: position_actuelle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.position_actuelle (id_personnage, id_salle, heure_arrivee) FROM stdin;
1	1	08:15:00
2	1	08:45:00
3	1	09:00:00
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id_role, nom_role) FROM stdin;
1	observateur
2	utilisateur
3	maitre du jeu
\.


--
-- Data for Name: salles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salles (id_salle, nom_salle) FROM stdin;
1	Cuisine
2	Grand salon
3	Petit salon
4	Bureau
5	Bibliothèque
6	Studio
7	Hall
8	Véranda
9	Salle à manger
\.


--
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilisateurs (uuid_utilisateur, pseudo_utilisateur, id_role, id_personnage) FROM stdin;
a7512e9a-bb2b-40ee-9efd-874a2e03fd9e	Srekaens	3	2
99727b1e-a520-441a-8152-b796f79e37a6	MessaKami	2	1
3491cb69-a612-42a9-8d87-904912a02903	GETGETR	2	3
1d7ab794-5612-47a9-b9ba-3922b7389bcf	Shotax	2	6
8d22fc7f-945b-416a-b0d8-709d066b46e8	Nuage	2	5
ad191268-591c-4724-b173-5a87086d656f	Puduchlip	2	4
5fc36397-a473-4c62-ac07-352be6fddb1f	Martial	1	\N
15a9e6f3-8008-4354-97b4-3679bd161a1d	Enguerran	1	\N
76c4c4ba-1397-4ce6-a26b-16f06aef9a85	Boris	1	\N
d03afcb6-3c4f-4f33-976b-7fab2c29bbd4	Yohan	1	\N
e28c972a-53ae-45dd-8a61-e0d7794034c2	Aurore	1	\N
8f3bce41-acb8-44e8-be70-210493b5d6fa	Gabriel	1	\N
\.


--
-- Data for Name: visiter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visiter (id_personnage, id_salle, heure_arrivee, heure_sortie) FROM stdin;
1	2	13:24:00.003519	13:24:00.003519
1	2	13:25:08.026807	13:25:08.026807
1	2	08:15:00	08:15:00
2	2	08:45:00	08:45:00
3	1	10:00:00	10:00:00
1	1	08:15:00	08:15:00
2	1	08:45:00	08:45:00
3	1	09:00:00	09:00:00
\.


--
-- Name: objets_id_objet_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.objets_id_objet_seq', 6, true);


--
-- Name: personnages_id_personnage_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personnages_id_personnage_seq', 6, true);


--
-- Name: roles_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_role_seq', 3, true);


--
-- Name: salles_id_salle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salles_id_salle_seq', 9, true);


--
-- Name: objets objets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objets
    ADD CONSTRAINT objets_pkey PRIMARY KEY (id_objet);


--
-- Name: personnages personnages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personnages
    ADD CONSTRAINT personnages_pkey PRIMARY KEY (id_personnage);


--
-- Name: position_actuelle position_actuelle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_actuelle
    ADD CONSTRAINT position_actuelle_pkey PRIMARY KEY (id_personnage);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_role);


--
-- Name: salles salles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salles
    ADD CONSTRAINT salles_pkey PRIMARY KEY (id_salle);


--
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (uuid_utilisateur);


--
-- Name: visiter visiter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visiter
    ADD CONSTRAINT visiter_pkey PRIMARY KEY (id_personnage, id_salle, heure_arrivee);


--
-- Name: visiter update_position_actuelle_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_position_actuelle_trigger AFTER INSERT ON public.visiter FOR EACH ROW EXECUTE FUNCTION public.trigger_update_position_actuelle();


--
-- Name: objets objets_id_salle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objets
    ADD CONSTRAINT objets_id_salle_fkey FOREIGN KEY (id_salle) REFERENCES public.salles(id_salle) ON UPDATE CASCADE;


--
-- Name: position_actuelle position_actuelle_id_personnage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_actuelle
    ADD CONSTRAINT position_actuelle_id_personnage_fkey FOREIGN KEY (id_personnage) REFERENCES public.personnages(id_personnage);


--
-- Name: position_actuelle position_actuelle_id_salle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.position_actuelle
    ADD CONSTRAINT position_actuelle_id_salle_fkey FOREIGN KEY (id_salle) REFERENCES public.salles(id_salle);


--
-- Name: utilisateurs utilisateurs_id_personnage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_id_personnage_fkey FOREIGN KEY (id_personnage) REFERENCES public.personnages(id_personnage) ON UPDATE CASCADE;


--
-- Name: utilisateurs utilisateurs_id_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.roles(id_role) ON UPDATE CASCADE;


--
-- Name: visiter visiter_id_personnage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visiter
    ADD CONSTRAINT visiter_id_personnage_fkey FOREIGN KEY (id_personnage) REFERENCES public.personnages(id_personnage);


--
-- Name: visiter visiter_id_salle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visiter
    ADD CONSTRAINT visiter_id_salle_fkey FOREIGN KEY (id_salle) REFERENCES public.salles(id_salle);


--
-- Name: TABLE objets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.objets TO admin_simpluedo;


--
-- Name: TABLE personnages; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.personnages TO admin_simpluedo;


--
-- Name: TABLE position_actuelle; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.position_actuelle TO admin_simpluedo;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.roles TO admin_simpluedo;


--
-- Name: TABLE salles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.salles TO admin_simpluedo;


--
-- Name: TABLE utilisateurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.utilisateurs TO admin_simpluedo;


--
-- Name: TABLE visiter; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.visiter TO admin_simpluedo;


--
-- PostgreSQL database dump complete
--

