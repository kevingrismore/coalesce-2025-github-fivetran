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