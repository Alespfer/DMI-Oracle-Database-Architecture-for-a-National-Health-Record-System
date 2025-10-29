-- Objectif: Creation de l'utilisateur (schema) DMI_APP et attribution des privileges de base.
-- A executer en tant que SYSTEM.

SPOOL create_schema.txt

PROMPT '>> =============================================================='
PROMPT '>> Fichier: create_schema.sql'
PROMPT '>> =============================================================='
PROMPT '>> Connexion en tant que SYSTEM pour la creation du schema'
PROMPT '>> =============================================================='

CONNECT system

PROMPT ' '
PROMPT '>> =========================================='
PROMPT '>> Creation du Schema/Utilisateur DMI_APP'
PROMPT '>> =========================================='
-- Décommenter la ligne suivante si besoin de relancer le script après une erreur
-- DROP USER DMI_APP CASCADE;

PROMPT '>> Creation de l utilisateur DMI_APP'
-- !! Choisissez un mot de passe approprie et notez-le !!
CREATE USER DMI_APP IDENTIFIED BY DMI_APP_PWD2025;

PROMPT '>> Attribution des privileges a DMI_APP'
GRANT CONNECT TO DMI_APP;          
-- Autorisation de connexion
GRANT CREATE SESSION TO DMI_APP;
GRANT CREATE TABLE TO DMI_APP;     
-- Autorisation de creer des tables (et implicitement des index dessus)
GRANT CREATE VIEW TO DMI_APP;      
-- Autorisation de creer des vues
GRANT CREATE SYNONYM TO DMI_APP;   
-- Autorisation de creer des synonymes
GRANT CREATE SEQUENCE TO DMI_APP;  
-- Autorisation de creer des sequences (pour les PK auto-increment)
-- REMARQUE: Le privilege 'CREATE ANY INDEX' a ete supprime car trop permissif.

PROMPT ' '
PROMPT '>> =========================================='
PROMPT '>> Creation du schema DMI_APP terminee.'
PROMPT '>> =========================================='
PROMPT ' '

Disconnect;

SPOOL OFF

-- Fin du script create_schema.sql