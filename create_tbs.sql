-- Fichier : create_tbs.sql
-- Objectif: Creation des tablespaces DATA_DMI et INDEX_DMI pour le projet DMI.

SPOOL create_tbs.txt

PROMPT '>> =============================================================='
PROMPT '>> Fichier: create_tbs.sql'
PROMPT '>> =============================================================='
PROMPT '>> Connexion en tant que DBA (SYSTEM)'
PROMPT '>> =============================================================='

connect system

PROMPT ' '
PROMPT '>> =========================================='
PROMPT '>> Gestion des Tablespaces DMI'
PROMPT '>> =========================================='
-- Décommenter les lignes suivantes si besoin de relancer le script après une erreur
-- DROP TABLESPACE DATA_DMI including contents and datafiles ;
-- DROP TABLESPACE INDEX_DMI including contents and datafiles ;

PROMPT '>> Creation du tablespace DATA_DMI avec plusieurs datafiles'
CREATE TABLESPACE DATA_DMI
    DATAFILE
        'C:/APPS/ORADATA/PISE/data_dmi_01.dbf' SIZE 256M, 
        'C:/APPS/ORADATA/PISE/data_dmi_02.dbf' SIZE 256M,
        'C:/APPS/ORADATA/PISE/data_dmi_03.dbf' SIZE 256M  
    SEGMENT SPACE MANAGEMENT AUTO ;

PROMPT '>> Creation du tablespace INDEX_DMI avec plusieurs datafiles'
CREATE TABLESPACE INDEX_DMI
    DATAFILE
        'C:/APPS/ORADATA/PISE/index_dmi_01.dbf' SIZE 128M, 
        'C:/APPS/ORADATA/PISE/index_dmi_02.dbf' SIZE 128M  
    SEGMENT SPACE MANAGEMENT AUTO ;

PROMPT ' '
PROMPT '>> =========================================='
PROMPT '>> Creation des tablespaces terminee.'
PROMPT '>> =========================================='
PROMPT ' '


PROMPT ' '
PROMPT '>> ========================================================'
PROMPT '>> Affectation des Tablespaces et Quotas a DMI_APP'
PROMPT '>> ========================================================'

PROMPT '>> Affectation du TBS DATA_DMI par defaut a DMI_APP'
ALTER USER DMI_APP DEFAULT TABLESPACE DATA_DMI;

PROMPT '>> Affectation des quotas illimites sur les TBS a DMI_APP'

ALTER USER DMI_APP QUOTA UNLIMITED ON DATA_DMI;
ALTER USER DMI_APP QUOTA UNLIMITED ON INDEX_DMI;

PROMPT '>> Configuration des tablespaces et quotas pour DMI_APP terminee.'
PROMPT ' '


Disconnect;

SPOOL OFF

