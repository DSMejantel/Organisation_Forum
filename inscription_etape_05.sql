SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

SET step=coalesce($step,5);

select 'dynamic' as component, sqlpage.run_sql('step.sql') as properties;

INSERT INTO inscription(creneau,entreprise,pole_id,courriel,tel,nombre,metiers,infos)
	SELECT 
	CAST(:creneau as integer) as creneau,
	:entreprise as entreprise, 
	CAST(:pole as integer) as pole_id,
	:courriel as courriel, 
	:tel as tel,
	:nombre as nombre,
	:metiers as metiers,
	:infos as infos
	WHERE :entreprise IS NOT NULL;

SET reference= (SELECT last_insert_rowid() FROM inscription);

INSERT INTO intervenants(inscription_id,nom)
	SELECT 
	$reference as inscription_id,
	CAST(value AS TEXT) as nom from json_each(:_nom)
	WHERE :_nom IS NOT NULL;
	
INSERT INTO besoins(inscription_id,categorie_id)
	SELECT 
	$reference as inscription_id,
	CAST(value AS INTEGER) as categorie_id from json_each(:besoin)
	WHERE :besoin IS NOT NULL;
	
INSERT INTO creneau(inscription_id,creneau_id)
	SELECT 
	$reference as inscription_id,
	CAST(:creneau AS INTEGER) as creneau_id
	WHERE :creneau IS NOT NULL;
	
INSERT INTO reservation(inscription_id,repas_nombre)
	SELECT 
	$reference as inscription_id,
	CAST(:repas AS INTEGER) as repas_nombre
	WHERE :repas IS NOT NULL;
UPDATE repas SET resa=coalesce(resa,0)+CAST(:repas AS INTEGER) where :repas is not Null;
UPDATE repas SET reste=total-resa;

-- Dernière  étape:     

select 
    'alert'   as component,
    'Votre réponse a été prise en compte. ' as title,
    'Dans l''attente de vous retrouver sur ce forum, nous vous remercions pour votre engagement auprès de nos élèves. ' as description,
    'check'   as icon,
    'green'   as color;




 
    


