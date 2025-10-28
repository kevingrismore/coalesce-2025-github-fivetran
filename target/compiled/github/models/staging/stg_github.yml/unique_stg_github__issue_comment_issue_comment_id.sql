
    
    

select
    issue_comment_id as unique_field,
    count(*) as n_records

from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue_comment
where issue_comment_id is not null
group by issue_comment_id
having count(*) > 1


