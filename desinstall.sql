-- ===================================================================
-- Script : desinstall.sql   (désinstallation complète du projet DMI)
-- Supprime :
--   1) le schéma DMI_APP et tous ses objets
--   2) les tablespaces DATA_DMI et INDEX_DMI avec leurs datafiles
-- ===================================================================

SPOOL desinstall.txt

WHENEVER SQLERROR EXIT SQL.SQLCODE

CONNECT system

PROMPT '>> Suppression du schéma DMI_APP'
DROP USER DMI_APP CASCADE;

PROMPT '>> Suppression des tablespaces et des fichiers .dbf'
DROP TABLESPACE DATA_DMI  INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE INDEX_DMI INCLUDING CONTENTS AND DATAFILES;

PROMPT '>> Désinstallation terminée.'
SPOOL OFF
EXIT
