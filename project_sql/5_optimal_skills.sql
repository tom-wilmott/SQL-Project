WITH skill_demand AS
(  
    SELECT
    sd.skill_id,
    sd.skills AS Skill,
    COUNT(sjd.skill_id) AS demand
    FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim  AS sjd ON  jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON  sjd.skill_id = sd.skill_id
    WHERE job_title_short = 'Data Analyst'
          AND salary_year_avg IS NOT NULL
          AND job_work_from_home = TRUE
    GROUP BY sd.skill_id
),     skill_pay AS
(
    SELECT
    sd.skill_id,
    sd.skills AS Skill,
    ROUND(AVG(salary_year_avg),0) AS avg_pay
    FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim  AS sjd ON  jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON  sjd.skill_id = sd.skill_id
    WHERE job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY sd.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.Skill,
    demand,
    avg_pay
FROM skill_demand
LEFT JOIN  skill_pay ON skill_demand.skill_id = skill_pay.skill_id
WHERE demand > 10
ORDER BY
    avg_pay DESC,
    demand DESC
LIMIT 25;


-
/* Cleaner version

SELECT
    sd.skill_id,
    sd.skills AS skill,
    COUNT(*) AS demand,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_pay
FROM job_postings_fact jpf
JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
  AND jpf.salary_year_avg IS NOT NULL
  AND jpf.job_work_from_home = TRUE
GROUP BY sd.skill_id, sd.skills
HAVING COUNT(*) > 10
ORDER BY avg_pay DESC, demand DESC
LIMIT 25;
*/