SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;



SET step=coalesce($step,4);

select 'dynamic' as component, sqlpage.run_sql('step.sql') as properties;

-- Activation de la case REPAS
SET extra=(SELECT special FROM creneaux WHERE :creneau=id);

-- 4ème étape:     
SELECT 
    'form' as component,
    'Suivant' as validate,
    'green' as validate_color,
    'inscription_etape_05.sql?step=5' as action;
    
with recursive inscrits as (
    select 0 as id union all
    select id + 1 as id
        from inscrits
    where id < CAST(:nombre AS INTEGER))
    SELECT 'text' as type,
    printf('%s_nom[]') as name,
    'user-question' as prefix_icon,
    true as required,
    printf('Intervenant n° %d ', id) as label,
    printf('Indiquez Nom et Prénom de cet intervenant') as placeholder
from inscrits
where id>0 and :nombre is not null 

    SELECT 'Nombre de repas' AS label, 'users' as prefix_icon, 'repas' AS name, CASE WHEN $extra=1 THEN 'number' ELSE 'hidden' END as type, CASE WHEN (SELECT reste from repas)<1 THEN TRUE END AS readonly, 0 as value, 1 as step, 0 as min, 
       CASE WHEN :nombre<coalesce(reste,total) THEN :nombre ELSE coalesce(reste,total) END as max, 3 as width, TRUE as required, coalesce(reste,total) ||' disponibles ' as description FROM repas;

    SELECT 'Métiers présentés' AS label, 'message-user' as prefix_icon, 'metiers' AS name, 12 as width, TRUE as required;
    SELECT 'Message' AS label, 'Indiquez-nous vos demandes ou remarques particulières.' as description, 'message' as prefix_icon, 'infos' AS name, 12 as width;
    
with previous_answers(name, value) as (values ('entreprise', :entreprise), ('creneau', :creneau), ('pole', :pole), ('courriel', :courriel), ('tel', :tel), ('nombre', :nombre), ('besoin', :besoin))
select 'hidden' as type, name, value from previous_answers;

 


 
    


