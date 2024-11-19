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


--Onglets
SET tab=coalesce($tab,'1');
select 'tab' as component;
select  'Inscrits'  as title, 'users-group' as icon,   CASE WHEN $tab=1 THEN 1 ELSE 0 END  as active, 'repertoire.sql?tab=1' as link, CASE WHEN $tab=1 THEN 'lime' ELSE 'vk' END as color;
select  'Badges' as title, 'id-badge-2' as icon,   CASE WHEN $tab=2 THEN 1 ELSE 0 END  as active, 'repertoire.sql?tab=2' as link, CASE WHEN $tab=2 THEN 'lime' ELSE 'vk' END as color;

-- Inscrits
SELECT 'table' as component,
    TRUE                   as compact,
    TRUE as sort,
    TRUE as search,
    'Répertoire des intervenants' as title  WHERE $tab=1;
    
SELECT 
    inscription.id as N°,
    UPPER(nom) as Nom,
    entreprise as Identité,
    (SELECT pole from poles WHERE id=pole_id) as Pole,
    (SELECT horaire from creneaux WHERE id=creneau) as Créneau,
    courriel as Courriel,
    tel	as Tel,
    infos as infos,
    date_created as Enregistré_le
from intervenants LEFT JOIN inscription on inscription.id=intervenants.inscription_id WHERE $tab=1 ORDER BY nom;

-- Badges
SELECT 'card' as component,
    3 as columns WHERE $tab=2;
    
select 
    UPPER(nom)  as title,
    entreprise||CHAR(10)||CHAR(10)||metiers as description_md,
    'PÔLE '||(SELECT UPPER(pole) from poles WHERE id=pole_id) as footer
    from intervenants LEFT JOIN inscription on inscription.id=intervenants.inscription_id WHERE $tab=2 ORDER BY nom;
