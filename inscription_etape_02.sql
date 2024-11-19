

-- Redirection si indisponible
SELECT 'redirect' AS component,
        'inscription_etape_05_ind.sql?step=5&creneau='||:creneau||'&entreprise='||:entreprise AS link
 WHERE CAST(:creneau as integer)=0;

SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('connexion.json')  AS properties where $group_id=0;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;





SET step=coalesce($step,2);

select 'dynamic' as component, sqlpage.run_sql('step.sql') as properties;

-- 2nde étape:     
SELECT 
    'form' as component,
    'Suivant' as validate,
    'green' as validate_color,
    'inscription_etape_03.sql?step=3' as action;
    
    SELECT 'pole' as name, 'select' AS type, 'Domaine professionnel' as label, 3 as width, TRUE as required, json_group_array(json_object("label", pole, "value", id)) as options FROM (select * FROM poles ORDER BY pole ASC);
    SELECT 'Téléphone' AS label, 'phone' as prefix_icon, 'tel' AS name, CHAR(10), 3 as width, TRUE as required;
    SELECT 'Courriel' AS label, 'mail' as prefix_icon, 'courriel' AS name, 3 as width, TRUE as required;
    SELECT 'Nombre d''intervenant(s)' AS label, 'users' as prefix_icon, 'nombre' AS name, 'number' as type, 1 as step, 1 as min, 4 as max, 3 as width, TRUE as required;
    
with previous_answers(name, value) as (values ('entreprise', :entreprise), ('creneau', :creneau))
select 'hidden' as type, name, value from previous_answers;

 


 
    


