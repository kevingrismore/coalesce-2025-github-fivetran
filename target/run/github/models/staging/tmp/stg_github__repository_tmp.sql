
  
  create view "dev"."main_github_source"."stg_github__repository_tmp__dbt_tmp" as (
    select *
from "FIVETRAN_DATABASE"."GITHUB"."repository"
  );
