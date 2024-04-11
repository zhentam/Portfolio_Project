## Introduction

This Project aims to showcase my skills in SQL and how I perform my analysis. The dataset used is Popular Baby Names by Sex and Ethnic Group in New York City from 2011 to 2019. 
Link to dataset: [Popular Baby Names | NYC Open Data](https://data.cityofnewyork.us/Health/Popular-Baby-Names/25th-nujf/about_data)

## Background

Driven by the curiosity to navigate this dataset, this project aims to give a general view of this dataset, discover the most popular names through this period and, finally, find the most popular name from each gender and ethnicity (Asian and Pacific islander, Black non Hispanic, Hispanic and White non Hispanic).

The questions I will answer through my SQL queries were:
1.	Considering gender and ethnicity, how many children were born from 2011 to 2019 in the City of New York?
2.	Which are the ten (five per gender) most common names in this period?
3.	 Which is the most common name for each ethnicity?

## Tools I Used

-	**SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.
-	**PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
-	**Visual Studio Code**: My go-to for database management and executing SQL queries.
-	**Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

## Pre-Analysis

Before deep diving into the dataset, I need to inspect it because I was not involved in its creation and cleaning process. There are some updates I will do to easier query writing and, most importantly, to have matching ethnicities throughout the table.

-	**Update childs_first_name column**: Names are in capital letter. For clarity and easier query writing, I changed it to first letter capital and the rest in lower case.

```
UPDATE baby_names
SET Childs_First_Name = CONCAT(UPPER(SUBSTRING(Childs_First_Name, 1, 1)), LOWER(SUBSTRING(Childs_First_Name, 2)));
```

- **Update ethnicity column**: (i) In 2012, 3 out of 4 ethnicities are truncated. I decided to update the table in order to have matching ethnicities. (ii) For clarity and easier query writing, I set it on lower case.

```
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
```

- **Update gender column**: Similar as the previous columns, for clarity and easier query writing, I set it on lower case.

Insertar query

- **Duplicate values from 2011 to 2014**: Maybe there was a problem with the dataset, maybe it is supposed to have those values, maybe…maybe…maybe. Because I do not have the reasoning behind this, I have decided to do my analysis just considering the unique values. I am not updating the table, instead I will be using CTEs in my queries.

Insertar query 


Analysis

1.	Total children names by gender and ethnicity

This won’t be my main question to answer, but I believe it is fundamental to have a general understanding of the dataset. This information is an introduction to the dataset so you, the reader, can have a broad view.

The first thing to know is how many babies were names according to this dataset.

Inserter query de total names

This query shows there were 606.104 babies born in the City of New York from 2011 to 2019.

To have a general impression of this dataset, I decided to see total names considering gender and its corresponding percentage.

Insertar Query total gender

A total of 339.862 male babies were born which represents 56% and 266.242 female babies were born which represent almost 44% of total through 2011 to 2019.

Now let’s see how many babies were born by each ethnicity.

Inserter query query total eth

This query shows that White non Hispanic ethnicity represents 39,95% (242.137) and Hispanic ethnicity represents almost 32,63% (197.749) and both together combined are approximately 73% of the babies’ name.
On the other hand, Black non Hispanic ethnicity contributes 13,89% (84.173) and Asian and Pacific Islander 13,54% (82.045) and both combined  38% of the names. I grouped them in these two groups because their percentage are similar and we can see that White non Hispanic and Hispanic are the ethnicities with the most babies born.
It is important to have this in mind, so these latter ethnicities do not get under represented.

Finally, we can combine gender and ethnicity to grasp better this trend.

Insetar query total gender + eth 

2.	Top 10 most popilar names from 2011 to 2019 in the City of New York

In this section I will find the Top 5 most repeated name for each gender. For now, I will only consider the entire dataset, without taking in consideration each year. To do this I will sum the count column grouped by names.

Insertar query top 20

The previous query shows us that ¾ of the Top 20 names are from males. To select just the Top 5 names per gender I will change the query. Also, I will add the contribution each ethnicity gives to the total sum.

Insertar query TOP 5 + contribuciones

All Top 5 male names are higher than every Top 5 female names. Even more, there is approximately a difference of 1.000 in each rank by gender. For example: the most repeated male name is Ethan (5.867) and the most repeated female name is Sophia (4.814).

To see each ethnicity’s contribution in a better perspective, we can change their total to percentage.

Insertar query TOP 5 + AS PERCENTAGE

The Hispanic presents a considerable number of names to the Top 5 of both genders. They have the highest average percentage of contribution to Top 5 names (42,97%). It is followed by White non Hispanic (27,71%), then Asian and Pacific Islander (16,98%) and finally Black non Hispanic (12,35%). 

This analysis allows us to see which names were the most popular from 2011 to 2019. However, it only provides an analysis considering this period as a whole. In the next section I will dig deeper taking it consideration each ethnicity and every year to find their top names. 



3.	Most popular name in each ethnicity by gender

You might be wondering what happens if one name is shared by two or more ethnicities. This is a good question that the previous section left unanswered. Here is where the rank column will be helpful. This column gives a ranking to each name considering their count, ethnicity and year. That means, I can obtain the most common names by year. To obtain the most popular name I want to meet two conditions: 
I.	Most rank 1 through this period
II.	Most count in this whole period (also named as Top)

First of all, I will obtain the names with the most rank 1.

Insertar query rank 1 only

One notorious thing is that Asian and Pacific Islander there are two male names with the most rank 1 (Ehtan and Jayden). Also, compared to other most rank 1, they are not predominantly rank 1 through this period. However, this insight will be useful for another occasion. 

Even though, this table gives the most rank 1, I still need to check Top names. For this reason, I will use another query to check the name with the most count by ethnicity.

Inserter query top 1 by ethnicity

Now I need a query to join these previous tables to see which are the most common names.

Insertar query join top 1 y rank 

Taking in consideration the results of both I can say with certainty that the top names are:

| childs_first_name | ethnicity | gender | total_count | number_of_rank1|
|------------------------|------------|----------|----------------|---------------------- |
| Ethan | Asian and Pacific Islander | male | 1518 | 3
| Olivia | Asian and Pacific Islander | female | 1185 | 4
| Noah | Black non Hispanic | male | 1202 | 5
| Madison | Black non Hispanic | female | 1024 | 5
| Liam | Hispanic | male | 2719 | 6
| Isabella | Hispanic | female | 2659 | 8
| David | White non Hispanic | male | 2485 | 5

This table is showing which the most popular name from each ethnicity and gender. But we are missing the most popular female White non Hispanic name. It seems the most ranked 1 name does not match the top 1 name.  According to the previous queries: the Most Ranked White non Hispanic female name is **Olivia** and the Top 1 White non Hispanic female name is **Esther**.
With the following query I will obtain more details about these names.

Inserter query de esther y Olivia
| childs_first_name | total_count | number_of_rank1|
|------------------------|----------------|---------------------- |
| Esther | 1986 | 3
| Olivia | 1973 | 4

Because both names have similar total count and number of rank 1, I have decided the to consider both as the most popular White non Hispanic name. 


| childs_first_name | ethnicity | gender | total_count | number_of_rank1|
|------------------------|------------|----------|----------------|---------------------- |
| Ethan | Asian and Pacific Islander | male | 1518 | 3
| Olivia | Asian and Pacific Islander | female | 1185 | 4
| Noah | Black non Hispanic | male | 1202 | 5
| Madison | Black non Hispanic | female | 1024 | 5
| Liam | Hispanic | male | 2719 | 6
| Isabella | Hispanic | female | 2659 | 8
| David | White non Hispanic | male | 2485 | 5
| Esther | White non Hispanic | female | 1986 | 3
| Olivia | White non Hispanic | female | 1973 | 4

This is the final result of my question about the most popular name. 





Este es solo un pequeño analisis porque TOP 5 representan 49914 de 606104. Total children names from the Top 5 is 49.914 out of grand total 606.104

Asian male names solamente tienen con most rank 1 solo tienen 3 cada uno y son 9 años. Ojo

Son los top 5 nombres los mismos top 5 de cada año?

How many unique names are there by ethnicity and gender? (CAMBIAR EL ORDEN Y MAS ANALISIS)

