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
SELECT 'Pôle professionnel' as label, 'pole' AS name, 'text' as type, 6 as width, TRUE as required;

INSERT INTO poles(pole) SELECT :pole as pole where :pole is not Null;

SELECT 'list' as component,
    TRUE                   as compact,
    'Pôle professionnel' as title;
SELECT pole as title from poles;
