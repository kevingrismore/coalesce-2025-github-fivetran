
  
  create view "dev"."main_github_source"."stg_github__issue_closed_history_tmp__dbt_tmp" as (
    select *
from "FIVETRAN_DATABASE"."GITHUB"."issue_closed_history"
  );
