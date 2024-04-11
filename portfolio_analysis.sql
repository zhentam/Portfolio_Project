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


-- TOP 5 NAMES through 2011 - 2019 by GENDER and each ETHNICITY contributions

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

        -- a.

    -- ** TOP 5 names in white non hispanic

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'white non hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    childs_first_name,
    gender,
    ethnicity,
    total_names
FROM
    ranked_names
WHERE
    name_rank <= 5
ORDER BY
    gender DESC,
    total_names DESC;

    --- Join between TOTAL TOP 5 and TOP 5 white non hispanic

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names_gender AS (
    SELECT
        gender,
        childs_first_name,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank_gender
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
, ranked_names_ethnicity AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender, ethnicity ORDER BY SUM(count) DESC) AS name_rank_ethnicity
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'white non hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    rg.childs_first_name,
    rg.gender,
    rg.total_names AS total_names_gender,
    re.ethnicity,
    re.total_names AS total_names_ethnicity
FROM
    ranked_names_gender rg
JOIN
    ranked_names_ethnicity re ON rg.childs_first_name = re.childs_first_name AND rg.gender = re.gender
WHERE
    rg.name_rank_gender <= 5 AND re.name_rank_ethnicity <= 5;


    --  ** TOP 5 names in hispanic

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    childs_first_name,
    gender,
    ethnicity,
    total_names
FROM
    ranked_names
WHERE
    name_rank <= 5
ORDER BY
    gender DESC,
    total_names DESC;

    --- Join between TOTAL TOP 5 and TOP 5 hispanic

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names_gender AS (
    SELECT
        gender,
        childs_first_name,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank_gender
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
, ranked_names_ethnicity AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender, ethnicity ORDER BY SUM(count) DESC) AS name_rank_ethnicity
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    rg.childs_first_name,
    rg.gender,
    rg.total_names AS total_names_gender,
    re.ethnicity,
    re.total_names AS total_names_ethnicity
FROM
    ranked_names_gender rg
JOIN
    ranked_names_ethnicity re ON rg.childs_first_name = re.childs_first_name AND rg.gender = re.gender
WHERE
    rg.name_rank_gender <= 5 AND re.name_rank_ethnicity <= 5;

    --  ** TOP 5 names in asian and pacific islander

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'asian and pacific islander'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    childs_first_name,
    gender,
    ethnicity,
    total_names
FROM
    ranked_names
WHERE
    name_rank <= 5
ORDER BY
    gender DESC,
    total_names DESC;


    --- Join between TOTAL TOP 5 and TOP 5 asian and pacific islander

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names_gender AS (
    SELECT
        gender,
        childs_first_name,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank_gender
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
, ranked_names_ethnicity AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender, ethnicity ORDER BY SUM(count) DESC) AS name_rank_ethnicity
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'asian and pacific islander'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    rg.childs_first_name,
    rg.gender,
    rg.total_names AS total_names_gender,
    re.ethnicity,
    re.total_names AS total_names_ethnicity
FROM
    ranked_names_gender rg
JOIN
    ranked_names_ethnicity re ON rg.childs_first_name = re.childs_first_name AND rg.gender = re.gender
WHERE
    rg.name_rank_gender <= 5 AND re.name_rank_ethnicity <= 5;


    --  **TOP 5 names in black non hispanic

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'black non hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    childs_first_name,
    gender,
    ethnicity,
    total_names
FROM
    ranked_names
WHERE
    name_rank <= 5
ORDER BY
    gender DESC,
    total_names DESC;


    --- Join between TOTAL TOP 5 and TOP 5 black non hispanic

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names_gender AS (
    SELECT
        gender,
        childs_first_name,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank_gender
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
, ranked_names_ethnicity AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender, ethnicity ORDER BY SUM(count) DESC) AS name_rank_ethnicity
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'black non hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
)
SELECT
    rg.childs_first_name,
    rg.gender,
    rg.total_names AS total_names_gender,
    re.ethnicity,
    re.total_names AS total_names_ethnicity
FROM
    ranked_names_gender rg
JOIN
    ranked_names_ethnicity re ON rg.childs_first_name = re.childs_first_name AND rg.gender = re.gender
WHERE
    rg.name_rank_gender <= 5 AND re.name_rank_ethnicity <= 5;



-- 3. Rank


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



----- Considering total TOP 5 and each ethnicity TOP 5 
----- Which names 

--- top 1 total

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




-- TAL VEZ GENERAR UN RANKING POR AÑO?


WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    childs_first_name,
    gender,
    SUM (count)
FROM
    non_duplicate_names
WHERE
    year_of_birth = 2011
GROUP BY
    childs_first_name,
    gender


--- NOMBRES QUE SE REPITEN POR CADA ETNIA

--- hacer una historia final en base a etnias


WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
),
ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        ethnicity,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    WHERE
        ethnicity = 'black non hispanic'
    GROUP BY
        gender,
        childs_first_name,
        ethnicity
),
matching_names AS (
    SELECT
        Childs_First_Name,
        gender
    FROM
        non_duplicate_names
    WHERE
        rank IN (1, 2, 3, 4, 5)
    GROUP BY
        Childs_First_Name,
        gender
    HAVING
        COUNT(DISTINCT year_of_birth) = 9
)
SELECT
    r.childs_first_name,
    r.gender,
    r.ethnicity,
    r.total_names
