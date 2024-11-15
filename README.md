Layoffs Data Analysis Project

Project Overview

This project analyzes layoffs data to uncover trends, insights, and patterns across companies, industries, and countries. It involves data preprocessing, standardization, cleaning, and exploratory data analysis (EDA) using SQL in a MySQL Workbench environment.

Key Steps

1. Data Cleaning

	•	Removing Duplicates: Identified and removed duplicate rows using ROW_NUMBER() with PARTITION BY.
	•	Standardizing Data:
	•	Trimmed unnecessary spaces from text columns (e.g., company, country).
	•	Standardized country names (e.g., “United States”).
	•	Converted dates into a consistent format (YYYY-MM-DD) using STR_TO_DATE().
	•	Handling Null/Blank Values:
	•	Set blank or invalid values to NULL for columns like total_laid_off, percentage_laid_off, and funds_raised.
	•	Filled missing industry values by cross-referencing with matching company rows.
	•	Column Removal: Dropped unnecessary columns such as row_num.

2. Data Transformation

	•	Data Type Changes:
	•	Converted total_laid_off, percentage_laid_off, and funds_raised to INT for accurate calculations.
	•	Changed the date column to DATE type.
	•	Calculated rolling sums of layoffs by month for trend analysis.

3. Exploratory Data Analysis (EDA)

	•	Insights from Aggregates:
	•	Total layoffs by industry, country, and company.
	•	Companies with the largest layoffs and percentage wiped out.
	•	Industry trends, highlighting which industries are the most affected.
	•	Identified top companies laying off employees each year.
	•	Analyzed the stage of the company during layoffs.
	•	Examined the date range of the dataset.

Insights Derived

	•	Intel, Tesla, and Cisco had the highest layoffs.
	•	The United States experienced significantly higher layoffs compared to other countries.
	•	Hardware and transportation industries were the most affected.
	•	Rolling layoffs revealed seasonal trends in employee reductions.

Future Improvements

	•	Automate data cleaning steps using scripts.
	•	Visualize trends using tools like Tableau or Python for better insights.
	•	Expand analysis by integrating additional data sources (e.g., financial performance).

How to Use

	1.	Setup:
	•	Import the SQL script into your MySQL database.
	•	Ensure proper configuration of tables and data types.
	2.	Execution:
	•	Run the queries sequentially to reproduce cleaning and analysis steps.
	3.	Output:
	•	Use the provided queries to explore the dataset and derive insights.
