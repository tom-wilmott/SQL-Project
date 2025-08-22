SELECT
    sd.skills AS Skill,
    COUNT(sjd.skill_id)
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim  AS sjd ON  jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON  sjd.skill_id = sd.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY Skill
ORDER BY COUNT DESC
LIMIT 5;
-