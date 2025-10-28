
    
    

select
    repository_id as unique_field,
    count(*) as n_records

from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__repository
where repository_id is not null
group by repository_id
having count(*) > 1


