SET group_id = coalesce((SELECT user_info.groupe FROM login_session join user_info on user_info.username=login_session.username WHERE id = sqlpage.cookie('session')),0); 
SELECT 'redirect' AS component,
        'index.sql?restriction=1' AS link
        WHERE $group_id<'3';

--Menu
SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('index.json')  AS properties where $group_id=1;

SELECT 'dynamic' AS component,
sqlpage.read_file_as_text('menu.json')  AS properties where $group_id>1;


-- 2nde étape:     
SELECT 
    'form' as component,
    'Mettre à jour' as validate,
    'green' as validate_color,
    'liste_ajout_03.sql' as action;
    
    SELECT 'hidden' as type, 'N_id' as name, :N_id as value;
    SELECT 'Entreprise ou organisme' AS label, 'building-factory-2' as prefix_icon, 'entreprise' AS name, 6 as width, TRUE as readonly, (SELECT entreprise FROM inscription WHERE id=:N_id)as value;  

-- Activation de la case REPAS
SET extra=(SELECT special FROM creneaux JOIN creneau on creneaux.id=creneau.creneau_id WHERE creneau.inscription_id=:N_id);   
 
    SELECT 'Nombre de repas' AS label, 'users' as prefix_icon, 'repas' AS name, CASE WHEN $extra=1 THEN 'number' ELSE 'hidden' END as type, CASE WHEN (SELECT reste from repas)<1 THEN TRUE END AS readonly, (SELECT coalesce(repas_nombre,0) FROM reservation WHERE inscription_id=:N_id) as value, 1 as step, 0 as min, 
       CASE WHEN :nombre<coalesce(reste,total) THEN :nombre ELSE coalesce(reste,total) END as max, 3 as width, TRUE as required, coalesce(reste,total) ||' disponible(s), Déjà réservé(s): '||(SELECT coalesce(repas_nombre,0) FROM reservation WHERE inscription_id=:N_id) as description FROM repas;

--Nouveaux inscrits    
with recursive inscrits as (
    select (SELECT nombre FROM inscription WHERE id=:N_id)+1 as id union all
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
where id>(SELECT nombre FROM inscription WHERE id=:N_id) and :nombre is not null



   
with previous_answers(name, value) as (values ('nombre', :nombre))
select 'hidden' as type, name, value from previous_answers;

 


 
    


