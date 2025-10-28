
    
    

select
    user_id as unique_field,
    count(*) as n_records

from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__user
where user_id is not null
group by user_id
having count(*) > 1


