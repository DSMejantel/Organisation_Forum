select 
    'steps'  as component,
    TRUE     as counter,
    'orange' as color;
select 
    'Inscription' as title,
    'clock'             as icon,
    	CASE WHEN $step=1 THEN TRUE END as active;
select 
    'Contact professionnel'       as title,
    'building-factory-2'                     as icon,
    	CASE WHEN $step=2 THEN TRUE END as active;
select 
    'Besoins techniques' as title,
    'tools'              as icon,
        CASE WHEN $step=3 THEN TRUE END as active;
select 
    'Intervenants' as title,
    'users'            as icon,
        CASE WHEN $step=4 THEN TRUE END as active;
select 
    'Confirmation' as title,
    'check'            as icon,
        CASE WHEN $step=5 THEN TRUE END as active;
