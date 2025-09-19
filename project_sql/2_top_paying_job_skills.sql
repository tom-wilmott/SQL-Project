
WITH best_paid_jobs AS (
    SELECT
        jp.job_id AS ID,
        jp.job_title AS Role,
        c.name AS Company,
        jp.salary_year_avg AS Pay_GBP
    FROM 
        job_postings_fact AS jp
    LEFT JOIN company_dim AS c ON jp.company_id = c.company_id
    WHERE
        (jp.job_work_from_home = TRUE OR jp.job_country = 'United Kingdom') AND
        jp.salary_year_avg IS NOT NULL AND
        jp.job_title_short = 'Data Analyst'
    ORDER BY 
        jp.salary_year_avg DESC
    LIMIT 10
)

SELECT 
    sd.skills AS Skill,
    COUNT(sd.skills) AS Frequency
FROM 
    best_paid_jobs AS best
INNER JOIN skills_job_dim AS sjd ON best.ID = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
GROUP BY
    Skill
ORDER BY 
    Frequency DESC;