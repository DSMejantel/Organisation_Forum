SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
SELECT 'redirect' AS component,
        'index.sql?restriction=1' AS link
        WHERE $group_id<'3';



-- 3ème étape : enregistrement    
UPDATE inscription
	SET nombre=:nombre
	WHERE id=:N_id;

SET resa0=(SELECT repas_nombre FROM reservation WHERE inscription_id=:N_id);
DELETE FROM reservation
	WHERE inscription_id=:N_id;	
INSERT INTO reservation(inscription_id,repas_nombre)
	SELECT 
	:N_id  as inscription_id,
	CAST(:repas AS INTEGER) as repas_nombre;
UPDATE repas SET resa=coalesce(resa,0)+CAST(:repas AS INTEGER)-$resa0;
UPDATE repas SET reste=total-resa;

INSERT INTO intervenants(inscription_id,nom)
	SELECT 
	:N_id as inscription_id,
	CAST(value AS TEXT) as nom from json_each(:_nom)
        WHERE :_nom IS NOT NULL
	

RETURNING
   'redirect' AS component,
   'liste.sql' as link; 


 
    


