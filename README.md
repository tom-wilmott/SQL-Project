# Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](https://github.com/tom-wilmott/SQL-Project/tree/master/project_sql)

# Background
This project was developed to better understand the UK data analyst job market. Specifically, remote roles and those based in the UK, where I’m currently applying. The goal was to identify which skills are most in-demand and command the highest salaries, helping to target my efforts more strategically.

The data can be found [here](https://github.com/tom-wilmott/SQL-Project/tree/master/csv_files) and contains insights on job titles, salaries, locations, and essential skills from real world job postings.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I utilised several key tools:

- **SQL:** The foundation of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote and UK based jobs. This query highlights the high paying opportunities in the field.

```sql
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
```
Here's the breakdown of the top remote and UK based data analyst jobs:
- **Broad Salary Range:** Top 10 paying data analyst roles span from £136,160 to £481,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like Motional, Meta, and Pinterest are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Associate Director, reflecting varied roles and specialisations within data analytics.

![Top Paying Roles](https://github.com/tom-wilmott/SQL-Project/blob/master/Images/Q1%20Table.png)

*Bar graph visualising the salary for the top 10 salaries for remote and UK based data analysts; created in PowerBI from my SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying remote and UK based data analyst jobs:
- **SQL** is leading appearing in 8 out of 10 jobs.
- **Python** follows closely with 7 out of 10.
- **Tableau** is also highly sought after, with 6 out of 10.
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.


![Top Paying Skills](https://github.com/tom-wilmott/SQL-Project/blob/master/Images/Q2%20Table.png)

*Bar graph visualising the count of skills for the top 10 paying remote and UK based jobs for data analysts; created in PowerBI from my SQL query results*

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    sd.skills AS Skill,
    COUNT(sjd.skill_id)
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim  AS sjd ON  jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON  sjd.skill_id = sd.skill_id
WHERE 
    (job_work_from_home = TRUE OR job_country = 'United Kingdom') AND
    job_title_short = 'Data Analyst'
GROUP BY 
    Skill
ORDER BY 
    COUNT DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for remote and UK based data analysts:
- **SQL** and **Excel** remain fundamental, emphasising the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualisation Tools** like **Python**, **Power BI**, and **Tableau** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 11303        |
| Excel    | 8522         |
| Python   | 6207         |
| Power BI | 5214         |
| Tableau  | 5208         |

*Table of the demand for the top 5 skills in remote and UK based data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    sd.skills AS Skill,
    ROUND(AVG(salary_year_avg*0.74),0) AS avg_pay_gbp
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim  AS sjd ON  jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON  sjd.skill_id = sd.skill_id
WHERE 
    (job_work_from_home = TRUE OR job_country = 'United Kingdom') AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY 
    Skill
ORDER BY 
    avg_pay_gbp DESC
LIMIT 10;
```

Salary insights reveal three key themes driving higher pay in remote and UK based data analytics roles:

 **Big Data & ML Tools:**  
  Skills in **PySpark**, **Couchbase**, **Watson**, and **DataRobot** consistently rank among the highest-paid, reflecting strong demand for scalable data processing and predictive modeling.

 **DevOps & Collaboration Platforms:**  
  **Bitbucket** tops the salary chart, highlighting the value of version control and collaborative development in modern analytics workflows.

 **Cloud & Data Engineering Technologies:**  
  Tools like **Aurora** and **Elasticsearch** show that cloud-native infrastructure and search technologies are increasingly tied to higher earning potential.

| Skills        | Average Salary (£) |
|---------------|-------------------:|
| bitbucke      |            139,974 |
| tensorflow    |            131,189 |
| pytorch       |            131,189 |
| pyspark       |            126,995 |
| aurora        |            122,100 |
| kafka         |            122,100 |
| couchbase     |            118,781 |
| watson        |            118,781 |
| datarobot     |            115,059 |
| elasticsearch |            114,700 |

*Table of the average salary for the top 10 paying skills for remote and UK based data analysts*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```

| Skill ID | Skills     | Demand Count | Average Salary (£) |
|----------|------------|--------------|-------------------:|
| 75       | databricks | 12           |            98,911  |
| 234      | confluence | 11           |            84,515  |
| 97       | hadoop     | 25           |            83,669  |
| 80       | snowflake  | 38           |            82,956  |
| 74       | azure      | 40           |            82,273  |
| 76       | aws        | 34           |            81,451  |
| 194      | ssis       | 12           |            78,946  |
| 4        | java       | 18           |            78,765  |
| 79       | oracle     | 40           |            78,485  |
| 2        | nosql      | 14           |            78,343  |

*Table of the most optimal skills for remote and UK based data analyst sorted by salary*

Here's a breakdown of the most optimal skills for remote and UK based Data Analysts: 

- **High-Demand Programming Languages:** Despite not appearing in the top 10 highest salaries, Python and R stand out for their high demand with demand counts of 260 and 157 respectively. Despite their high demand, their average salaries are around £74,419 for Python and £73,861 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialised technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualisation Tools:** Tableau and Looker, with demand counts of 243 and 55 respectively, and average salaries around £72,792 and £76,580, highlight the critical role of data visualisation and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from £74,076 to £78,485, reflects the enduring need for data storage, retrieval, and management expertise.

# What I Learned

Throughout this project, I significantly expanded my SQL capabilities, sharpening both technical precision and analytical thinking:

- **🧩 Complex Query Crafting:** Developed advanced SQL fluency, confidently joining tables, nesting queries, and using `WITH` clauses to streamline temporary logic and improve readability.
- **📊 Data Aggregation:** Applied `GROUP BY` and aggregate functions like `COUNT()` and `AVG()` to extract meaningful summaries and trends from raw datasets.
- **💡 Analytical Problem-Solving:** Translated real world questions into structured, insightful queries, enhancing my ability to uncover patterns, answer business relevant questions, and support data driven decisions.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work or are UK based offer a wide range of salaries, the highest at £481,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialised technical skills such as Bitbucket, TensorFlow, PyTorch, and PySpark are associated with the highest average salaries, highlighting the premium placed on expertise in big data, machine learning, and modern development workflows.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximise their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the remote and UK based data analyst job market. The findings from the analysis serve as a guide to prioritiaing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
