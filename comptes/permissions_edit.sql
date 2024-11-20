SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        '/index.sql?restriction' AS link
        WHERE $group_id<>'4';

--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('menu.json') AS properties;


--Bouton retour sans valider
select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape;
select 
    'Retour aux permissions' as title,
    '/comptes/permissions.sql' as link,
    'arrow-back-up' as icon,
    'green' as outline;  
 

  
--- Formulaire de Mise à jour
SELECT 
    'form' as component,
    '' as validate,
    'permission' as id;
    
    
    SELECT 'Droits :' AS label, 'nom_groupe' AS name, 'text' as type, TRUE as required, (SELECT groupes FROM permissions WHERE groupes_id = $id) as value, 6 as width;


--Bouton du formulaire
select 
    'button' as component;
select 
    'permission' as form,
    'Modifier' as title,
    'permissions_edit_confirm.sql?id='||$id as link,
    'green' as color; 


   
 

