SELECT 'redirect' AS component,
        'signin.sql?error' AS link
 WHERE NOT EXISTS (SELECT 1 FROM login_session WHERE id=sqlpage.cookie('session'));
SET group_id = (SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        '/index.sql?restriction' AS link
        WHERE $group_id<>'4';

--Menu
SELECT 'dynamic' AS component, sqlpage.read_file_as_text('menu.json') AS properties;

-- Message si droits insuffisants sur une page
SELECT 'alert' as component,
    'Importation terminée' as title,
    'Les identifiants CAS ont été importés.' 
    as description_md,
    TRUE as dismissible,
    'alert-circle' as icon,
    'green' as color
WHERE $CAS IS NOT NULL;

select 
    'button' as component,
    'sm'     as size,
    'pill'   as shape;
select 
    'Nouveau compte' as title,
    'comptes_ajout.sql' as link,
    'square-rounded-plus' as icon,
    'green' as outline;
select 
    'Permissions' as title,
    'permissions.sql' as link,
    'user-shield' as icon,
    'orange' as outline;
select 
    'RAZ activation' as title,
    'tool_raz_activation.sql' as link,
    'trash' as icon,
    'orange' as outline;


-- Liste   
SELECT 'table' as component,
        'Admin' as markdown,
    TRUE    as hover,
    TRUE    as striped_rows,
    TRUE    as small,
    1 as sort,
    1 as search;
SELECT 
  username as _sqlpage_id,
  nom AS Nom,
  prenom AS Prénom,
  username as Identifiant,
  (SELECT groupes FROM permissions WHERE permissions.groupes_id=user_info.groupe) as Permissions,
  activation as Code,
  connexion as Connexion,
      '[
    ![](/icons/pencil.svg)
](comptes_edit.sql?id='||username||')[
    ![](/icons/trash.svg)
](comptes_delete.sql?id='||username||')' as Admin
FROM user_info WHERE username<>'admin' ORDER BY nom ASC;   
