-- ============================================================================
-- Fichier : insert_tables.sql
-- Objectif: Alimentation exhaustive et automatique des tables DMI
-- À exécuter après create_table.sql
-- ============================================================================

SPOOL insert_tables.txt

HOST chcp 65001 > nul
HOST set NLS_LANG=FRENCH_FRANCE.AL32UTF8

PROMPT '>> =============================================================='
PROMPT '>> Fichier: insert_tables_final_auto.sql'
PROMPT '>> =============================================================='
PROMPT '>> Connexion en tant que DMI_APP'
PROMPT '>> =============================================================='

CONNECT DMI_APP/DMI_APP_PWD2025

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SERVEROUTPUT ON
SET DEFINE OFF

PROMPT ' '
PROMPT '>> =============================================================='
PROMPT '>> INSERTION DES DONNEES DE TEST EXHAUSTIVES'
PROMPT '>> =============================================================='
PROMPT ' '

DECLARE
 ---------------------------------------------------------------------------
 -- DECLARATION DES VARIABLES
 ---------------------------------------------------------------------------
 -- === VARIABLES POUR REFERENTIELS ===
 v_typepro_med TYPE_PRO.id_type_pro%TYPE;
 v_typepro_inf TYPE_PRO.id_type_pro%TYPE;
 v_typepro_chir TYPE_PRO.id_type_pro%TYPE;
 v_typepro_anesth TYPE_PRO.id_type_pro%TYPE;
 v_typepro_radio TYPE_PRO.id_type_pro%TYPE;
 v_typepro_cardio TYPE_PRO.id_type_pro%TYPE;
 v_typepro_pediatre TYPE_PRO.id_type_pro%TYPE;

 v_spec_gen SPECIALITE.id_specialite%TYPE;
 v_spec_chir_visc SPECIALITE.id_specialite%TYPE;
 v_spec_anesth SPECIALITE.id_specialite%TYPE;
 v_spec_radio SPECIALITE.id_specialite%TYPE;
 v_spec_cardio SPECIALITE.id_specialite%TYPE;
 v_spec_pediatrie SPECIALITE.id_specialite%TYPE;
 v_spec_ortho SPECIALITE.id_specialite%TYPE;

 v_type_rep_parent TYPE_REPRESENTANT.id_type_representant%TYPE;
 v_type_rep_tuteur TYPE_REPRESENTANT.id_type_representant%TYPE;

 v_type_antec_perso TYPE_ANTECEDENT.id_type_antecedent%TYPE;
 v_type_antec_fam TYPE_ANTECEDENT.id_type_antecedent%TYPE;

 v_type_sens_allerg TYPE_SENSIBILITE.id_type_sensibilite%TYPE;
 v_type_sens_intol TYPE_SENSIBILITE.id_type_sensibilite%TYPE;

 v_type_acte_consult TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE;
 v_type_acte_append TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE;
 v_type_acte_radio_thx TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE;
 v_type_acte_transfu TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE;
 v_type_acte_fracture TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE;
 v_type_acte_ecg TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE;

 v_type_exam_nfs TYPE_EXAMEN.id_type_examen%TYPE;
 v_type_exam_scan_abd TYPE_EXAMEN.id_type_examen%TYPE;
 v_type_exam_irm_cer TYPE_EXAMEN.id_type_examen%TYPE;
 v_type_exam_echo_card TYPE_EXAMEN.id_type_examen%TYPE;

 v_med_id_para MEDICAMENT.id_medicament%TYPE;
 v_med_id_amox MEDICAMENT.id_medicament%TYPE;
 v_med_id_aspirine MEDICAMENT.id_medicament%TYPE;
 v_med_id_insuline MEDICAMENT.id_medicament%TYPE;
 v_med_id_beta MEDICAMENT.id_medicament%TYPE;

 v_patho_id_app PATHOLOGIE.id_pathologie%TYPE;
 v_patho_id_hta PATHOLOGIE.id_pathologie%TYPE;
 v_patho_id_fracture PATHOLOGIE.id_pathologie%TYPE;
 v_patho_id_ic PATHOLOGIE.id_pathologie%TYPE;
 v_patho_id_grippe PATHOLOGIE.id_pathologie%TYPE;

 v_typesortie_dom TYPE_SORTIE.id_type_sortie%TYPE;
 v_typesortie_trans TYPE_SORTIE.id_type_sortie%TYPE;
 v_typesortie_deces TYPE_SORTIE.id_type_sortie%TYPE;

 v_tp_id_cpam TIERS_PAYEUR.id_tiers_payeur%TYPE;
 v_tp_id_mutgen TIERS_PAYEUR.id_tiers_payeur%TYPE;
 v_tp_id_axa TIERS_PAYEUR.id_tiers_payeur%TYPE;

 v_ald_id_dt1 ALD.id_ald%TYPE;
 v_ald_id_cardio ALD.id_ald%TYPE;

 v_facteur_id_tabac FACTEUR_RISQUE.id_facteur%TYPE;
 v_facteur_id_sedent FACTEUR_RISQUE.id_facteur%TYPE;
 v_facteur_id_alcool FACTEUR_RISQUE.id_facteur%TYPE;
 v_facteur_id_obesite FACTEUR_RISQUE.id_facteur%TYPE;

 v_prodsang_cgr PRODUIT_SANGUIN.id_produit_sanguin%TYPE;
 v_prodsang_plaq PRODUIT_SANGUIN.id_produit_sanguin%TYPE;

 v_type_anesth_gen TYPE_ANESTHESIE.id_type_anesthesie%TYPE;
 v_type_anesth_loco TYPE_ANESTHESIE.id_type_anesthesie%TYPE;

 -- === VARIABLES POUR ETABLISSEMENTS ET SERVICES ===
 v_etab_id_rd ETABLISSEMENT.id_etablissement%TYPE;
 v_etab_id_pompidou ETABLISSEMENT.id_etablissement%TYPE;
 v_etab_id_larib ETABLISSEMENT.id_etablissement%TYPE;

 v_serv_id_chir_rd SERVICE.id_service%TYPE;
 v_serv_id_med_rd SERVICE.id_service%TYPE;
 v_serv_id_radio_rd SERVICE.id_service%TYPE;
 v_serv_id_ped_rd SERVICE.id_service%TYPE;
 v_serv_id_cardio_hgp SERVICE.id_service%TYPE;
 v_serv_id_ortho_larib SERVICE.id_service%TYPE;

 -- === VARIABLES POUR PROFESSIONNELS ===
 v_pro_id_leroy PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_martin PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_duval PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_simon PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_petit PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_moreau PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_dubois PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_garcia PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_bernard PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_lefevre PROFESSIONNEL.id_professionnel%TYPE;
 v_pro_id_robert PROFESSIONNEL.id_professionnel%TYPE;

 -- === VARIABLES POUR PATIENTS ===
 v_addr_id_p1 ADRESSE.id_adresse%TYPE; v_patient_id_p1 PATIENT.id_patient%TYPE;
 v_addr_id_p2 ADRESSE.id_adresse%TYPE; v_patient_id_p2 PATIENT.id_patient%TYPE;
 v_addr_id_p3 ADRESSE.id_adresse%TYPE; v_patient_id_p3 PATIENT.id_patient%TYPE;
 v_addr_id_p4 ADRESSE.id_adresse%TYPE; v_patient_id_p4 PATIENT.id_patient%TYPE;
 v_addr_id_p5 ADRESSE.id_adresse%TYPE; v_patient_id_p5 PATIENT.id_patient%TYPE;
 v_addr_id_rep_p5 ADRESSE.id_adresse%TYPE; v_rep_id_p5 REPRESENTANT_LEGAL.id_representant%TYPE;

 -- === VARIABLES POUR HOSPITALISATIONS ===
 v_hosp_id_p1_old HOSPITALISATION.id_hospitalisation%TYPE;
 v_hosp_id_p1_curr HOSPITALISATION.id_hospitalisation%TYPE;
 v_hosp_id_p2_bilan HOSPITALISATION.id_hospitalisation%TYPE;
 v_hosp_id_p4_cardio HOSPITALISATION.id_hospitalisation%TYPE;
 v_hosp_id_p5_fracture HOSPITALISATION.id_hospitalisation%TYPE;

 -- === VARIABLES POUR ACTES, EXAMENS, PRESCRIPTIONS ===
 v_acte_id_p1_append ACTE_REALISE.id_acte%TYPE;
 v_anesth_id_p1_append ANESTHESIE.id_anesthesie%TYPE;
 v_consent_id_p1_append CONSENTEMENT.id_consentement%TYPE;
 v_exam_id_p1_scan EXAMEN.id_examen%TYPE;
 v_cr_exam_id_p1_scan COMPTE_RENDU_EXAMEN.id_compte_rendu%TYPE;
 v_presc_id_p1_hosp_old PRESCRIPTION.id_prescription%TYPE;
 v_transfu_id_p1 TRANSFUSION.id_transfusion%TYPE;
 v_note_id_p1 NOTE_SOIN_INF.id_note_soin%TYPE;
 v_reco_id_p1 RECOMMANDATION.id_recommandation%TYPE;
 v_exam_id_p4_echo EXAMEN.id_examen%TYPE;
 v_acte_id_p5_fracture ACTE_REALISE.id_acte%TYPE;
 v_presc_id_p1_cholecyst PRESCRIPTION.id_prescription%TYPE;


  v_hosp_id_p1_cholecyst  HOSPITALISATION.id_hospitalisation%TYPE;
  v_acte_id_p1_cholecyst  ACTE_REALISE.id_acte%TYPE;
  v_type_acte_cholecyst TYPE_ACTE_REFERENTIEL.id_type_acte%TYPE; 
  v_patho_id_calculs    PATHOLOGIE.id_pathologie%TYPE; 
  v_anesth_id_p1_chole  ANESTHESIE.id_anesthesie%TYPE; 
  v_consent_id_p1_chole CONSENTEMENT.id_consentement%TYPE;

 ---------------------------------------------------------------------------
