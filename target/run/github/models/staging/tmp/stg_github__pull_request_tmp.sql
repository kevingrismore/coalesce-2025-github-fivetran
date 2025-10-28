
  
  create view "dev"."main_github_source"."stg_github__pull_request_tmp__dbt_tmp" as (
    select *
from "FIVETRAN_DATABASE"."GITHUB"."pull_request"
  );
