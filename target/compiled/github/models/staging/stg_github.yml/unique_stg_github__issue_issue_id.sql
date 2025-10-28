
    
    

select
    issue_id as unique_field,
    count(*) as n_records

from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue
where issue_id is not null
group by issue_id
having count(*) > 1


