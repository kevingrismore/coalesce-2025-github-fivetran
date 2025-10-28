with  __dbt__cte__int_github__issue_open_length as (
with issue as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue
), 

issue_closed_history as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue_closed_history
), 

close_events_stacked as (
    select   
      issue_id,
      created_at as updated_at,
      false as is_closed
    from issue -- required because issue_closed_history table does not have a line item for when the issue was opened
    union all
    select
      issue_id,
      updated_at,
      is_closed
    from issue_closed_history
), 

close_events_with_timestamps as (
  select
    issue_id,
    updated_at as valid_starting,
    coalesce(lead(updated_at) over (partition by issue_id order by updated_at), convert_timezone('UTC', current_timestamp())) as valid_until,
    is_closed
  from close_events_stacked
)

select
  issue_id,
  sum(datediff(
        second,
        valid_starting,
        valid_until
        )) /60/60/24 as days_issue_open,
  count(*) - 1 as number_of_times_reopened
from close_events_with_timestamps
  where not is_closed
group by issue_id
),  __dbt__cte__int_github__issue_comments as (
with issue_comment as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue_comment
)

select
  issue_id,
  count(*) as number_of_comments
from issue_comment
group by issue_id
),  __dbt__cte__int_github__pull_request_times as (
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

),  __dbt__cte__int_github__pull_request_reviewers as (
with pull_request_review as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__pull_request_review
), 

github_user as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__user
),

actual_reviewers as (
  select
    pull_request_review.pull_request_id,
    
    listagg(distinct github_user.login_name, ', ')

 as reviewers,
    count(*) as number_of_reviews
from pull_request_review
left join github_user on pull_request_review.user_id = github_user.user_id
group by 1
),



joined as (
  select
    actual_reviewers.pull_request_id,
    actual_reviewers.reviewers,
    cast(null as TEXT) as requested_reviewers,
    actual_reviewers.number_of_reviews
  from actual_reviewers
  )

select *
from joined
),  __dbt__cte__int_github__issue_joined as (
with issue as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue
),repository_teams as (
    select 
    
      repository_id,
      full_name as repository
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__repository

    
),issue_open_length as (
    select *
    from __dbt__cte__int_github__issue_open_length
), 

issue_comments as (
    select *
    from __dbt__cte__int_github__issue_comments
), 

creator as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__user
), 

pull_request_times as (
    select *
    from __dbt__cte__int_github__pull_request_times
), 

pull_request_reviewers as (
    select *
    from __dbt__cte__int_github__pull_request_reviewers
), 

pull_request as (
    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__pull_request
)

select
  issue.*,
  case 
    when issue.is_pull_request then 'https://github.com/' || repository_teams.repository || '/pull/' || issue.issue_number
    else 'https://github.com/' || repository_teams.repository || '/issues/' || issue.issue_number
  end as url_link,
  issue_open_length.days_issue_open,
  issue_open_length.number_of_times_reopened,
  cast(null as TEXT) as labels,
  issue_comments.number_of_comments,
  repository_teams.repository,cast(null as TEXT) as assignees,
  creator.login_name as creator_login_name,
  creator.name as creator_name,
  creator.company as creator_company,

  pull_request_times.merged_at,
  pull_request_reviewers.reviewers, 
  
  pull_request_reviewers.requested_reviewers,
  pull_request_reviewers.number_of_reviews
  
from issue
join repository_teams
  on issue.repository_id = repository_teams.repository_id
left join issue_open_length
  on issue.issue_id = issue_open_length.issue_id
left join issue_comments 
  on issue.issue_id = issue_comments.issue_id
left join creator 
  on issue.user_id = creator.user_id
left join pull_request
  on issue.issue_id = pull_request.issue_id
left join pull_request_times
  on issue.issue_id = pull_request_times.issue_id
left join pull_request_reviewers
  on pull_request.pull_request_id = pull_request_reviewers.pull_request_id
), issue_joined as (
    select *
    from __dbt__cte__int_github__issue_joined  
)

select
  *
from issue_joined
where is_pull_request