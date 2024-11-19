SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
SELECT 'redirect' AS component,
        'index.sql?restriction=1' AS link
        WHERE $group_id<'1';
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
select  'Vue d''ensemble'  as title, 'id-badge' as icon, CASE WHEN $tab=1 THEN 1 ELSE 0 END as active, 'poles.sql?tab=1' as link, CASE WHEN $tab=1 THEN 'lime' ELSE 'vk' END as color;
select  'Recherche par pôle' as title, 'search' as icon,  CASE WHEN $tab=2 THEN 1 ELSE 0 END  as active, 'poles.sql?tab=2' as link, CASE WHEN $tab=2 THEN 'lime' ELSE 'vk' END as color;
select  'Liste des métiers' as title, 'list-check' as icon,  CASE WHEN $tab=3 THEN 1 ELSE 0 END  as active, 'poles.sql?tab=3' as link, CASE WHEN $tab=3 THEN 'lime' ELSE 'vk' END as color;

select 
    'divider' as component;

-- Tout
select 
    'columns' as component WHERE $tab=1;
select 
    (SELECT pole from poles WHERE poles.id=pole_id)    as button_text,
    entreprise as title,
    json_array(json_object('icon','user','color','green','description',(SELECT group_concat(nom, ', ')
     FROM (
         SELECT DISTINCT nom
         FROM intervenants 
         WHERE intervenants.inscription_id = inscription.id
         ORDER BY nom
     ))),json_object('icon','building-factory-2','color','orange','description',metiers)) as item
    FROM inscription JOIN intervenants on inscription.id=intervenants.inscription_id WHERE $tab=1 GROUP BY inscription.id;

select 
    'divider' as component WHERE $tab=1;

-- Recherche par Pole  
select 
    'big_number'          as component,
    4 as columns WHERE $tab=2;
select 
    'Pôle' as title,
    coalesce((SELECT pole from poles WHERE id=$categorie),'-') as value,
    'blue'    as color,
    json_group_array(json_object(
    'label', pole,
    'link', 'poles.sql?tab=2&categorie='||id))  as dropdown_item
    FROM (SELECT pole, id FROM poles union all select ' - choisir' as label, '0' as link WHERE $tab=2  order by pole);
    
select 
    'columns' as component
     WHERE $tab=2 and $categorie is not NULL;
select 
    'PÔLE '||(SELECT UPPER(pole) from poles WHERE poles.id=pole_id)    as button_text,
    entreprise as title,
    json_array(json_object('icon','user','color','green','description',(SELECT group_concat(nom, ', ')
     FROM (
         SELECT DISTINCT nom
         FROM intervenants 
         WHERE intervenants.inscription_id = inscription.id
         ORDER BY nom
     ))),json_object('icon','building-factory-2','color','orange','description',metiers)) as item
    FROM inscription JOIN intervenants on inscription.id=intervenants.inscription_id WHERE $tab=2 and pole_id=$categorie GROUP BY inscription.id;    


-- Liste
SELECT 'table' as component,
    TRUE                   as compact,
    TRUE as sort,
    TRUE as search,
    'Métiers présentés' as title  WHERE $tab=3;
    
SELECT 
    (SELECT pole from poles WHERE id=pole_id) as Pôle,
    entreprise as Identité,
    metiers as Métiers
from inscription  WHERE $tab=3 and (SELECT horaire from creneaux WHERE id=creneau)<>0  GROUP BY inscription.id ORDER BY pole_id ;


