SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;



SET step=coalesce($step,3);

select 'dynamic' as component, sqlpage.run_sql('step.sql') as properties;

-- 3ème étape:     
SELECT 
    'form' as component,
    'Suivant' as validate,
    'green' as validate_color,
    'inscription_etape_04.sql?step=4' as action;
    
SELECT 'Besoins techniques' as label, 'besoin[]' AS name, 'select' as type, TRUE as multiple, TRUE as dropdown, TRUE as required, 6 as width, 'Vous pouvez sélectionner plusieurs références. Nous essaierons de satisfaire au mieux vos demandes. Les grilles d''exposition pourront être mu' as description, json_group_array(json_object("label", categorie, "value", id)) as options FROM (SELECT categorie, id from services union all select 'Aucun' as label, 0 as value);
    
with previous_answers(name, value) as (values ('entreprise', :entreprise), ('creneau', :creneau), ('pole', :pole), ('courriel', :courriel), ('tel', :tel), ('nombre', :nombre))
select 'hidden' as type, name, value from previous_answers;

 


 
    


