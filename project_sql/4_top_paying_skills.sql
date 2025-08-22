SELECT
    sd.skills AS Skill,
    ROUND(AVG(salary_year_avg),0) AS avg_pay
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim  AS sjd ON  jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON  sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst' AND
      salary_year_avg IS NOT NULL
GROUP BY Skill
ORDER BY avg_pay DESC
LIMIT 5;
-