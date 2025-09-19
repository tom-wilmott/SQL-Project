-- Query showing details of the top 10 highest paid remote Data Analyst jobs

SELECT
    job_id AS ID,
    job_title AS Role,
    company_details.name AS Company,
    job_schedule_type AS Contract,
    salary_year_avg*0.74 AS Pay_GBP,
    job_posted_date AS Posted
FROM
    job_postings_fact   AS job_details
LEFT JOIN company_dim AS company_details
ON  job_details.company_id = company_details.company_id
WHERE
    (job_work_from_home = TRUE OR job_country = 'United Kingdom') AND
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC
LIMIT 10;