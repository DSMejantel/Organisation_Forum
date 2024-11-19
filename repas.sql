SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); SELECT 'redirect' AS component,
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
select  'Liste'  as title, 'salad' as icon, CASE WHEN $tab=1 THEN 1 ELSE 0 END as active, 'repas.sql?tab=1' as link, CASE WHEN $tab=1 THEN 'lime' ELSE 'vk' END as color;
select  'Tickets' as title, 'receipt-euro' as icon,  CASE WHEN $tab=2 THEN 1 ELSE 0 END  as active, 'repas.sql?tab=2' as link, CASE WHEN $tab=2 THEN 'lime' ELSE 'vk' END as color;

select 
    'divider' as component,
    'Gestion des Repas'   as contents;


--Liste    
SELECT 'table' as component,
    TRUE                   as compact,
    'Repas' as title WHERE $tab=1;
    
SELECT 
    inscription.id as N°,
    entreprise as Identité,
    (SELECT pole from poles WHERE id=pole_id) as Pole,
    group_concat(distinct nom)  as Intervenants,
    repas_nombre as Nombre
FROM inscription LEFT JOIN reservation on inscription.id=reservation.inscription_id JOIN intervenants on inscription.id=intervenants.inscription_id WHERE repas_nombre>0 AND $tab=1 GROUP BY inscription.id;
SELECT 
    'Total' as N°,
    '' as Identité,
    '' as Pole,
    ''  as Intervenants,
    sum(repas_nombre) as Nombre
from reservation WHERE $tab=1;

--Tickets
select 
    'columns' as component WHERE $tab=2;
select 
    'TICKET REPAS'             as title,
    'salad' as icon,
    CASE WHEN repas_nombre=(SELECT count(nom) FROM intervenants WHERE intervenants.inscription_id=id) THEN 'green' ELSE 'red' END as icon_color,
    CASE WHEN repas_nombre=(SELECT count(nom) FROM intervenants WHERE intervenants.inscription_id=id) THEN 'green' ELSE 'red' END as value_color,
    repas_nombre                       as value,
    entreprise as description,
    json_group_array(
    json_object('icon','user','color','green','description',nom)) as item,
    (SELECT pole from poles WHERE id=pole_id)  as button_text,
    'repas'                      as small_text
    from inscription join reservation on inscription.id=reservation.inscription_id join intervenants on inscription.id=intervenants.inscription_id WHERE repas_nombre>0  AND $tab= 2 GROUP BY inscription.id;