BEGIN
 DBMS_OUTPUT.PUT_LINE('>> Début insertion Référentiels Communs...');

 ---------------------------------------------------------------------------
 -- TYPE_PRO
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_PRO (libelle) VALUES ('Médecin Généraliste') RETURNING id_type_pro INTO v_typepro_med;
 INSERT INTO TYPE_PRO (libelle) VALUES ('Infirmier') RETURNING id_type_pro INTO v_typepro_inf;
 INSERT INTO TYPE_PRO (libelle) VALUES ('Chirurgien') RETURNING id_type_pro INTO v_typepro_chir;
 INSERT INTO TYPE_PRO (libelle) VALUES ('Anesthesiste-Reanimateur') RETURNING id_type_pro INTO v_typepro_anesth;
 INSERT INTO TYPE_PRO (libelle) VALUES ('Radiologue') RETURNING id_type_pro INTO v_typepro_radio;
 INSERT INTO TYPE_PRO (libelle) VALUES ('Cardiologue') RETURNING id_type_pro INTO v_typepro_cardio;
 INSERT INTO TYPE_PRO (libelle) VALUES ('Pédiatre') RETURNING id_type_pro INTO v_typepro_pediatre;

 ---------------------------------------------------------------------------
 -- SPECIALITE
 ---------------------------------------------------------------------------
 INSERT INTO SPECIALITE (libelle) VALUES ('Médecine Générale') RETURNING id_specialite INTO v_spec_gen;
 INSERT INTO SPECIALITE (libelle) VALUES ('Chirurgie Viscérale') RETURNING id_specialite INTO v_spec_chir_visc;
 INSERT INTO SPECIALITE (libelle) VALUES ('Anesthesie-Réanimation') RETURNING id_specialite INTO v_spec_anesth;
 INSERT INTO SPECIALITE (libelle) VALUES ('Radiodiagnostic et Imagerie Medicale') RETURNING id_specialite INTO v_spec_radio;
 INSERT INTO SPECIALITE (libelle) VALUES ('Cardiologie et maladies vasculaires') RETURNING id_specialite INTO v_spec_cardio;
 INSERT INTO SPECIALITE (libelle) VALUES ('Pediatrie') RETURNING id_specialite INTO v_spec_pediatrie;
 INSERT INTO SPECIALITE (libelle) VALUES ('Chirurgie orthopedique et traumatologie') RETURNING id_specialite INTO v_spec_ortho;

 ---------------------------------------------------------------------------
 -- TYPE_REPRESENTANT
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_REPRESENTANT (libelle) VALUES ('Parent (Autorité Parentale)') RETURNING id_type_representant INTO v_type_rep_parent;
 INSERT INTO TYPE_REPRESENTANT (libelle) VALUES ('Tuteur Légal') RETURNING id_type_representant INTO v_type_rep_tuteur;
 INSERT INTO TYPE_REPRESENTANT (libelle) VALUES ('Curateur');
 INSERT INTO TYPE_REPRESENTANT (libelle) VALUES ('Personne de confiance');

 ---------------------------------------------------------------------------
 -- TYPE_ANTECEDENT
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_ANTECEDENT (libelle) VALUES ('Personnel') RETURNING id_type_antecedent INTO v_type_antec_perso;
 INSERT INTO TYPE_ANTECEDENT (libelle) VALUES ('Familial') RETURNING id_type_antecedent INTO v_type_antec_fam;

 ---------------------------------------------------------------------------
 -- TYPE_SENSIBILITE
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_SENSIBILITE (libelle) VALUES ('Allergie') RETURNING id_type_sensibilite INTO v_type_sens_allerg;
 INSERT INTO TYPE_SENSIBILITE (libelle) VALUES ('Intolerance') RETURNING id_type_sensibilite INTO v_type_sens_intol;

 ---------------------------------------------------------------------------
 -- TYPE_ACTE_REFERENTIEL
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Consultation générale', 0) RETURNING id_type_acte INTO v_type_acte_consult;
 INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Appendicectomie', 1) RETURNING id_type_acte INTO v_type_acte_append;
 INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Radiographie Thorax Face', 0) RETURNING id_type_acte INTO v_type_acte_radio_thx;
 INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Transfusion CGR', 0) RETURNING id_type_acte INTO v_type_acte_transfu;
 INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Réduction et immobilisation fracture poignet', 1) RETURNING id_type_acte INTO v_type_acte_fracture;
 INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Electrocardiogramme (ECG)', 0) RETURNING id_type_acte INTO v_type_acte_ecg;
