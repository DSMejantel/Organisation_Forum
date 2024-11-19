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
SET tab=coalesce($tab,'2');
select 'tab' as component;
select  'Besoins' as title, 'tools' as icon,  CASE WHEN $tab=2 THEN 1 ELSE 0 END  as active, 'besoins.sql?tab=2' as link, CASE WHEN $tab=2 THEN 'lime' ELSE 'vk' END as color;
select  'Fiches'  as title, 'id-badge' as icon, CASE WHEN $tab=1 THEN 1 ELSE 0 END as active, 'besoins.sql?tab=1' as link, CASE WHEN $tab=1 THEN 'lime' ELSE 'vk' END as color;

select  'Liste' as title, 'list-check' as icon,  CASE WHEN $tab=3 THEN 1 ELSE 0 END  as active, 'besoins.sql?tab=3' as link, CASE WHEN $tab=3 THEN 'lime' ELSE 'vk' END as color;

select 
    'divider' as component,
    'Gestion des Besoins en matériel'   as contents;

-- Fiches
select 
    'columns' as component WHERE $tab=1;
select 
    (SELECT pole from poles WHERE poles.id=pole_id)    as title,
    'tools' as icon,
    (SELECT group_concat(nom, CHAR(10) || CHAR(10))
     FROM (
         SELECT DISTINCT nom
         FROM intervenants 
         WHERE intervenants.inscription_id = inscription.id
         ORDER BY nom
     )) as description_md,
    json_group_array(json_object('icon','tools','color','red','description',categorie)) as item,
    entreprise  as button_text
    from inscription LEFT JOIN besoins on inscription.id=besoins.inscription_id LEFT JOIN services on services.id=besoins.categorie_id WHERE $tab=1 AND (SELECT horaire from creneaux WHERE id=creneau)<>0 GROUP BY inscription.id;

select 
    'divider' as component WHERE $tab=1;

-- Besoins  
select 
    'big_number'          as component,
    4 as columns WHERE $tab=2;
select 
    'Besoins' as title,
    coalesce((SELECT categorie from services WHERE id=$categorie),'-') as value,
    'blue'    as color,
    json_group_array(json_object(
    'label', categorie,
    'link', 'besoins.sql?tab=2&categorie='||id))  as dropdown_item
    FROM (SELECT categorie, id FROM services union all select ' - choisir' as label, '0' as link WHERE $tab=2  order by categorie);

SELECT 'table' as component,
    TRUE                   as compact,
    'Services disponibles' as title  WHERE $tab=2 and $categorie is not NULL;
    
SELECT 
    inscription.id as N°,
    entreprise as Identité,
    (SELECT pole from poles WHERE id=pole_id) as Pôle,
    categorie  as Besoins,
    infos as infos
from inscription LEFT JOIN besoins on inscription.id=besoins.inscription_id LEFT join services on services.id=besoins.categorie_id WHERE $tab=2 and besoins.categorie_id=$categorie AND (SELECT horaire from creneaux WHERE id=creneau)<>0  GROUP BY inscription.id ;

-- Liste
SELECT 'table' as component,
    TRUE                   as compact,
    TRUE as sort,
    TRUE as search,
    'Besoins' as markdown,
    'Services disponibles' as title  WHERE $tab=3;
    
SELECT 
    inscription.id as N°,
    (SELECT horaire from creneaux WHERE id=creneau) as creneau,
    entreprise as Identité,
    (SELECT pole from poles WHERE id=pole_id) as Pôle,
    group_concat(categorie||CHAR(10)||CHAR(10))  as Besoins,
    infos as infos
from inscription LEFT JOIN besoins on inscription.id=besoins.inscription_id LEFT join services on services.id=besoins.categorie_id WHERE $tab=3 and (SELECT horaire from creneaux WHERE id=creneau)<>0  GROUP BY inscription.id  ;


