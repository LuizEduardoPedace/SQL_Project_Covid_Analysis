COPY covid_deaths
FROM 'C:\Users\pedac\OneDrive\Documentos\Projects for Data Science\SQL_Project_Covid\csvdeaths.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

/*
\copy covid_deaths FROM 'C:\Users\pedac\OneDrive\Documentos\Projects for Data Science\SQL_Project_Covid\csvdeaths.csv' DELIMITER ';' CSV HEADER;

\copy covid_vaccination FROM 'C:\Users\pedac\OneDrive\Documentos\Projects for Data Science\SQL_Project_Covid\csvvaccinations.csv' DELIMITER ';' CSV HEADER;
*/