INSERT INTO TYPE_ACTE_REFERENTIEL (libelle, est_chirurgical) VALUES ('Cholécystectomie par coelioscopie', 1) RETURNING id_type_acte INTO v_type_acte_cholecyst;
 ---------------------------------------------------------------------------
 -- TYPE_EXAMEN
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_EXAMEN (libelle) VALUES ('Bilan sanguin NFS Plaquettes') RETURNING id_type_examen INTO v_type_exam_nfs;
 INSERT INTO TYPE_EXAMEN (libelle) VALUES ('Scanner Abdomino-Pelvien') RETURNING id_type_examen INTO v_type_exam_scan_abd;
 INSERT INTO TYPE_EXAMEN (libelle) VALUES ('IRM Cérébrale') RETURNING id_type_examen INTO v_type_exam_irm_cer;
 INSERT INTO TYPE_EXAMEN (libelle) VALUES ('Echocardiographie Doppler') RETURNING id_type_examen INTO v_type_exam_echo_card;

 ---------------------------------------------------------------------------
 -- MEDICAMENT
 ---------------------------------------------------------------------------
 INSERT INTO MEDICAMENT (nom, dosage_unitaire, forme) VALUES ('Paracétamol', '1g', 'Comprimé') RETURNING id_medicament INTO v_med_id_para;
 INSERT INTO MEDICAMENT (nom, dosage_unitaire, forme) VALUES ('Amoxicilline', '500mg', 'Gélule') RETURNING id_medicament INTO v_med_id_amox;
 INSERT INTO MEDICAMENT (nom, dosage_unitaire, forme) VALUES ('Aspirine', '100mg', 'Comprimé') RETURNING id_medicament INTO v_med_id_aspirine;
 INSERT INTO MEDICAMENT (nom, dosage_unitaire, forme) VALUES ('Insuline Lantus', '100 UI/mL', 'Stylo Injecteur') RETURNING id_medicament INTO v_med_id_insuline;
 INSERT INTO MEDICAMENT (nom, dosage_unitaire, forme) VALUES ('Bisoprolol', '5mg', 'Comprimé') RETURNING id_medicament INTO v_med_id_beta;

 ---------------------------------------------------------------------------
 -- PATHOLOGIE
 ---------------------------------------------------------------------------
 INSERT INTO PATHOLOGIE (code, libelle) VALUES ('K35.8', 'Appendicite aiguë, autre et sans précision') RETURNING id_pathologie INTO v_patho_id_app;
 INSERT INTO PATHOLOGIE (code, libelle) VALUES ('I10', 'Hypertension artérielle essentielle') RETURNING id_pathologie INTO v_patho_id_hta;
 INSERT INTO PATHOLOGIE (code, libelle) VALUES ('S62.6', 'Fracture de la première phalange du pouce') RETURNING id_pathologie INTO v_patho_id_fracture;
 INSERT INTO PATHOLOGIE (code, libelle) VALUES ('I50.0', 'Insuffisance cardiaque congestive') RETURNING id_pathologie INTO v_patho_id_ic;
 INSERT INTO PATHOLOGIE (code, libelle) VALUES ('J11.1', 'Grippe avec autres manifestations respiratoires') RETURNING id_pathologie INTO v_patho_id_grippe;
INSERT INTO PATHOLOGIE (code, libelle) VALUES ('K80.2', 'Calcul de la vésicule biliaire sans cholécystite') RETURNING id_pathologie INTO v_patho_id_calculs;
 ---------------------------------------------------------------------------
 -- TYPE_SORTIE
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_SORTIE (libelle) VALUES ('Domicile') RETURNING id_type_sortie INTO v_typesortie_dom;
 INSERT INTO TYPE_SORTIE (libelle) VALUES ('Transfert autre hôpital') RETURNING id_type_sortie INTO v_typesortie_trans;
 INSERT INTO TYPE_SORTIE (libelle) VALUES ('Décès') RETURNING id_type_sortie INTO v_typesortie_deces;
 INSERT INTO TYPE_SORTIE (libelle) VALUES ('Transfert EHPAD');
 INSERT INTO TYPE_SORTIE (libelle) VALUES ('Autre');

 ---------------------------------------------------------------------------
 -- TIERS_PAYEUR
 ---------------------------------------------------------------------------
 INSERT INTO TIERS_PAYEUR (type, nom, code) VALUES ('AMO', 'CPAM Paris', '75001') RETURNING id_tiers_payeur INTO v_tp_id_cpam;
 INSERT INTO TIERS_PAYEUR (type, nom, code) VALUES ('Mutuelle', 'Mutuelle Générale', 'MUTGEN01') RETURNING id_tiers_payeur INTO v_tp_id_mutgen;
 INSERT INTO TIERS_PAYEUR (type, nom, code) VALUES ('Mutuelle', 'AXA Complémentaire', 'AXA075') RETURNING id_tiers_payeur INTO v_tp_id_axa;

 ---------------------------------------------------------------------------
 -- ALD
 ---------------------------------------------------------------------------
 INSERT INTO ALD (libelle) VALUES ('Diabète de type 1 et type 2') RETURNING id_ald INTO v_ald_id_dt1;
 INSERT INTO ALD (libelle) VALUES ('Insuffisance cardiaque grave') RETURNING id_ald INTO v_ald_id_cardio;
 INSERT INTO ALD (libelle) VALUES ('Maladie coronarienne grave');

 ---------------------------------------------------------------------------
 -- FACTEUR_RISQUE
 ---------------------------------------------------------------------------
 INSERT INTO FACTEUR_RISQUE (libelle) VALUES ('Tabagisme Actif') RETURNING id_facteur INTO v_facteur_id_tabac;
 INSERT INTO FACTEUR_RISQUE (libelle) VALUES ('Sédentarité') RETURNING id_facteur INTO v_facteur_id_sedent;
 INSERT INTO FACTEUR_RISQUE (libelle) VALUES ('Consommation excessive Alcool') RETURNING id_facteur INTO v_facteur_id_alcool;
 INSERT INTO FACTEUR_RISQUE (libelle) VALUES ('Obésité (IMC > 30)') RETURNING id_facteur INTO v_facteur_id_obesite;
 INSERT INTO FACTEUR_RISQUE (libelle) VALUES ('Dyslipidémie');

 ---------------------------------------------------------------------------
 -- PRODUIT_SANGUIN
 ---------------------------------------------------------------------------
 INSERT INTO PRODUIT_SANGUIN (libelle) VALUES ('Concentré de Globules Rouges (CGR) Phénotypé') RETURNING id_produit_sanguin INTO v_prodsang_cgr;
 INSERT INTO PRODUIT_SANGUIN (libelle) VALUES ('Concentré Plaquettaire Standard (CPS)') RETURNING id_produit_sanguin INTO v_prodsang_plaq;
 INSERT INTO PRODUIT_SANGUIN (libelle) VALUES ('Plasma Frais Congelé (PFC)');

 ---------------------------------------------------------------------------
 -- TYPE_ANESTHESIE
 ---------------------------------------------------------------------------
 INSERT INTO TYPE_ANESTHESIE (libelle) VALUES ('Anesthésie Générale') RETURNING id_type_anesthesie INTO v_type_anesth_gen;
 INSERT INTO TYPE_ANESTHESIE (libelle) VALUES ('Anesthésie Locorégionale') RETURNING id_type_anesthesie INTO v_type_anesth_loco;
 INSERT INTO TYPE_ANESTHESIE (libelle) VALUES ('Anesthésie Locale');
 INSERT INTO TYPE_ANESTHESIE (libelle) VALUES ('Sédation');

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Référentiels Communs.');
 ---------------------------------------------------------------------------
 -- ADRESSES PATIENTS
 ---------------------------------------------------------------------------
 DBMS_OUTPUT.PUT_LINE('>> Insertion Adresses Patients & Représentants...');
 INSERT INTO ADRESSE (rue, code_postal, ville) VALUES ('10 Rue de Rivoli', '75004', 'Paris') RETURNING id_adresse INTO v_addr_id_p1;
 INSERT INTO ADRESSE (rue, code_postal, ville) VALUES ('5 Avenue des Champs Elysées', '75008', 'Paris') RETURNING id_adresse INTO v_addr_id_p2;
 INSERT INTO ADRESSE (rue, code_postal, ville) VALUES ('22 Boulevard Haussmann', '75009', 'Paris') RETURNING id_adresse INTO v_addr_id_p3;
 INSERT INTO ADRESSE (rue, code_postal, ville) VALUES ('1 Place de la Concorde', '75008', 'Paris') RETURNING id_adresse INTO v_addr_id_p4;
 INSERT INTO ADRESSE (rue, code_postal, ville) VALUES ('15 Rue du Faubourg Saint-Honoré', '75008', 'Paris') RETURNING id_adresse INTO v_addr_id_p5;
 INSERT INTO ADRESSE (rue, code_postal, ville) VALUES ('15 Rue du Faubourg Saint-Honoré', '75008', 'Paris') RETURNING id_adresse INTO v_addr_id_rep_p5;
 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Adresses.');

 /* ======================================================================
   ETABLISSEMENTS + ADRESSES ETAB
   ====================================================================== */
