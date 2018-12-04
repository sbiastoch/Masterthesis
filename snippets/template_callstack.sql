CREATE OR REPLACE FUNCTION <f>(<*params>) RETURNS <returntype> AS $$
    WITH RECURSIVE
      callstack (<*in_params>, call_site, <*new_params>) AS (
    
        WITH <init_predicate_ctes(<*params>, predicates)>
        <init_calls(<*params>, call_sites, recursive, predicates)>
    
        UNION
    
        SELECT
          d.<*new_params>,
          calls.call_site,
          calls.<*new_params>
        FROM
          callstack AS d, LATERAL (
            
            WITH <step_predicate_ctes(params, predicates)>
            <step_calls(<*params>, call_sites, recursive, predicates)>
    
          ) AS calls(call_site, <*new_params>)
    
      ), ...
      ...
$$LANGUAGE SQL;