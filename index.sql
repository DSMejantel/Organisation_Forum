SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0);    

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

set id_ent = coalesce((select user_cas from login_session where id = sqlpage.cookie('session')),'inactif');

-- Message si droits insuffisants sur une page
SELECT 'alert' as component,
    'Attention !' as title,
    'Vous ne possédez pas les droits suffisants pour accéder à cette page.' 
    as description_md,
    'alert-circle' as icon,
    'red' as color
WHERE $restriction IS NOT NULL;

-- Message si pas de serveur CAS configuré
SELECT 'alert' as component,
    'Attention !' as title,
    'Le serveur CAS n''est pas configuré. Contactez l''administrateur.' 
    as description_md,
    'alert-circle' as icon,
    'orange' as color
WHERE $cas<>1;

 
              
SELECT 'hero' as component,
'Forum des Métiers  et des Formations' as title,
    'inscription_etape_01.sql' as link,
    'INSCRIPTION' as link_text,
    '23 janvier 2025'||CHAR(10)||CHAR(10)||'Halle Saint-Jean à MENDE' as description_md,
    '/images/visages.png' as image;