DBMS_OUTPUT.PUT_LINE('>> Insertion Etablissements & Adresses...');

INSERT INTO ETABLISSEMENT (nom)
VALUES ('Hopital Robert DEBRE')
RETURNING id_etablissement INTO v_etab_id_rd;

INSERT INTO ADRESSE_ETAB (rue, code_postal, ville, id_etablissement)
VALUES ('48 Boulevard Serurier', '75019', 'Paris', v_etab_id_rd);

INSERT INTO ETABLISSEMENT (nom)
VALUES ('Hopital Europeen Georges-Pompidou')
RETURNING id_etablissement INTO v_etab_id_pompidou;

INSERT INTO ADRESSE_ETAB (rue, code_postal, ville, id_etablissement)
VALUES ('20 Rue Leblanc', '75015', 'Paris', v_etab_id_pompidou);

INSERT INTO ETABLISSEMENT (nom)
VALUES ('Hopital Lariboisiere')
RETURNING id_etablissement INTO v_etab_id_larib;

INSERT INTO ADRESSE_ETAB (rue, code_postal, ville, id_etablissement)
VALUES ('2 Rue Ambroise Pare', '75010', 'Paris', v_etab_id_larib);

/* ======================================================================
   PROFESSIONNELS 
   ====================================================================== */
DBMS_OUTPUT.PUT_LINE('>> Insertion Professionnels...');

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('LEROY',  'Bernard',  '10000000001', v_typepro_med, NULL)
RETURNING id_professionnel INTO v_pro_id_leroy;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('MARTIN', 'Claire',   '10000000002', v_typepro_med, NULL)
RETURNING id_professionnel INTO v_pro_id_martin;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('MOREAU', 'Isabelle', '10000000005', v_typepro_med, NULL)
RETURNING id_professionnel INTO v_pro_id_moreau;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('DUVAL',  'Stephane', '10000000003', v_typepro_chir, NULL)
RETURNING id_professionnel INTO v_pro_id_duval;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('SIMON',  'Nathalie', '10000000004', v_typepro_anesth, NULL)
RETURNING id_professionnel INTO v_pro_id_simon;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('DUBOIS', 'Pierre',   '10000000006', v_typepro_radio, NULL)
RETURNING id_professionnel INTO v_pro_id_dubois;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('GARCIA', 'Maria',    '10000000007', v_typepro_cardio, NULL)
RETURNING id_professionnel INTO v_pro_id_garcia;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('BERNARD','Luc',      '10000000008', v_typepro_chir, NULL)
RETURNING id_professionnel INTO v_pro_id_bernard;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('LEFEVRE','Sophie',   '10000000009', v_typepro_pediatre, NULL)
RETURNING id_professionnel INTO v_pro_id_lefevre;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('PETIT',  'Lucas',    '20000000001', v_typepro_inf, NULL)
RETURNING id_professionnel INTO v_pro_id_petit;

INSERT INTO PROFESSIONNEL (nom, prenom, numero_rpps, id_type_pro, id_service)
VALUES ('ROBERT', 'Juliette', '20000000002', v_typepro_inf, NULL)
RETURNING id_professionnel INTO v_pro_id_robert;

/* ======================================================================
   SERVICES (id_responsable renseigné dès l’INSERT)
   ====================================================================== */
DBMS_OUTPUT.PUT_LINE('>> Insertion Services...');

INSERT INTO SERVICE (libelle, id_etablissement, id_responsable)
VALUES ('Chirurgie Viscerale et Digestive',
        v_etab_id_rd,
        v_pro_id_duval)
RETURNING id_service INTO v_serv_id_chir_rd;

INSERT INTO SERVICE (libelle, id_etablissement, id_responsable)
VALUES ('Medecine Interne',
        v_etab_id_rd,
        v_pro_id_martin)
RETURNING id_service INTO v_serv_id_med_rd;

INSERT INTO SERVICE (libelle, id_etablissement, id_responsable)
VALUES ('Imagerie Medicale',
        v_etab_id_rd,
        v_pro_id_dubois)
RETURNING id_service INTO v_serv_id_radio_rd;

INSERT INTO SERVICE (libelle, id_etablissement, id_responsable)
VALUES ('Pediatrie Generale',
        v_etab_id_rd,
        v_pro_id_lefevre)
RETURNING id_service INTO v_serv_id_ped_rd;

INSERT INTO SERVICE (libelle, id_etablissement, id_responsable)
VALUES ('Cardiologie',
        v_etab_id_pompidou,
        v_pro_id_garcia)
RETURNING id_service INTO v_serv_id_cardio_hgp;

INSERT INTO SERVICE (libelle, id_etablissement, id_responsable)
VALUES ('Chirurgie Orthopedique et Traumatologique',
        v_etab_id_larib,
        v_pro_id_bernard)
RETURNING id_service INTO v_serv_id_ortho_larib;




UPDATE PROFESSIONNEL SET id_service = v_serv_id_med_rd WHERE id_professionnel = v_pro_id_martin;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_chir_rd WHERE id_professionnel = v_pro_id_duval;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_chir_rd WHERE id_professionnel = v_pro_id_petit;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_chir_rd WHERE id_professionnel = v_pro_id_simon;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_radio_rd WHERE id_professionnel = v_pro_id_dubois;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_cardio_hgp WHERE id_professionnel = v_pro_id_garcia;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_ortho_larib WHERE id_professionnel = v_pro_id_bernard;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_ped_rd WHERE id_professionnel = v_pro_id_lefevre;
UPDATE PROFESSIONNEL SET id_service = v_serv_id_med_rd WHERE id_professionnel = v_pro_id_robert;


