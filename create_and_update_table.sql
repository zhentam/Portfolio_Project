-- First of all, I am creating the table with its columns and its corresponding data type

    CREATE TABLE baby_names (
        Year_of_Birth INT,
        Gender TEXT,
        Ethnicity TEXT,
        Childs_First_Name TEXT,
        Count INT,
        Rank INT
    );

-- Now I need to upload the data into the table
/*
This dataset shows the most popular baby names in the City of New York from 2011 to 2019
This dataset was downloaded from https://catalog.data.gov/dataset/popular-baby-names
*/

COPY baby_names
FROM '/Users/zytl/SQL/Portfolio_Project/csv_files/Popular_Baby_Names.csv'
DELIMITER ',' CSV HEADER;


/* 
Also, I believe the dataset should be updated in the following:
    1.  The ethnicity column considers 4 ethnicities. But for some reason in 2012, 3 out of 4 ethniticies are truncated
    2.  childs_first_name is in capital letters. I will update the dataset so only the first letter of each name is in capital letter
    3.  I will update ethnicty and gender to lower case so it is easier to type
    4.  For some reason there are rows that are duplicate. Because I do not know the reaseon I have decided not manipulate the dataset in this regard
    I will do 2 analysis not considering duplicates
    The reasoning behind this is because if I find myself in this position, without context, this is what I would present to the stakeholders. Otherwise, I would ask about the dataset to who created it
    
*/

-- Update childs_first_name column to have just the first letter in capital

UPDATE baby_names
SET Childs_First_Name = CONCAT(UPPER(SUBSTRING(Childs_First_Name, 1, 1)), LOWER(SUBSTRING(Childs_First_Name, 2)));

-- Update ethnicity column to fix truncated cells and change to lower case

UPDATE baby_names
SET ethnicity = 
    CASE ethnicity
        WHEN 'ASIAN AND PACI' THEN 'ASIAN AND PACIFIC ISLANDER'
        WHEN 'BLACK NON HISP' THEN 'BLACK NON HISPANIC'
        WHEN 'WHITE NON HISP' THEN 'WHITE NON HISPANIC'
        ELSE ethnicity 
    END
WHERE Year_of_Birth = 2012;

UPDATE baby_names
SET ethnicity = LOWER(ethnicity);


-- Update gender to lowercase

UPDATE baby_names
SET gender = LOWER(gender)