FROM
    ranked_names r
JOIN
    matching_names m ON r.childs_first_name = m.Childs_First_Name AND r.gender = m.gender
WHERE
    r.name_rank <= 5
ORDER BY
    r.gender DESC,
    r.total_names DESC;





/* COMO LO UNO A LA NARRATIVA? */

-- Number of unique names by ethnicity and gender

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    gender,
    ethnicity,
    count (childs_first_name) as number_unique_names
FROM
    non_duplicate_names
GROUP BY
    ethnicity,
    gender
ORDER BY
    number_unique_names DESC;

-------Finally, even though there are more male babies, there are more or equal female unique names

-- How do these names evolve throught 2011 - 2019?

    -- NOMBRES COMO FILA / AÑOS COMO COLUMNA
WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
, ranked_names AS (
    SELECT
        gender,
        childs_first_name,
        SUM(count) AS total_names,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(count) DESC) AS name_rank
    FROM
        non_duplicate_names
    GROUP BY
        gender,
        childs_first_name
)
, top_names AS (
    SELECT
        gender,
        childs_first_name
    FROM
        ranked_names
    WHERE
        name_rank <= 5
)
SELECT
    Childs_First_Name,
    SUM(CASE WHEN Year_of_Birth = 2011 THEN Count ELSE 0 END) AS total_2011,
    SUM(CASE WHEN Year_of_Birth = 2012 THEN Count ELSE 0 END) AS total_2012,
    SUM(CASE WHEN Year_of_Birth = 2013 THEN Count ELSE 0 END) AS total_2013,
    SUM(CASE WHEN Year_of_Birth = 2014 THEN Count ELSE 0 END) AS total_2014,
    SUM(CASE WHEN Year_of_Birth = 2015 THEN Count ELSE 0 END) AS total_2015,
    SUM(CASE WHEN Year_of_Birth = 2016 THEN Count ELSE 0 END) AS total_2016,
    SUM(CASE WHEN Year_of_Birth = 2017 THEN Count ELSE 0 END) AS total_2017,
    SUM(CASE WHEN Year_of_Birth = 2018 THEN Count ELSE 0 END) AS total_2018,
    SUM(CASE WHEN Year_of_Birth = 2019 THEN Count ELSE 0 END) AS total_2019,
    SUM(count) as total_count
FROM
    non_duplicate_names
WHERE
    Childs_First_Name IN (SELECT Childs_First_Name FROM top_names)
GROUP BY
    Childs_First_Name
ORDER BY
    sum(count) DESC;


    -- AÑOS COMO FILA Y NOMBRES COMO COLUMNA

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    year_of_birth,
    SUM(CASE WHEN childs_first_name = 'Jayden' THEN count ELSE 0 END) AS jayden_count,
    SUM(CASE WHEN childs_first_name = 'Ethan' THEN count ELSE 0 END) AS ethan_count,
    SUM(CASE WHEN childs_first_name = 'Liam' THEN count ELSE 0 END) AS liam_count,
    SUM(CASE WHEN childs_first_name = 'Jacob' THEN count ELSE 0 END) AS jacob_count,
    SUM(CASE WHEN childs_first_name = 'Noah' THEN count ELSE 0 END) AS noah_count,
    SUM(CASE WHEN childs_first_name = 'Sophia' THEN count ELSE 0 END) AS sophia_count,
    SUM(CASE WHEN childs_first_name = 'Isabella' THEN count ELSE 0 END) AS isabella_count,
    SUM(CASE WHEN childs_first_name = 'Olivia' THEN count ELSE 0 END) AS olivia_count,
    SUM(CASE WHEN childs_first_name = 'Emma' THEN count ELSE 0 END) AS emma_count,
    SUM(CASE WHEN childs_first_name = 'Mia' THEN count ELSE 0 END) AS mia_count
FROM
    non_duplicate_names
WHERE
    childs_first_name IN ('Jayden', 'Ethan', 'Liam', 'Jacob', 'Noah', 'Sophia', 'Isabella', 'Olivia', 'Emma', 'Mia')
GROUP BY
    year_of_birth
ORDER BY
    year_of_birth;


--- childs_firs_name in rank 1 to 5 through 2011-2019

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT
    Childs_First_Name,
    gender,
    COUNT(DISTINCT year_of_birth) AS year_count
FROM
    non_duplicate_names
WHERE
    rank IN (1, 2, 3, 4, 5)
GROUP BY
    Childs_First_Name,
    gender
HAVING
    COUNT(DISTINCT year_of_birth) = 9
ORDER BY
    year_count DESC;


--- We can dive a little deeper and see which ethnicity uses these names
--- childs_first_name and ethnicity that appear in rank 1-5 and through ALL 2011 - 2019

WITH non_duplicate_names AS (
    SELECT DISTINCT *
    FROM baby_names
)
SELECT *
FROM
    non_duplicate_names
WHERE
    childs_first_name IN (
        SELECT
            childs_first_name
        FROM
            non_duplicate_names
        WHERE
            rank IN (1, 2, 3, 4, 5)
        GROUP BY
            childs_first_name
        HAVING
            count (DISTINCT year_of_birth) = 9
    ) AND
    rank IN (1, 2, 3, 4, 5)
ORDER BY
    childs_first_name,
    year_of_birth;




