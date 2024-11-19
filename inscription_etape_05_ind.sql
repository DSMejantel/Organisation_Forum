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

INSERT INTO inscription(creneau,entreprise)
	SELECT 
	CAST($creneau as integer) as creneau,
	$entreprise as entreprise WHERE $entreprise IS NOT NULL;


-- Dernière  étape:     

select 
    'alert'   as component,
    'Votre réponse a été prise en compte. ' as title,
    'Nous espérons pouvoir travailler ensemble lors d''un prochain événement.' as description,
    'check'   as icon,
    'green'   as color;

 


 
    


