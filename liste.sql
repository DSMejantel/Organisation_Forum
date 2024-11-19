SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
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
select  'Inscrits'  as title, 'users-group' as icon,  CASE WHEN $tab=1 THEN 1 ELSE 0 END  as active, 'liste.sql?tab=1' as link, CASE WHEN $tab=1 THEN 'lime' ELSE 'vk' END as color;
select  'Indisponibles' as title, 'user-cancel' as icon, CASE WHEN $tab=2 THEN 1 ELSE 0 END  as active, 'liste.sql?tab=2' as link, CASE WHEN $tab=2 THEN 'lime' ELSE 'vk' END as color;

-- Inscrits
SELECT 'table' as component,
    TRUE as hover,
    TRUE as small,
    TRUE as sort,
    TRUE as search,
    'ADMIN' as markdown,
    'Services disponibles' as title  WHERE $tab=1;
    
SELECT 
    inscription.id as N°,
    (SELECT horaire from creneaux WHERE id=creneau) as Créneau,
    nombre as Nbre,
    entreprise as Identité,
    (SELECT pole from poles WHERE id=pole_id) as Pôle,
    metiers as metiers,
    courriel as Courriel,
    tel	as Tel,
    group_concat(distinct categorie)  as Besoins,
    infos as infos,
    date_created as Enregistré_le,
    '[![](./icons/pencil.svg)
](liste_edit.sql?id='||inscription.id||' "Modifier")[![](./icons/user-plus.svg)
](liste_ajout_01.sql?id='||inscription.id||' "Ajouter")'as ADMIN
from inscription LEFT JOIN besoins on inscription.id=besoins.inscription_id LEFT join services on services.id=besoins.categorie_id WHERE $tab=1 and (SELECT horaire from creneaux WHERE id=creneau)<>0  GROUP BY inscription.id ;

-- Indisponibles
SELECT 'table' as component,
    TRUE                   as compact,
    'Services disponibles' as title WHERE $tab=2;
    
SELECT 
    inscription.id as N°,
    entreprise as Identité,
    date_created as enregistrement
from inscription WHERE $tab=2 and creneau=0  GROUP BY inscription.id;
