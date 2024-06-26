use world_layoffs;
drop table layoffs;

select * from layoffs;

create table layoffs_staging like layoffs;

insert into layoffs_staging 
select * from layoffs;

select * from layoffs_staging;


select *,
ROW_NUMBER() over(PARTITION BY company, location, company, location, industry, total_laid_off, percentage_laid_off, 
'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging;


with duplicate_cte as
(
select *,
ROW_NUMBER() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select * from duplicate_cte where row_num>1;


select * from layoffs_staging where company = 'Oyster';



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
select *,
ROW_NUMBER() over(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 
'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging;



select * from layoffs_staging2 where row_num>1;

delete
from layoffs_staging2
where row_num>1;

16:32:28	delete from layoffs_staging2 where row_num>1	Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.0016 sec
