SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
SELECT 'redirect' AS component,
        'index.sql?restriction=1' AS link
        WHERE $group_id<'3';

UPDATE inscription
	SET creneau=:creneau,
	entreprise=:entreprise, 
	pole_id=:pole,
	courriel=:courriel, 
	tel=:tel,
	metiers=:metiers,
	infos=:infos 
	WHERE id=:N_id;


DELETE FROM besoins
	WHERE inscription_id=:N_id;
INSERT INTO besoins(inscription_id,categorie_id)
	SELECT 
	:N_id as inscription_id,
	CAST(value AS INTEGER) as categorie_id from json_each(:besoin);

DELETE FROM creneau
	WHERE inscription_id=:N_id;	
INSERT INTO creneau(inscription_id,creneau_id)
	SELECT 
	:N_id  as inscription_id,
	CAST(:creneau AS INTEGER) as creneau_id;

SET resa0=(SELECT repas_nombre FROM reservation WHERE inscription_id=:N_id);
DELETE FROM reservation
	WHERE inscription_id=:N_id;	
INSERT INTO reservation(inscription_id,repas_nombre)
	SELECT 
	:N_id  as inscription_id,
	CAST(:repas AS INTEGER) as repas_nombre;
UPDATE repas SET resa=coalesce(resa,0)+CAST(:repas AS INTEGER)-$resa0;
UPDATE repas SET reste=total-resa	

RETURNING
   'redirect' AS component,
   'liste.sql' as link;


