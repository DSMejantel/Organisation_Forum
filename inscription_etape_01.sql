SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;

SET step=coalesce($step,1);

select 'dynamic' as component, sqlpage.run_sql('step.sql') as properties;

-- 1ère étape:     
SELECT 
    'form' as component,
    'Suivant' as validate,
    'green' as validate_color,
    'inscription_etape_02.sql?step=2' as action;

SELECT 'Entreprise ou organisme' AS label, 'building-factory-2' as prefix_icon, 'entreprise' AS name, 6 as width, TRUE as required;   
SELECT 'Créneau(x)' as label, 'creneau' AS name, 'select' as type, TRUE as dropdown, 6 as width, 'Certains créneaux peuvent donner accès à des services dans la suite du formulaire.' as description, json_group_array(json_object("label", horaire, "value", id)) as options FROM (SELECT horaire, id from creneaux union all select 'Indisponible' as label, 0 as value);


 


 
    


