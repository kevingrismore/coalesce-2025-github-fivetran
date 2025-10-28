
    
    

select
    pull_request_review_id as unique_field,
    count(*) as n_records

from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__pull_request_review
where pull_request_review_id is not null
group by pull_request_review_id
having count(*) > 1


