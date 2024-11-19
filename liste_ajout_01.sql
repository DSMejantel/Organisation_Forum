SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
SELECT 'redirect' AS component,
        'index.sql?restriction=1' AS link
        WHERE $group_id<'3';
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;


-- 1ère étape:    
SELECT 
    'form' as component,
    'Suivant' as validate,
    'green' as validate_color,
    'liste_ajout_02.sql' as action;

    SELECT 'Entreprise ou organisme' AS label, 'building-factory-2' as prefix_icon, 'entreprise' AS name, 6 as width, TRUE as readonly, (SELECT entreprise FROM inscription WHERE id=$id)as value;  
    
  SELECT 'Nombre d''intervenant(s)' AS label, 'users' as prefix_icon, 'nombre' AS name, 'number' as type, 0 as step, 4 as max, 3 as width,  (SELECT nombre FROM inscription WHERE id=$id) as value, (SELECT nombre FROM inscription WHERE id=$id) as min, TRUE as required;

    SELECT 'hidden' as type, 'N_id' as name, $id as value;