DBMS_OUTPUT.PUT_LINE('>> Fin insertion Etablissements, Professionnels & Services.');


 -- Spécialités
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_leroy, v_spec_gen);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_martin, v_spec_gen);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_moreau, v_spec_gen);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_duval, v_spec_chir_visc);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_simon, v_spec_anesth);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_dubois, v_spec_radio);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_garcia, v_spec_cardio);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_bernard, v_spec_ortho);
 INSERT INTO PROFESSIONNEL_SPECIALITE (id_professionnel, id_specialite) VALUES (v_pro_id_lefevre, v_spec_pediatrie);

 -- Responsables de service
 UPDATE SERVICE SET id_responsable = v_pro_id_duval WHERE id_service = v_serv_id_chir_rd;
 UPDATE SERVICE SET id_responsable = v_pro_id_martin WHERE id_service = v_serv_id_med_rd;
 UPDATE SERVICE SET id_responsable = v_pro_id_dubois WHERE id_service = v_serv_id_radio_rd;
 UPDATE SERVICE SET id_responsable = v_pro_id_garcia WHERE id_service = v_serv_id_cardio_hgp;
 UPDATE SERVICE SET id_responsable = v_pro_id_bernard WHERE id_service = v_serv_id_ortho_larib;
 UPDATE SERVICE SET id_responsable = v_pro_id_lefevre WHERE id_service = v_serv_id_ped_rd;

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Professionnels & Services.');

 ---------------------------------------------------------------------------
 -- PATIENT 1 : Philippe DURANT
 ---------------------------------------------------------------------------
 INSERT INTO PATIENT (numero_ss, nom, prenom, date_naissance, ville_naissance, sexe,
 telephone, email, profession, groupe_sanguin,
 id_medecin_traitant, id_adresse)
 VALUES ('1750375123456', 'DURANT', 'Philippe',
 TO_DATE('1975-03-20','YYYY-MM-DD'), 'Lyon', 'M',
 '0102030405', 'p.durant@email.com', 'Comptable', 'O+',
 v_pro_id_leroy, v_addr_id_p1)
 RETURNING id_patient INTO v_patient_id_p1;

 -- Mesure corporelle
 INSERT INTO MESURE_CORPORALE
 (date_mesure, poids, taille, ta_systolique, ta_diastolique, glycemie, id_patient)
 VALUES (TO_DATE('2025-01-15','YYYY-MM-DD'), 86.2, 178, 138, 88, 1.05, v_patient_id_p1);

 -- Antécédents
 INSERT INTO ANTECEDENT (description, date_debut, id_patient, id_type_antecedent)
 VALUES ('Cholécystectomie (ablation vésicule biliaire)',
 TO_DATE('2010-06-01','YYYY-MM-DD'), v_patient_id_p1, v_type_antec_perso);
 INSERT INTO ANTECEDENT (description, id_patient, id_type_antecedent)
 VALUES ('Père décédé d''un infarctus du myocarde à 60 ans',
 v_patient_id_p1, v_type_antec_fam);

 -- Vaccinations
 INSERT INTO VACCINATION (nom_vaccin, date_injection, id_patient)
 VALUES ('COVID-19 Pfizer Dose 3', TO_DATE('2023-12-01','YYYY-MM-DD'), v_patient_id_p1);
 INSERT INTO VACCINATION (nom_vaccin, date_injection, id_patient)
 VALUES ('Grippe saisonnière', TO_DATE('2024-10-15','YYYY-MM-DD'), v_patient_id_p1);

 -- Allergies / intolérances
 INSERT INTO SENSIBILITE (substance, description, date_signalement,
 id_patient, id_type_sensibilite)
 VALUES ('Pollen de bouleau', 'Rhinite allergique saisonnière modérée',
 TO_DATE('2005-04-01','YYYY-MM-DD'), v_patient_id_p1, v_type_sens_allerg);
 INSERT INTO SENSIBILITE (substance, description, date_signalement,
 id_patient, id_type_sensibilite)
 VALUES ('Lactose', 'Ballonnements et inconfort digestif',
 TO_DATE('2020-01-01','YYYY-MM-DD'), v_patient_id_p1, v_type_sens_intol);

 -- Couverture sociale
 INSERT INTO PATIENT_TIERS_PAYEUR
 (id_tiers_payeur, id_patient, num_contrat, niveau_couverture, date_fin_validite)
 VALUES (v_tp_id_cpam, v_patient_id_p1, NULL, 'Non Applicable', NULL);
 INSERT INTO PATIENT_TIERS_PAYEUR
 (id_tiers_payeur, id_patient, num_contrat, niveau_couverture, date_fin_validite)
 VALUES (v_tp_id_mutgen, v_patient_id_p1, 'MG123456', 'Renforcée',
 TO_DATE('2025-12-31','YYYY-MM-DD'));

 -- Diagnostics + facteurs de risque
 INSERT INTO DIAGNOSTIC_PATHOLOGIE
 (id_pathologie, id_patient, statut, date_diagnostic)
 VALUES (v_patho_id_hta, v_patient_id_p1, 'Actif',
 TO_DATE('2018-09-20','YYYY-MM-DD'));
 INSERT INTO PATIENT_FACTEUR_RISQUE
 (id_patient, id_facteur, date_debut, intensite)
 VALUES (v_patient_id_p1, v_facteur_id_tabac,
 TO_DATE('2000-01-01','YYYY-MM-DD'), 'Modéré');



 ---------------------------------------------------------------------------
  --  HOSPITALISATION 2010 pour P1 
  ---------------------------------------------------------------------------
  INSERT INTO HOSPITALISATION
        (num_dossier, date_debut, date_fin, motif,
         lettre_admission_contenu, conclusion_evaluation_initiale,
         compte_rendu_sortie, destination_sortie, fiche_liaison_infirmiere,
         id_patient, id_service, id_type_sortie)
  VALUES ('HOSP-PD-2010-007', -- Numéro de dossier plus ancien
          TO_DATE('2010-06-01 09:00:00','YYYY-MM-DD HH24:MI:SS'), -- Date antérieure
          TO_DATE('2010-06-03 16:00:00','YYYY-MM-DD HH24:MI:SS'),
          'Lithiase vésiculaire symptomatique - Cholécystectomie programmée',
          'Patient adressé par Dr Leroy pour douleurs biliaires récurrentes. Echographie confirmant lithiases.',
          'Bon état général, bilan pré-opératoire normal.',
          'Sortie autorisée J2. Suites opératoires simples. Régime pauvre en graisses conseillé pour 1 mois.',
          'Domicile',
          'Pansements propres. Surveillance habituelle.',
          v_patient_id_p1, v_serv_id_chir_rd, v_typesortie_dom)
  RETURNING id_hospitalisation INTO v_hosp_id_p1_cholecyst;

  INSERT INTO PRESCRIPTION
      (date_prescription, id_patient, id_prescripteur, id_hospitalisation)
VALUES (TO_DATE('2010-05-25 10:00:00','YYYY-MM-DD HH24:MI:SS'), 
        v_patient_id_p1,
        v_pro_id_duval, 
        v_hosp_id_p1_cholecyst) 
RETURNING id_prescription INTO v_presc_id_p1_cholecyst;

