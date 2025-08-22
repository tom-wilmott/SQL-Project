
WITH best_paid_jobs AS
(SELECT
    job_id AS ID,
    job_title AS Role,
    company_details.name AS Company,
    salary_year_avg AS Pay
FROM
    job_postings_fact   AS job_details
LEFT JOIN company_dim AS company_details
ON  job_details.company_id = company_details.company_id
WHERE
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
ORDER BY 
    salary_year_avg DESC
LIMIT 10)

SELECT 
    best.*,
    sd.skills AS Skill
FROM
    best_paid_jobs AS best
INNER JOIN skills_job_dim  AS sjd
ON  best.ID = sjd.job_id
INNER JOIN skills_dim AS sd
ON  sjd.skill_id = sd.skill_id
ORDER BY best.Pay DESC
LIMIT 10;
-