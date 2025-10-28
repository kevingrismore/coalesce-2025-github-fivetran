with issue_comment as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue_comment
)

select
  issue_id,
  count(*) as number_of_comments
from issue_comment
group by issue_id