INSERT INTO LIGNE_PRESCRIPTION_ACTE
      (nombre, id_prescription, id_type_acte)
VALUES (1, v_presc_id_p1_cholecyst, v_type_acte_cholecyst); 

  
  INSERT INTO ACTE_REALISE
        (date_debut, date_fin, commentaires,
         id_patient, id_type_acte, id_professionnel_realisateur, id_hospitalisation)
  VALUES (TO_DATE('2010-06-01 14:00:00','YYYY-MM-DD HH24:MI:SS'),
          TO_DATE('2010-06-01 15:30:00','YYYY-MM-DD HH24:MI:SS'),
          'Cholécystectomie par coelioscopie. Extraction vésicule sans incident. Contrôle hémostase OK.',
          v_patient_id_p1, v_type_acte_cholecyst, v_pro_id_duval, v_hosp_id_p1_cholecyst)
  RETURNING id_acte INTO v_acte_id_p1_cholecyst;

  INSERT INTO COMPTE_RENDU_OPERATOIRE
        (date_redaction, contenu, id_acte)
  VALUES (TO_DATE('2010-06-01 16:00:00','YYYY-MM-DD HH24:MI:SS'),
          'Intervention réalisée sous AG, 4 trocarts. Dissection du triangle de Calot. Section et ligature artère et canal cystique. Cholangiographie per-opératoire non réalisée. Extraction vésicule. Pas de drain.',
          v_acte_id_p1_cholecyst);

  INSERT INTO ANESTHESIE
        (date_heure_debut, date_heure_fin, commentaires_per_op, conclusion_post_op,
         id_anesthesiste, id_acte_realise, id_type_anesthesie)
  VALUES (TO_DATE('2010-06-01 13:45:00','YYYY-MM-DD HH24:MI:SS'),
          TO_DATE('2010-06-01 15:45:00','YYYY-MM-DD HH24:MI:SS'),
          'Protocole anesthésique standard. Bonne tolérance.',
          'Réveil simple. Patient transféré en SSPI puis en chambre.',
          v_pro_id_simon, v_acte_id_p1_cholecyst, v_type_anesth_gen)
  RETURNING id_anesthesie INTO v_anesth_id_p1_chole;

  INSERT INTO CONSENTEMENT (date_signature, id_patient, id_acte_realise)
  VALUES (TO_DATE('2010-05-20','YYYY-MM-DD'), -- Consentement signé bien avant
          v_patient_id_p1, v_acte_id_p1_cholecyst)
  RETURNING id_consentement INTO v_consent_id_p1_chole;

 ---------------------------------------------------------------------------
 -- Hospitalisation 2023 (Appendicectomie)
 ---------------------------------------------------------------------------
 INSERT INTO HOSPITALISATION
 (num_dossier, date_debut, date_fin, motif,
 lettre_admission_contenu, conclusion_evaluation_initiale,
 compte_rendu_sortie, destination_sortie, fiche_liaison_infirmiere,
 id_patient, id_service, id_type_sortie)
 VALUES ('HOSP-PD-2023-001',
 TO_DATE('2023-05-10 08:00:00','YYYY-MM-DD HH24:MI:SS'),
 TO_DATE('2023-05-12 14:00:00','YYYY-MM-DD HH24:MI:SS'),
 'Appendicite aiguë non compliquée',
 'Adressé par Dr Leroy pour douleurs FID intenses et fièvre…',
 'Syndrome inflammatoire biologique et clinique évocateur…',
 'Sortie autorisée J2 post-opératoire. Suites simples…',
 'Domicile',
 'Surveillance cicatrice x3. Ablation fils J10. Repos.',
 v_patient_id_p1, v_serv_id_chir_rd, v_typesortie_dom)
 RETURNING id_hospitalisation INTO v_hosp_id_p1_old;

 -- Acte + compte rendu opératoire
 INSERT INTO ACTE_REALISE
 (date_debut, date_fin, commentaires,
 id_patient, id_type_acte, id_professionnel_realisateur, id_hospitalisation)
 VALUES (TO_DATE('2023-05-10 10:00:00','YYYY-MM-DD HH24:MI:SS'),
 TO_DATE('2023-05-10 11:30:00','YYYY-MM-DD HH24:MI:SS'),
 'Appendicectomie par coelioscopie : appendice inflammatoire, non perforé…',
 v_patient_id_p1, v_type_acte_append, v_pro_id_duval, v_hosp_id_p1_old)
 RETURNING id_acte INTO v_acte_id_p1_append;

 INSERT INTO COMPTE_RENDU_OPERATOIRE
 (date_redaction, contenu, id_acte)
 VALUES (TO_DATE('2023-05-10 12:00:00','YYYY-MM-DD HH24:MI:SS'),
 'Temps opératoire : 1h30. Pertes sanguines minimes. Pas d''incident.',
 v_acte_id_p1_append);

 -- Anesthésie
 INSERT INTO ANESTHESIE
 (date_heure_debut, date_heure_fin, commentaires_per_op, conclusion_post_op,
 id_anesthesiste, id_acte_realise, id_type_anesthesie)
 VALUES (TO_DATE('2023-05-10 09:45:00','YYYY-MM-DD HH24:MI:SS'),
 TO_DATE('2023-05-10 11:45:00','YYYY-MM-DD HH24:MI:SS'),
 'Induction sans difficulté. Stabilité hémodynamique.',
 'Extubation en SSPI. EVA 2/10.',
 v_pro_id_simon, v_acte_id_p1_append, v_type_anesth_gen)
 RETURNING id_anesthesie INTO v_anesth_id_p1_append;

 -- Consentement
 INSERT INTO CONSENTEMENT (date_signature, id_patient, id_acte_realise)
 VALUES (TO_DATE('2023-05-09','YYYY-MM-DD'),
 v_patient_id_p1, v_acte_id_p1_append)
 RETURNING id_consentement INTO v_consent_id_p1_append;

 -- Transfusion
 INSERT INTO TRANSFUSION
 (groupe_sanguin_produit, date_transfusion,
 id_hospitalisation, id_produit_sanguin, id_patient)
 VALUES ('O+', TO_DATE('2023-05-11','YYYY-MM-DD'),
 v_hosp_id_p1_old, v_prodsang_cgr, v_patient_id_p1)
 RETURNING id_transfusion INTO v_transfu_id_p1;

 -- Prescription postop
 INSERT INTO PRESCRIPTION
 (date_prescription, id_patient, id_prescripteur, id_hospitalisation)
 VALUES (TO_DATE('2023-05-10','YYYY-MM-DD'),
 v_patient_id_p1, v_pro_id_martin, v_hosp_id_p1_old)
 RETURNING id_prescription INTO v_presc_id_p1_hosp_old;

 INSERT INTO LIGNE_PRESCRIPTION_MEDICAMENT
 (posologie, duree_traitement_jours, id_prescription, id_medicament)
 VALUES ('1g IV toutes les 6 h si EVA > 3', 2,
 v_presc_id_p1_hosp_old, v_med_id_para);
 INSERT INTO LIGNE_PRESCRIPTION_MEDICAMENT
 (posologie, duree_traitement_jours, id_prescription, id_medicament)
 VALUES ('500 mg × 3 / jour PO', 3,
 v_presc_id_p1_hosp_old, v_med_id_amox);

 ---------------------------------------------------------------------------
 -- Hospitalisation 2025 (épisode en cours)
 ---------------------------------------------------------------------------
 INSERT INTO HOSPITALISATION
 (num_dossier, date_debut, motif,
 id_patient, id_service)
 VALUES ('HOSP-PD-2025-005',
 TRUNC(SYSDATE) - 2,
 'Douleurs abdominales persistantes post-prandiales',
 v_patient_id_p1, v_serv_id_med_rd)
 RETURNING id_hospitalisation INTO v_hosp_id_p1_curr;

 -- Scanner AP + CR
 INSERT INTO EXAMEN
 (date_examen, date_resultats, id_patient,
 id_type_examen, id_professionnel_realisateur,
 id_professionnel_prescripteur, id_service, id_hospitalisation)
 VALUES (TRUNC(SYSDATE) - 1,
 TRUNC(SYSDATE) - 1 + 4/24,
 v_patient_id_p1, v_type_exam_scan_abd,
 v_pro_id_dubois, v_pro_id_martin,
 v_serv_id_radio_rd, v_hosp_id_p1_curr)
 RETURNING id_examen INTO v_exam_id_p1_scan;

 INSERT INTO COMPTE_RENDU_EXAMEN
 (contenu, date_redaction, date_signature, statut, type_document,
 id_examen, id_redacteur)
 VALUES ('Absence d''anomalie digestive significative. Status post-appendicectomie.',
 TRUNC(SYSDATE) - 1 + 5/24, SYSDATE - 1/24,
 'Validé', 'CR Scanner AP',
 v_exam_id_p1_scan, v_pro_id_dubois)
 RETURNING id_compte_rendu INTO v_cr_exam_id_p1_scan;

 -- Note IDE
 INSERT INTO NOTE_SOIN_INF
 (date_soin, description, id_patient, id_infirmier, id_hospitalisation)
 VALUES (TRUNC(SYSDATE) - 1 + 10/24,
 'Patient algique EVA 5/10 malgré Paracétamol. Transit ralenti.',
 v_patient_id_p1, v_pro_id_robert, v_hosp_id_p1_curr)
 RETURNING id_note_soin INTO v_note_id_p1;

 -- Recommandation de sortie 2023
 INSERT INTO RECOMMANDATION
 (date_envoi, contenu, id_patient,
 id_professionnel_emetteur, id_professionnel_destinataire)
 VALUES (TO_DATE('2023-05-15','YYYY-MM-DD'),
 'Suivi post-opératoire appendicectomie entre J7-J10. Merci.',
 v_patient_id_p1, v_pro_id_duval, v_pro_id_leroy)
 RETURNING id_recommandation INTO v_reco_id_p1;

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Patient 1.');

 ---------------------------------------------------------------------------
 -- PATIENT 2 : Alice AUTRE
 ---------------------------------------------------------------------------
 INSERT INTO PATIENT (numero_ss, nom, prenom, date_naissance, ville_naissance, sexe,
 telephone, email, profession, groupe_sanguin,
 id_medecin_traitant, id_adresse)
 VALUES ('2881175987654', 'AUTRE', 'Alice',
 TO_DATE('1988-11-05','YYYY-MM-DD'), 'Paris', 'F',
 '0607080910', 'a.autre@email.com', 'Architecte', 'A+',
 NULL, v_addr_id_p2)
 RETURNING id_patient INTO v_patient_id_p2;

 INSERT INTO ANTECEDENT (description, id_patient, id_type_antecedent)
 VALUES ('Asthme intermittent', v_patient_id_p2, v_type_antec_perso);

 INSERT INTO PATIENT_TIERS_PAYEUR
 (id_tiers_payeur, id_patient) VALUES (v_tp_id_cpam, v_patient_id_p2);
 INSERT INTO PATIENT_TIERS_PAYEUR
 (id_tiers_payeur, id_patient, num_contrat, niveau_couverture, date_fin_validite)
 VALUES (v_tp_id_axa, v_patient_id_p2, 'AXA9876', 'Intermédiaire',
 TO_DATE('2026-06-30','YYYY-MM-DD'));

 INSERT INTO OPPOSITION_ACCES
 (type_donnee, date_opposition, motif, id_patient)
 VALUES ('Données Gynécologiques', SYSDATE - 100,
 'Accès limité aux spécialistes', v_patient_id_p2);

 -- Hospitalisation bilan fatigue
 INSERT INTO HOSPITALISATION
 (num_dossier, date_debut, motif, id_patient, id_service)
 VALUES ('HOSP-AA-2025-001',
 TRUNC(SYSDATE) - 10,
 'Bilan de fatigue chronique',
 v_patient_id_p2, v_serv_id_med_rd)
 RETURNING id_hospitalisation INTO v_hosp_id_p2_bilan;
