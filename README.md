# data-analytics-power-bi-report159
Project Milestone 2: Data Import and Transformation in Power BI
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

Milestone 3:

This Power BI project aims to build an analytical report using various data sources, such as Orders, Products, Stores, and Customers data. The goal is to model the data, create relevant measures and hierarchies, and build a star schema for effective reporting.

1. Data Importation and Transformation
a. Orders Table (Azure SQL Database)
Data Source: Connected to an Azure SQL Database to import the orders_powerbi table.
Transformation:
Removed sensitive columns like [Card Number].
Split the [Order Date] and [Shipping Date] into separate Date and Time columns.
Filtered out rows with null values in the [Order Date] column.
Renamed columns to follow Power BI naming conventions for consistency and readability.
b. Products Table (CSV File)
Data Source: Imported the Products.csv file using the Get Data option.
Transformation:
Used the Remove Duplicates feature to ensure unique product_code.
Renamed columns for consistency with the Power BI conventions.
c. Stores Table (Azure Blob Storage)
Data Source: Connected to Azure Blob Storage using the provided credentials to import the Stores table.
Transformation:
Renamed columns to maintain naming consistency.
d. Customers Table (CSV Files)
Data Source: Imported data from multiple CSV files contained in a folder using the Folder data connector.
Transformation:
Combined the data from three files into one table.
Created a calculated column for Full Name by concatenating [First Name] and [Last Name].
Removed unused columns and renamed columns for better understanding and usability.
2. Creating the Date Table
A continuous date table was created to allow for time intelligence functions in Power BI.

Steps:
Used DAX to generate a date table ranging from the earliest [Order Date] to the latest [Shipping Date].
Added the following calculated columns:
Day of Week
Month Number
Month Name
Quarter
Year
Start of Year
Start of Quarter
Start of Month
Start of Week
DAX for Date Table:
DAX
Copy code
Date = 
ADDCOLUMNS(
    CALENDAR(MIN(Orders[Order Date]), MAX(Orders[Shipping Date])),
    "Day of Week", WEEKDAY([Date]),
    "Month Number", MONTH([Date]),
    "Month Name", FORMAT([Date], "MMMM"),
    "Quarter", QUARTER([Date]),
    "Year", YEAR([Date]),
    "Start of Year", DATE(YEAR([Date]), 1, 1),
    "Start of Quarter", STARTOFQUARTER([Date]),
    "Start of Month", EOMONTH([Date], -1) + 1,
    "Start of Week", [Date] - WEEKDAY([Date], 2) + 1
)
3. Creating Relationships (Star Schema)
Relationships were established between tables to form a star schema.

Relationships:
Products[product_code] → Orders[product_code]
Stores[store_code] → Orders[Store Code]
Customers[User UUID] → Orders[User ID]
Date[date] → Orders[Order Date] (active relationship)
Date[date] → Orders[Shipping Date] (inactive relationship)
All relationships were set to one-to-many with a single filter direction from the dimension table to the fact table.

4. Key Measures Created
Several key measures were created using DAX formulas to provide important business insights:

Total Orders: Counts the number of orders in the Orders table.

DAX
Copy code
Total Orders = COUNTROWS(Orders)
Total Revenue: Multiplies the quantity of each product by the sale price and sums the result.

DAX
Copy code
Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale_Price]))
Total Profit: Calculates the total profit by subtracting cost from sale price and multiplying by the product quantity.

DAX
Copy code
Total Profit = SUMX(Orders, (RELATED(Products[Sale_Price]) - RELATED(Products[Cost_Price])) * Orders[Product Quantity])
Total Customers: Counts the unique customers in the Orders table.

DAX
Copy code
Total Customers = DISTINCTCOUNT(Orders[User ID])
Total Quantity: Counts the total quantity of products sold.

DAX
Copy code
Total Quantity = SUM(Orders[Product Quantity])
Profit YTD: Calculates the Year-to-Date profit.

DAX
Copy code
Profit YTD = TOTALYTD([Total Profit], Date[Date])
Revenue YTD: Calculates the Year-to-Date revenue.

DAX
Copy code
Revenue YTD = TOTALYTD([Total Revenue], Date[Date])
5. Hierarchies Creation
a. Date Hierarchy
Created a drill-down hierarchy in the Date table, which includes the following levels:

Start of Year
Start of Quarter
Start of Month
Start of Week
Date
b. Geography Hierarchy
Added a Country calculated column and a Geography calculated column, then created a Geography hierarchy in the Stores table:

World Region
Country
Country Region
