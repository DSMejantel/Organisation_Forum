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



SELECT 
    'form' as component,
    'Mettre à jour' as validate,
    'green' as validate_color,
    'liste_edit_confirm.sql' as action;

    SELECT 'Entreprise ou organisme' AS label, 'building-factory-2' as prefix_icon, 'entreprise' AS name, 6 as width, TRUE as required, (SELECT entreprise FROM inscription WHERE id=$id)as value;  
    
    SELECT 'Créneau(x)' as label, 'creneau' AS name, 'select' as type, TRUE as dropdown, 6 as width, 'Certains créneaux peuvent donner accès à des services dans la suite du formulaire.' as description, (SELECT creneau_id FROM creneau WHERE inscription_id=$id) as value, json_group_array(json_object("label", horaire, "value", id)) as options FROM (SELECT horaire, id from creneaux union all select 'Indisponible' as label, 0 as value);
    
    SELECT 'pole' as name, 'select' AS type, 'Domaine professionnel' as label, 3 as width, TRUE as required, (SELECT pole_id FROM inscription WHERE id=$id) as value, json_group_array(json_object("label", pole, "value", id)) as options FROM (select * FROM poles ORDER BY pole ASC);
    
    SELECT 'Téléphone' AS label, 'phone' as prefix_icon, 'tel' AS name, CHAR(10), 3 as width, TRUE as required, (SELECT tel FROM inscription WHERE id=$id) as value;
    
    SELECT 'Courriel' AS label, 'mail' as prefix_icon, 'courriel' AS name, 3 as width, TRUE as required, (SELECT courriel FROM inscription WHERE id=$id) as value;
    
  SELECT 'Nombre d''intervenant(s)' AS label, 'users' as prefix_icon, 'nombre' AS name, 'number' as type, 0 as step, 4 as max, 3 as width,  (SELECT nombre FROM inscription WHERE id=$id) as value, TRUE as readonly;
    

    
    SELECT 'besoin[]' AS name, 'Besoins techniques' as label, 6 as width, 'select' as type, TRUE as multiple, TRUE as dropdown,
     'Les besoins connus sont déjà sélectionnés.' as description,
     json_group_array(json_object("label", categorie, 
     "value", id,
     'selected', categorie_id is not null
     )) as options  
     FROM services
     Left Join besoins on services.id=besoins.categorie_id 
     AND besoins.inscription_id=$id;
         
       SELECT 'Nombre de repas' AS label, 'users' as prefix_icon, 'repas' AS name, 'number' as type,
       3 as width, TRUE as required, 
       1 as step, 0 as min,
       CASE WHEN (SELECT nombre FROM inscription WHERE id=$id)<reste THEN (SELECT nombre FROM inscription WHERE id=$id) ELSE reste END as max,
       (SELECT coalesce(repas_nombre,0) FROM reservation WHERE inscription_id=$id) as value, 
       CASE WHEN (SELECT reste from repas)<1 THEN TRUE END AS readonly,
       coalesce(reste,total) ||' disponible(s), Déjà réservé(s): '||(SELECT coalesce(repas_nombre,0) FROM reservation WHERE inscription_id=$id) as description 
       FROM repas;

    SELECT 'Métiers présentés' AS label, 'message-user' as prefix_icon, 'metiers' AS name, 12 as width, TRUE as required, (SELECT metiers FROM inscription WHERE id=$id) as value;
    
    SELECT 'Message' AS label, 'message' as prefix_icon, 'infos' AS name, 12 as width, (SELECT infos FROM inscription WHERE id=$id) as value;

    SELECT 'hidden' as type, 'N_id' as name, $id as value;

