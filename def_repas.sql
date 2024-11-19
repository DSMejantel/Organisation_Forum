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
SELECT 'Nombre de repas proposés' as label, 'total' AS name, 'number' as type, 1 as step, 6 as width, TRUE as required;

SET archive=coalesce((SELECT total FROM repas), Null);

INSERT INTO repas(total) SELECT :total as total where $archive is Null and :total is not Null;
UPDATE repas SET total=:total where $archive is not Null and :total is not Null;
UPDATE repas SET reste=:total-(SELECT resa FROM repas) where $archive is not Null and :total is not Null;

SELECT 'list' as component,
    TRUE                   as compact,
    'Nombre de repas' as title;
SELECT 
    'Repas proposés : '||total as title,
    'Repas réservés : '||coalesce(resa,0)||CHAR(10)||CHAR(10)||
    'Repas disponibles : '||reste as description_md 
    from repas;
