SELECT
    sd.skill_id,
    sd.skills AS skill,
    COUNT(*) AS demand,
    ROUND(AVG(jpf.salary_year_avg*0.74), 0) AS avg_pay_gbp
FROM 
    job_postings_fact jpf
JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst' AND 
    jpf.salary_year_avg IS NOT NULL AND 
    (jpf.job_work_from_home = TRUE OR jpf.job_country = 'United Kingdom')
GROUP BY 
    sd.skill_id, sd.skills
HAVING 
    COUNT(*) > 10
ORDER BY 
    avg_pay_gbp DESC, demand DESC
LIMIT 25;
