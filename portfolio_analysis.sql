/*
This dataset shows the most popular baby names in the City of New York from 2011 to 2019
This dataset was downloaded from https://catalog.data.gov/dataset/popular-baby-names
*/



-- 1. Total names by gender and ethnicity

-- Total names

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    SUM(count) AS total_names
FROM
    non_duplicate_names

-- Total names by gender

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    gender,
    SUM(count) AS total_names,
    ROUND(SUM(count) * 100.0 / (SELECT SUM(count) FROM non_duplicate_names), 2) AS percentage
FROM
    non_duplicate_names
GROUP BY
    gender
ORDER BY
    total_names DESC;


-- Total names by ethnicities

WITH non_duplicate_names AS(
    SELECT DISTINCT *
    FROM baby_names
        baby_names
)
SELECT
    ethnicity,
    SUM(count) as total_names,
    ROUND(SUM(count) * 100.0 / (SELECT SUM(count) FROM non_duplicate_names), 2) AS percentage
FROM
    non_duplicate_names
GROUP BY
    ethnicity
ORDER BY
    total_names DESC;


-- Total names by gender and ethnicities

WITH non_duplicate_names AS(
    SELECT DISTINCT *
    FROM
        baby_names
)
SELECT
    gender,
    ethnicity,
    SUM(count) as total_names,
    ROUND(SUM(count) * 100.0 / (SELECT SUM(count) FROM non_duplicate_names), 2) AS percentage
FROM
    non_duplicate_names
GROUP BY
    gender,
    ethnicity
ORDER BY
    gender DESC,
    total_names DESC;


--- Which are the TOP 20 Names

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    childs_first_name,
    gender,
    SUM(count) as total_names
FROM
    non_duplicate_names
GROUP BY
    childs_first_name,
    gender
ORDER BY
    total_names DESC
LIMIT 20
;


-- 2. TOP 5 NAMES through 2011 - 2019 by GENDER and each ETHNICITY contributions

    --(This ranking was created with the total count through 2011-2019)

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        SUM(CASE WHEN ethnicity = 'hispanic' THEN count ELSE 0 END) AS hisp_total,
        SUM(CASE WHEN ethnicity = 'white non hispanic' THEN count ELSE 0 END) AS white_total,
        SUM(CASE WHEN ethnicity = 'black non hispanic' THEN count ELSE 0 END) AS black_total,
        SUM(CASE WHEN ethnicity = 'asian and pacific islander' THEN count ELSE 0 END) AS asian_total,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
SELECT
    childs_first_name,
    gender,
    total_names,
    hisp_total,
    white_total,
    black_total,
    asian_total
FROM
    ranked_names
WHERE
    name_rank <= 5
ORDER BY
    gender DESC,
    total_names DESC;

---- To see each ethnicity's contributions, the total can be shown as percentage 

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
),
ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        SUM(CASE WHEN ethnicity = 'hispanic' THEN count ELSE 0 END) AS hisp_total,
        SUM(CASE WHEN ethnicity = 'white non hispanic' THEN count ELSE 0 END) AS white_total,
        SUM(CASE WHEN ethnicity = 'black non hispanic' THEN count ELSE 0 END) AS black_total,
        SUM(CASE WHEN ethnicity = 'asian and pacific islander' THEN count ELSE 0 END) AS asian_total,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
SELECT
    childs_first_name,
    gender,
    total_names,
    ROUND((hisp_total * 100.0 / total_names), 2) AS hisp_percentage,
    ROUND((white_total * 100.0 / total_names), 2) AS white_percentage,
    ROUND((black_total * 100.0 / total_names), 2) AS black_percentage,
    ROUND((asian_total * 100.0 / total_names), 2) AS asian_percentage
FROM
    ranked_names
WHERE
    name_rank <= 5
ORDER BY
    gender DESC,
    total_names DESC;


-- 3. Most popular names of the 4 ethnicities

-- Names with most Rank 1 by ethnicity and gender

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
),
ranked_names AS (
    SELECT 
        childs_first_name,
        ethnicity,
        gender,
        COUNT(*) AS number_of_rank1,
        DENSE_RANK() OVER (PARTITION BY ethnicity, gender ORDER BY COUNT(*) DESC) AS dr
    FROM 
        non_duplicate_names
    WHERE 
        Rank = 1
    GROUP BY 
        childs_first_name,
        ethnicity,
        gender
)
SELECT 
    childs_first_name,
    ethnicity,
    gender,
    number_of_rank1
FROM 
    ranked_names
WHERE 
    dr = 1
ORDER BY
    ethnicity,
    gender,
    number_of_rank1 DESC;


--- Names with the most count by ethnicity (Top 1)

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
,ranked_names AS (
    SELECT
        childs_first_name,
        gender,
        ethnicity,
        SUM(Count) AS total_count,
        ROW_NUMBER() OVER (PARTITION BY gender, ethnicity ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    GROUP BY
        childs_first_name,
        gender,
        ethnicity
)
SELECT
    childs_first_name,
    ethnicity,
    gender,
    total_count
FROM
    ranked_names
WHERE
    name_rank <= 1
ORDER BY
    ethnicity,
    gender,
    total_count DESC;


--- Join between most Rank 1 & Top 1 by ethnicity and gender

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
),
ranked_names_rank1 AS (
    SELECT 
        childs_first_name,
        ethnicity,
        gender,
        COUNT(*) AS number_of_rank1,
        DENSE_RANK() OVER (PARTITION BY ethnicity, gender ORDER BY COUNT(*) DESC) AS dr
    FROM 
        non_duplicate_names
    WHERE 
        Rank = 1
    GROUP BY 
        childs_first_name,
        ethnicity,
        gender
),
ranked_names_total AS (
    SELECT
        childs_first_name,
        gender,
        ethnicity,
        SUM(Count) AS total_count,
        ROW_NUMBER() OVER (PARTITION BY gender, ethnicity ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    GROUP BY
        childs_first_name,
        gender,
        ethnicity
),
distinct_names AS (
    SELECT DISTINCT childs_first_name
    FROM non_duplicate_names
)
SELECT 
    r1.childs_first_name,
    r1.ethnicity,
    r1.gender,
    r2.total_count,
    r1.number_of_rank1
FROM 
    ranked_names_rank1 r1
JOIN 
    ranked_names_total r2 ON r1.childs_first_name = r2.childs_first_name AND r1.gender = r2.gender AND r1.ethnicity = r2.ethnicity
JOIN 
    distinct_names dn ON r1.childs_first_name = dn.childs_first_name
WHERE
    r1.dr = 1 AND r2.name_rank <= 1
ORDER BY
    r1.ethnicity,
    r1.gender DESC,
    r1.number_of_rank1 DESC;

--- Check in detail White non Hispanic female

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    childs_first_name,
    SUM(count) as total_count,
    COUNT(CASE WHEN rank = 1 THEN 1 END) as number_of_rank1
FROM
    non_duplicate_names
WHERE
    childs_first_name IN ('Olivia', 'Esther') AND
    ethnicity = 'white non hispanic'
GROUP BY
    childs_first_name


WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    childs_first_name,
    rank
FROM
    non_duplicate_names
WHERE
    childs_first_name IN ('Olivia', 'Esther') AND
    ethnicity = 'white non hispanic'
ORDER BY
    childs_first_name,
    rank