/* EXAMEN – bilan NFS d’Alice AUTRE réalisé par Dr Dubois */
INSERT INTO EXAMEN
      (date_examen,
       date_resultats,
       id_patient,
       id_type_examen,
       id_professionnel_realisateur,  
       id_professionnel_prescripteur,
       id_service,
       id_hospitalisation)
VALUES (TRUNC(SYSDATE) - 9,           
        TRUNC(SYSDATE) - 8,           
        v_patient_id_p2,
        v_type_exam_nfs,
        v_pro_id_dubois,               
        v_pro_id_martin,               
        v_serv_id_med_rd,
        v_hosp_id_p2_bilan);

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Patient 2.');

 ---------------------------------------------------------------------------
 -- PATIENT 3 : Benoit BAUTRE
 ---------------------------------------------------------------------------
 INSERT INTO PATIENT (numero_ss, nom, prenom, date_naissance, ville_naissance, sexe,
 telephone, email, profession, groupe_sanguin,
 id_medecin_traitant, id_adresse)
 VALUES ('1920175333444', 'BAUTRE', 'Benoit',
 TO_DATE('1992-01-12','YYYY-MM-DD'), 'Marseille', 'M',
 '0708091011', 'b.bautre@email.com', 'Enseignant', 'B-',
 v_pro_id_leroy, v_addr_id_p3)
 RETURNING id_patient INTO v_patient_id_p3;

 INSERT INTO DIAGNOSTIC_PATHOLOGIE
 (id_pathologie, id_patient, statut, date_diagnostic)
 VALUES (v_patho_id_grippe, v_patient_id_p3,
 'Résolu', TO_DATE('2024-01-10','YYYY-MM-DD'));

 INSERT INTO PATIENT_FACTEUR_RISQUE
 (id_patient, id_facteur, intensite)
 VALUES (v_patient_id_p3, v_facteur_id_sedent, 'Présent');

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Patient 3.');

 ---------------------------------------------------------------------------
 -- PATIENT 4 : Claire DURAND
 ---------------------------------------------------------------------------
 INSERT INTO PATIENT (numero_ss, nom, prenom, date_naissance, ville_naissance, sexe,
 telephone, email, profession, groupe_sanguin,
 id_medecin_traitant, id_adresse)
 VALUES ('2650875654321', 'DURAND', 'Claire',
 TO_DATE('1965-08-15','YYYY-MM-DD'), 'Lille', 'F',
 '0203040506', 'c.durand@email.com', 'Retraitée', 'AB+',
 v_pro_id_moreau, v_addr_id_p4)
 RETURNING id_patient INTO v_patient_id_p4;

 INSERT INTO PATIENT_ALD (id_ald, id_patient, date_diagnostic)
 VALUES (v_ald_id_cardio, v_patient_id_p4,
 TO_DATE('2022-03-15','YYYY-MM-DD'));

 INSERT INTO DIAGNOSTIC_PATHOLOGIE
 (id_pathologie, id_patient, statut, date_diagnostic)
 VALUES (v_patho_id_ic, v_patient_id_p4, 'Actif',
 TO_DATE('2022-03-15','YYYY-MM-DD'));
 INSERT INTO DIAGNOSTIC_PATHOLOGIE
 (id_pathologie, id_patient, statut, date_diagnostic)
 VALUES (v_patho_id_hta, v_patient_id_p4, 'Actif',
 TO_DATE('2019-01-01','YYYY-MM-DD'));

 INSERT INTO PATIENT_TIERS_PAYEUR
 (id_tiers_payeur, id_patient) VALUES (v_tp_id_cpam, v_patient_id_p4);

 -- Hospitalisation cardio 2024
 INSERT INTO HOSPITALISATION
 (num_dossier, date_debut, date_fin, motif,
 id_patient, id_service, id_type_sortie)
 VALUES ('HOSP-CD-2024-009',
 TO_DATE('2024-09-05','YYYY-MM-DD'),
 TO_DATE('2024-09-10','YYYY-MM-DD'),
 'Décompensation cardiaque modérée',
 v_patient_id_p4, v_serv_id_cardio_hgp, v_typesortie_dom)
 RETURNING id_hospitalisation INTO v_hosp_id_p4_cardio;

 -- ETT + CR
 INSERT INTO EXAMEN
 (date_examen, date_resultats, id_patient,
 id_type_examen, id_professionnel_realisateur,
 id_professionnel_prescripteur, id_service, id_hospitalisation)
 VALUES (TO_DATE('2024-09-06','YYYY-MM-DD'),
 TO_DATE('2024-09-06','YYYY-MM-DD'),
 v_patient_id_p4, v_type_exam_echo_card,
 v_pro_id_garcia, v_pro_id_garcia,
 v_serv_id_cardio_hgp, v_hosp_id_p4_cardio)
 RETURNING id_examen INTO v_exam_id_p4_echo;

 INSERT INTO COMPTE_RENDU_EXAMEN
 (contenu, date_redaction, statut, id_examen, id_redacteur)
 VALUES ('FEVG ≈ 40 %. Dilatation VG modérée. Pressions de remplissage ↑.',
 TO_DATE('2024-09-06','YYYY-MM-DD'),
 'Validé', v_exam_id_p4_echo, v_pro_id_garcia);

 -- Prescription Bisoprolol + ECG
 DECLARE v_presc_id_p4 NUMBER;
 BEGIN
 INSERT INTO PRESCRIPTION
 (date_prescription, id_patient, id_prescripteur, id_hospitalisation)
 VALUES (TO_DATE('2024-09-06','YYYY-MM-DD'),
 v_patient_id_p4, v_pro_id_garcia, v_hosp_id_p4_cardio)
 RETURNING id_prescription INTO v_presc_id_p4;

 INSERT INTO LIGNE_PRESCRIPTION_MEDICAMENT
 (posologie, id_prescription, id_medicament)
 VALUES ('5 mg 1×/jour', v_presc_id_p4, v_med_id_beta);

 INSERT INTO LIGNE_PRESCRIPTION_ACTE
 (nombre, id_prescription, id_type_acte)
 VALUES (1, v_presc_id_p4, v_type_acte_ecg);
 END;

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Patient 4.');

 ---------------------------------------------------------------------------
 -- PATIENT 5 : Leo PETIT
 ---------------------------------------------------------------------------
 INSERT INTO PATIENT (numero_ss, nom, prenom, date_naissance, ville_naissance, sexe,
 profession, groupe_sanguin,
 id_medecin_traitant, id_adresse)
 VALUES ('1180275111222', 'PETIT', 'Leo',
 TO_DATE('2018-02-28','YYYY-MM-DD'), 'Paris', 'M',
 NULL, 'O-', v_pro_id_lefevre, v_addr_id_p5)
 RETURNING id_patient INTO v_patient_id_p5;

 -- Représentant légal
 INSERT INTO REPRESENTANT_LEGAL
 (nom, prenom, telephone, date_debut_mandat,
 id_adresse, id_type_representant)
 VALUES ('PETIT', 'Marc', '0611223344',
 TO_DATE('2018-02-28','YYYY-MM-DD'),
 v_addr_id_rep_p5, v_type_rep_parent)
 RETURNING id_representant INTO v_rep_id_p5;

 INSERT INTO EST_REPRESENTE_PAR
 (id_patient, id_representant)
 VALUES (v_patient_id_p5, v_rep_id_p5);

 INSERT INTO SENSIBILITE
 (substance, description, date_signalement,
 id_patient, id_type_sensibilite)
 VALUES ('Protéines de lait de vache',
 'Urticaire et RGO petite enfance',
 TO_DATE('2018-06-01','YYYY-MM-DD'),
 v_patient_id_p5, v_type_sens_allerg);

 INSERT INTO PATIENT_TIERS_PAYEUR
 (id_tiers_payeur, id_patient)
 VALUES (v_tp_id_cpam, v_patient_id_p5);

 -- Fracture poignet 2024
 INSERT INTO HOSPITALISATION
 (num_dossier, date_debut, date_fin, motif,
 id_patient, id_service, id_type_sortie)
 VALUES ('HOSP-LP-2024-002',
 TO_DATE('2024-07-10 16:00:00','YYYY-MM-DD HH24:MI:SS'),
 TO_DATE('2024-07-10 20:00:00','YYYY-MM-DD HH24:MI:SS'),
 'Chute – suspicion fracture poignet droit',
 v_patient_id_p5, v_serv_id_ortho_larib, v_typesortie_dom)
 RETURNING id_hospitalisation INTO v_hosp_id_p5_fracture;

 INSERT INTO ACTE_REALISE
 (date_debut, date_fin, commentaires,
 id_patient, id_type_acte, id_professionnel_realisateur, id_hospitalisation)
 VALUES (TO_DATE('2024-07-10 18:00:00','YYYY-MM-DD HH24:MI:SS'),
 TO_DATE('2024-07-10 18:30:00','YYYY-MM-DD HH24:MI:SS'),
 'Réduction + plâtre antébrachial fracture radius distal droit.',
 v_patient_id_p5, v_type_acte_fracture,
 v_pro_id_bernard, v_hosp_id_p5_fracture)
 RETURNING id_acte INTO v_acte_id_p5_fracture;

 DBMS_OUTPUT.PUT_LINE('>> Fin insertion Patient 5.');

 COMMIT;

EXCEPTION
 WHEN OTHERS THEN
 ROLLBACK;
 DBMS_OUTPUT.PUT_LINE('>> ERREUR INSERTION: '||SQLCODE||' - '||SQLERRM);
 RAISE;
END;
/

SET DEFINE ON

PROMPT ' '
PROMPT '>> =============================================================='
PROMPT '>> FIN DU SCRIPT D INSERTION '
PROMPT '>> =============================================================='
PROMPT ' '

Disconnect;
SPOOL OFF

