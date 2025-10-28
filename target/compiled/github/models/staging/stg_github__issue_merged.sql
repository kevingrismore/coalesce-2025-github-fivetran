with issue_merged as (

    select *
    from FIVETRAN_DATABASE.GITHUB_github_source.stg_github__issue_merged_tmp

), macro as (
    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_github/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_github/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        
    
    
    _fivetran_synced
    
 as 
    
    _fivetran_synced
    
, 
    
    
    actor_id
    
 as 
    
    actor_id
    
, 
    
    
    commit_sha
    
 as 
    
    commit_sha
    
, 
    
    
    issue_id
    
 as 
    
    issue_id
    
, 
    
    
    merged_at
    
 as 
    
    merged_at
    




    from issue_merged

), fields as (

    select 
      issue_id,
      cast(merged_at as timestamp) as merged_at

    from macro
)

select *
from fields