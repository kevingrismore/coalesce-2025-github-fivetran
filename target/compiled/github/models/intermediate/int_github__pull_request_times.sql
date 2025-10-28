with issue as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue
), 

issue_merged as (
    select
      issue_id,
      min(merged_at) as merged_at
      from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue_merged
    group by 1
)



select 
  issue.issue_id,
  issue_merged.merged_at
from issue 
left join issue_merged on issue_merged.issue_id = issue.issue_id
