SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        '/index.sql?restriction' AS link
        WHERE $group_id<>'4';

--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('menu.json') AS properties;


select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape;
select 
    'Comptes' as title,
    'comptes.sql' as link,
    'arrow-back-up' as icon,
    'green' as outline;


-- Liste   
SELECT 'table' as component,
        'Admin' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    1 as sort;
SELECT 
  groupes_id AS Niveau,
  groupes as Groupes,
      '[
    ![](/icons/pencil.svg)
](permissions_edit.sql?id='||groupes_id||')' as Admin
FROM permissions ORDER BY groupes_id ASC;   
