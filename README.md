# data-analytics-power-bi-report159
Project Milestone: Data Import and Transformation in Power BI
Overview
In this milestone, the focus was on importing and transforming data from various sources into Power BI for analysis and reporting. The tasks completed include:

Importing the Orders Table:

Source: Azure SQL Database
Credentials:
Server Name: aicore-devops-project-server.database.windows.net
Database Name: powerbi-orders-db
Username: maya
Password: AiCore1237
Process:
Used the "Database" connector option in Power BI to connect to the Azure SQL Database.
Imported the orders_powerbi table.
Applied transformations in Power Query Editor to:
Delete the Card Number column for data privacy.
Split the Order Date and Shipping Date columns into date and time components.
Remove rows with missing values in the Order Date column.
Rename columns to align with Power BI naming conventions.
Importing the Products Table:

Source: Products.csv file
Process:
Used the "Get Data" option in Power BI to import the CSV file.
Removed duplicates based on the product_code column to ensure uniqueness.
Renamed columns to match Power BI naming conventions for consistency.
Importing the Stores Table:

Source: Azure Blob Storage
Credentials:
Account Name: powerbistorage4776
Account Key: 96jZrwqCC6QkbuWE2SNB+PaDjwNf4ZJitYbFr/wD5CY1zIKh1FE296tDMBKjHOurQU74rPNkVuKJ+ASt/yAsiA==
Container Name: data-analytics
Process:
Connected to Azure Blob Storage using the "Get Data" option in Power BI.
Imported the Stores table.
Renamed columns to adhere to Power BI naming conventions for clarity and consistency.
Importing and Transforming the Customers Data:

Source: Customers.zip file (containing CSV files for different regions)
Process:
Used the "Folder" connector in Power BI to import data from the extracted folder.
Combined the CSV files into a single dataset.
Created a new column Full Name by combining First Name and Last Name.
Removed unused columns and renamed remaining columns to follow Power BI naming conventions.
Power BI Report
The Power BI .pbix file reflecting these transformations and data imports has been saved and is available for review.
