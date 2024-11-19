SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
SELECT 'redirect' AS component,
        'index.sql?restriction=1' AS link
        WHERE $group_id<'4';
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

-- Planification des créneaux  
SELECT 
    'form' as component,
    'enregistrer' as validate;
SELECT 'Créneau' as label, 'horaire' AS name, 'text' as type, 3 as width, TRUE as required;
SELECT 'Possibilité de repas' AS label, 'special' AS name, 'checkbox' as type, 1 as value, 3 as width;

INSERT INTO creneaux(horaire,special) SELECT :horaire as horaire, coalesce(:special,0) as special  where :horaire is not Null;

SELECT 'list' as component,
    TRUE                   as compact,
    'Créneaux existant' as title;
SELECT horaire as title,
    CASE WHEN special=1
    THEN 'possibilité de repas' END as description
    FROM creneaux;
