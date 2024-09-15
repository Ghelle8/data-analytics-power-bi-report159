# Data Analytics Power BI Report

## Project Milestone 2: Data Import and Transformation in Power BI

### Overview
In this milestone, the focus was on importing and transforming data from various sources into Power BI for analysis and reporting. The tasks completed include:

### 1. Importing the Orders Table:
- **Source:** Azure SQL Database
- **Credentials:**
  - **Server Name:** aicore-devops-project-server.database.windows.net
  - **Database Name:** powerbi-orders-db
  - **Username:** maya
  - **Password:** AiCore1237
- **Process:**
  - Used the "Database" connector option in Power BI to connect to the Azure SQL Database.
  - Imported the `orders_powerbi` table.
  - Applied transformations in Power Query Editor to:
    - Delete the `Card Number` column for data privacy.
    - Split the `Order Date` and `Shipping Date` columns into date and time components.
    - Remove rows with missing values in the `Order Date` column.
    - Rename columns to align with Power BI naming conventions.

### 2. Importing the Products Table:
- **Source:** Products.csv file
- **Process:**
  - Used the "Get Data" option in Power BI to import the CSV file.
  - Removed duplicates based on the `product_code` column to ensure uniqueness.
  - Renamed columns to match Power BI naming conventions for consistency.

### 3. Importing the Stores Table:
- **Source:** Azure Blob Storage
- **Credentials:**
  - **Account Name:** powerbistorage4776
  - **Account Key:** 96jZrwqCC6QkbuWE2SNB+PaDjwNf4ZJitYbFr/wD5CY1zIKh1FE296tDMBKjHOurQU74rPNkVuKJ+ASt/yAsiA==
  - **Container Name:** data-analytics
- **Process:**
  - Connected to Azure Blob Storage using the "Get Data" option in Power BI.
  - Imported the Stores table.
  - Renamed columns to adhere to Power BI naming conventions for clarity and consistency.

### 4. Importing and Transforming the Customers Data:
- **Source:** Customers.zip file (containing CSV files for different regions)
- **Process:**
  - Used the "Folder" connector in Power BI to import data from the extracted folder.
  - Combined the CSV files into a single dataset.
  - Created a new column `Full Name` by combining `First Name` and `Last Name`.
  - Removed unused columns and renamed remaining columns to follow Power BI naming conventions.

---

## Project Milestone 3: Create the Data Model

This Power BI project aims to build an analytical report using various data sources, such as Orders, Products, Stores, and Customers data. The goal is to model the data, create relevant measures and hierarchies, and build a star schema for effective reporting.

### 1. Data Importation and Transformation
- **Orders Table (Azure SQL Database)**
  - **Data Source:** Connected to an Azure SQL Database to import the `orders_powerbi` table.
  - **Transformation:**
    - Removed sensitive columns like `Card Number`.
    - Split the `Order Date` and `Shipping Date` into separate Date and Time columns.
    - Filtered out rows with null values in the `Order Date` column.
    - Renamed columns to follow Power BI naming conventions for consistency and readability.

- **Products Table (CSV File)**
  - **Data Source:** Imported the Products.csv file using the Get Data option.
  - **Transformation:**
    - Used the Remove Duplicates feature to ensure unique `product_code`.
    - Renamed columns for consistency with Power BI conventions.

- **Stores Table (Azure Blob Storage)**
  - **Data Source:** Connected to Azure Blob Storage using the provided credentials to import the Stores table.
  - **Transformation:**
    - Renamed columns to maintain naming consistency.

- **Customers Table (CSV Files)**
  - **Data Source:** Imported data from multiple CSV files contained in a folder using the Folder data connector.
  - **Transformation:**
    - Combined the data from three files into one table.
    - Created a calculated column for `Full Name` by concatenating `First Name` and `Last Name`.
    - Removed unused columns and renamed columns for better understanding and usability.

### 2. Creating the Date Table
A continuous date table was created to allow for time intelligence functions in Power BI.

- **Steps:**
  - Used DAX to generate a date table ranging from the earliest `Order Date` to the latest `Shipping Date`.
  - Added the following calculated columns:
    - Day of Week
    - Month Number
    - Month Name
    - Quarter
    - Year
    - Start of Year
    - Start of Quarter
    - Start of Month
    - Start of Week

- **DAX for Date Table:**

    ```DAX
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
    ```

### 3. Creating Relationships (Star Schema)
Relationships were established between tables to form a star schema.

- **Relationships:**
  - `Products[product_code]` → `Orders[product_code]`
  - `Stores[store_code]` → `Orders[Store Code]`
  - `Customers[User UUID]` → `Orders[User ID]`
  - `Date[date]` → `Orders[Order Date]` (active relationship)
  - `Date[date]` → `Orders[Shipping Date]` (inactive relationship)

- All relationships were set to one-to-many with a single filter direction from the dimension table to the fact table.

### 4. Key Measures Created
Several key measures were created using DAX formulas to provide important business insights:

- **Total Orders:** Counts the number of orders in the Orders table.
  
    ```DAX
    Total Orders = COUNTROWS(Orders)
    ```

- **Total Revenue:** Multiplies the quantity of each product by the sale price and sums the result.

    ```DAX
    Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale_Price]))
    ```

- **Total Profit:** Calculates the total profit by subtracting cost from sale price and multiplying by the product quantity.

    ```DAX
    Total Profit = SUMX(Orders, (RELATED(Products[Sale_Price]) - RELATED(Products[Cost_Price])) * Orders[Product Quantity])
    ```

- **Total Customers:** Counts the unique customers in the Orders table.

    ```DAX
    Total Customers = DISTINCTCOUNT(Orders[User ID])
    ```

- **Total Quantity:** Counts the total quantity of products sold.

    ```DAX
    Total Quantity = SUM(Orders[Product Quantity])
    ```

- **Profit YTD:** Calculates the Year-to-Date profit.

    ```DAX
    Profit YTD = TOTALYTD([Total Profit], Date[Date])
    ```

- **Revenue YTD:** Calculates the Year-to-Date revenue.

    ```DAX
    Revenue YTD = TOTALYTD([Total Revenue], Date[Date])
    ```

### 5. Hierarchies Creation
- **Date Hierarchy:** Created a drill-down hierarchy in the Date table, which includes the following levels:
  - Start of Year
  - Start of Quarter
  - Start of Month
  - Start of Week
  - Date

- **Geography Hierarchy:**
  - Added a `Country` calculated column and a `Geography` calculated column.
  - Created a Geography hierarchy in the Stores table:
    - World Region
    - Country
    - Country Region

---

## Project Milestone 4: Report Pages Setup and Color Theme

#### Steps to Create Report Pages:

1. **Executive Summary Page**
   - **Visualizations:**
     - KPIs for Total Revenue, Total Profit, Total Orders, and Total Customers.
     - Line Chart showing Revenue and Profit over time (using the Date hierarchy for drill-downs).
     - Bar Chart showing Product Category-wise breakdown of Revenue or Profit.
     - Card Visuals for top metrics (Revenue YTD, Profit YTD).

2. **Customer Detail Page**
   - **Visualizations:**
     - Table or Matrix visual showing Customer Name, Total Orders, Total Revenue, and Total Quantity.
     - Pie Chart showing Revenue by Region.
     - Bar Chart showing Customers by Product Category or Region.
   - **Slicers:** Include slicers for filtering by different dimensions like Country, Region, etc.

3. **Product Detail Page**
   - **Visualizations:**
     - Bar or Column Chart showing the most sold products (by quantity or revenue).
     - Table showing product details such as Product Name, Total Revenue, Total Profit, and Total Quantity.
     - Pie Chart showing Revenue by Product Category.
   - **Slicers:** Include slicers for filtering by product or product category.

4. **Stores Map Page**
   - **Visualizations:**
     - Map Visual plotting the stores by latitude and longitude (use Store Code and Location columns).
     - Table showing Store Name, Store Code, Revenue, and Profit.
     - Slicers for filtering by World Region, Country, or Store Type.
     - KPI cards showing Total Revenue and Profit for the selected stores.

#### Color Theme
To maintain consistency and clarity across all pages, choose and apply a predefined Power BI theme:

- **Steps to Apply a Theme:**
  - In Power BI Desktop, go to the Ribbon.
  - Click on the View tab.
  - Under Themes, browse and select one of Power BI's predefined themes:
    - Light: Provides a clean, professional look.
    - Solar: Provides a modern, vibrant look with brighter colors.
    - Executive: Has more muted, professional tones, suitable for business reports.
  - Explore more themes by clicking Browse for themes, or customize your own theme by choosing specific colors for charts and visuals.

- **Report Customization:**
  - **Consistency:** Ensure each page follows a consistent layout (e.g., similar size for card visuals or titles).
  - **Alignment:** Align the visuals neatly across all pages for a professional look.
  - **Page Titles:** Use text boxes to clearly label each page with its name (Executive Summary, Customer Detail, etc.).

#### Sidebar for Navigation
To add a sidebar for navigation between pages:

1. **Add a Rectangle Shape to the Executive Summary Page**
   - Open the Executive Summary Page in Power BI Desktop.
   - **Insert a Shape:**
     - Go to the Ribbon, click on the Insert tab.
     - Select Shapes and choose Rectangle.
   - **Resize the Rectangle:**
     - Click and drag the edges of the rectangle to make it a narrow strip covering the left side of the page (about 10% of the page width).
   - **Change the Fill Color:**
     - With the rectangle selected, go to the Format pane on the right.
     - Under Fill, choose a contrasting color (e.g., navy or dark gray).
   - **Adjust Transparency (Optional):**
     - Set transparency to around 10-20% for a more subtle appearance if desired.
   - **Remove Border (Optional):**
     - In the Format pane, under Border, toggle Off if you don't want an outline around the shape.

2. **Duplicate the Rectangle on Other Pages**
   - **Select the Rectangle:**
     - Click on the rectangle you created on the Executive Summary page.
   - **Copy the Rectangle:**
     - Use Ctrl + C (Cmd + C on Mac) or right-click and choose Copy.
   - **Navigate to Other Pages:**
     - Go to the Customer Detail, Product Detail, and Stores Map pages.
   - **Paste the Rectangle:**
     - Use Ctrl + V (Cmd + V on Mac) to paste the rectangle in the exact position.
   - **Align Consistently:**
     - Ensure the rectangle is aligned similarly on all pages to maintain a consistent layout.

### Upload and Document:
- Save the updated Power BI file (.pbix) and upload it to your GitHub repository.
- Document in the README file:
  - A description of each report page and its purpose.
  - The color theme used and why it was chosen.

## Project Milestone 5: Customer Detail Page

This page provides an overview of key metrics and insights.

#### Visuals
- **Card Visuals:**
  - **Unique Customers:** Displays the total number of unique customers.
  - **Revenue per Customer:** Shows the revenue generated per customer.

- **Donut Chart:** Represents the total number of customers by country.
  
- **Column Chart:** Illustrates the number of customers by product category.
  
- **Line Chart:** Plots `Total Customers` over time with a trend line and a 10-period forecast.

- **Table:** Displays the top 20 customers by revenue with conditional formatting applied to the revenue column.

- **Top Customer Card Visuals:** Highlight the top customer’s name, number of orders, and total revenue.

### Date Slicer
- Added a date slicer for filtering by year with the "Between" slicer style.

#### Screenshots
![Customer Detail Page](C:\Users\Suado\Desktop\PowerBI\Screenshots\Customer Detail Page.png)

---

## Project Milestone 6: Executive Summary Page 

### Overview

In this milestone, we enhanced the Executive Summary page by adding and configuring several key visuals. The updates provide a comprehensive overview of key metrics, trends, and targets.

### 1. Card Visuals

- **Total Revenue, Total Orders, and Total Profit Cards:**
  - **Visuals Created:** Added three card visuals to display `Total Revenue`, `Total Orders`, and `Total Profit`.
  - **Formatting:**
    - **Total Revenue:** Displayed to 2 decimal places.
    - **Total Orders:** Displayed to 1 decimal place.
    - **Total Profit:** Displayed to 2 decimal places.
  - **Arrangement:** Positioned the cards to span approximately half of the page width.

### 2. Line Chart

- **Revenue Over Time Line Chart:**
  - **Configuration:**
    - **X-Axis:** Set to `Date Hierarchy` with only `Start of Year`, `Start of Quarter`, and `Start of Month` levels displayed.
    - **Y-Axis:** Set to `Total Revenue`.
  - **Positioning:** Placed the line chart just below the card visuals.

### 3. Donut Charts

- **Revenue by Store Country and Store Type:**
  - **Configuration:**
    - **First Donut Chart:** Shows `Total Revenue` broken down by `Store[Country]`.
    - **Second Donut Chart:** Shows `Total Revenue` broken down by `Store[Store Type]`.
  - **Positioning:** Placed to the right of the cards along the top of the page.

### 4. Bar Chart

- **Orders by Product Category:**
  - **Configuration:**
    - **Visual Type:** Converted from a donut chart to a clustered bar chart.
    - **X-Axis:** Set to `Total Orders`.
  - **Formatting:** Applied colors consistent with the report theme.

### 5. KPI Visuals

- **Quarterly Revenue, Orders, and Profit KPIs:**
  - **KPIs Created:**
    - **Revenue KPI:** Displays `Total Revenue`, trends over `Start of Quarter`, and targets `Target Revenue`.
    - **Profit KPI:** Displays `Total Profit`, trends over `Start of Quarter`, and targets `Target Profit`.
    - **Orders KPI:** Displays `Total Orders`, trends over `Start of Quarter`, and targets `Target Orders`.
  - **Formatting:**
    - **Trend Axis:** Set to `On` with `High is Good` direction, `Red` for bad color, and `15%` transparency.
    - **Callout Value:** Set to 1 decimal place.

### 6. Final Page Layout

- **Completed Layout:**
  - The Executive Summary page now includes a combination of card visuals, line chart, donut charts, bar chart, and KPIs arranged to provide a clear and insightful overview of key metrics.

  **Screenshot of Completed Page:**
![Executive Summary Page](C:\Users\Suado\Desktop\PowerBI\Screenshots\Executive Summary Page.png)
---

## Milestone 7: Product Detail Page

### Adding KPI Gauges

**Objective:** Add a set of gauges to show current-quarter performance against targets.

1. **Define DAX Measures:**
   - **Orders Current Quarter:**
     ```DAX
     Orders Current Quarter = CALCULATE(SUM(Orders[Order Quantity]), QUARTER(Dates[Date]) = QUARTER(TODAY()))
     ```
   - **Revenue Current Quarter:**
     ```DAX
     Revenue Current Quarter = CALCULATE(SUM(Orders[Total Revenue]), QUARTER(Dates[Date]) = QUARTER(TODAY()))
     ```
   - **Profit Current Quarter:**
     ```DAX
     Profit Current Quarter = CALCULATE(SUM(Orders[Total Profit]), QUARTER(Dates[Date]) = QUARTER(TODAY()))
     ```
   - **Orders Target:**
     ```DAX
     Orders Target = CALCULATE([Orders Current Quarter] * 1.10)
     ```
   - **Revenue Target:**
     ```DAX
     Revenue Target = CALCULATE([Revenue Current Quarter] * 1.10)
     ```
   - **Profit Target:**
     ```DAX
     Profit Target = CALCULATE([Profit Current Quarter] * 1.10)
     ```
   - **Orders Gap:**
     ```DAX
     Orders Gap = [Orders Current Quarter] - [Orders Target]
     ```
   - **Revenue Gap:**
     ```DAX
     Revenue Gap = [Revenue Current Quarter] - [Revenue Target]
     ```
   - **Profit Gap:**
     ```DAX
     Profit Gap = [Profit Current Quarter] - [Profit Target]
     ```

2. **Create Gauges:**
   - **Orders Gauge:**
     - Value: `[Orders Current Quarter]`
     - Target: `[Orders Target]`
     - Maximum: `[Orders Target]`
   - **Revenue Gauge:**
     - Value: `[Revenue Current Quarter]`
     - Target: `[Revenue Target]`
     - Maximum: `[Revenue Target]`
   - **Profit Gauge:**
     - Value: `[Profit Current Quarter]`
     - Target: `[Profit Target]`
     - Maximum: `[Profit Target]`

3. **Conditional Formatting:**
   - **Callout Value Formatting:**
     - Red if `[Orders Gap]` or `[Revenue Gap]` or `[Profit Gap]` is negative.
     - Black otherwise.

4. **Arrange Gauges:**
   - Place gauges evenly along the top of the report.
   - Leave space for card visuals displaying slicer states.

---

### Adding Filter State Cards

1. **Add Placeholder Shapes:**
   - Insert two rectangles to the left of the gauges, matching the size of one gauge.
   - Use a color consistent with your report theme.

2. **Define Measures for Slicer States:**
   - **Category Selection:**
     ```DAX
     Category Selection = IF(ISFILTERED(Products[Category]), SELECTEDVALUE(Products[Category], "No Selection"), "No Selection")
     ```
   - **Country Selection:**
     ```DAX
     Country Selection = IF(ISFILTERED(Stores[Country]), SELECTEDVALUE(Stores[Country], "No Selection"), "No Selection")
     ```

3. **Add Card Visuals:**
   - Insert two card visuals into the rectangles.
   - Assign `[Category Selection]` and `[Country Selection]` to the respective cards.
   - Format cards to be the same size as gauges and center the text.

---

### Adding an Area Chart

1. **Insert Area Chart:**
   - Go to the `Insert` tab.
   - Select `Area Chart`.

2. **Configure the Chart:**
   - **X Axis:** `Dates[Start of Quarter]`
   - **Y Axis:** `Total Revenue`
   - **Legend:** `Products[Category]`

3. **Position the Chart:**
   - Place it to the left of the page, aligning it with the start of the second gauge.

---

### Adding a Top 10 Products Table

1. **Copy Existing Table:**
   - Duplicate the top customer table from the Customer Detail page.

2. **Configure Table Fields:**
   - **Product Description**
   - **Total Revenue**
   - **Total Customers**
   - **Total Orders**
   - **Profit per Order**

3. **Format the Table:**
   - Ensure the table fits neatly underneath the area chart.

---

### Creating a Scatter Chart for Product Performance

1. **Add a Calculated Column:**
   - **Profit per Item:**
     ```DAX
     Profit per Item = DIVIDE([Total Profit], [Total Quantity])
     ```

2. **Insert Scatter Chart:**
   - Go to the `Insert` tab.
   - Select `Scatter Chart`.

3. **Configure the Chart:**
   - **Values:** `Products[Description]`
   - **X Axis:** `Products[Profit per Item]`
   - **Y Axis:** `Orders[Total Quantity]`
   - **Legend:** `Products[Category]`

---

### Creating a Pop-Out Slicer Toolbar

1. **Add Filter Button:**
   - Insert a blank button.
   - Set icon type to `Custom`, upload `Filter_icon.png`, and set tooltip to "Open Slicer Panel".

2. **Add Slicer Toolbar:**
   - Insert a rectangle shape to act as the toolbar background.
   - Resize and color it to match the navigation bar.

3. **Add Slicers:**
   - Insert two slicers for `Products[Category]` and `Stores[Country]`.
   - Format as `Vertical List` and adjust settings for multiple selections and `Select All`.

4. **Group Toolbar and Slicers:**
   - Group the slicers and rectangle in the Selection pane.

5. **Add Back Button:**
   - Insert a `Back` button and position it in the toolbar.
   - Group it with the toolbar and slicers.

6. **Set Up Bookmarks:**
   - **Slicer Bar Open:** Toolbar visible.
   - **Slicer Bar Closed:** Toolbar hidden.
   - Uncheck `Data` in bookmarks settings.

7. **Assign Actions to Buttons:**
   - Set the `Filter` button action to "Slicer Bar Open".
   - Set the `Back` button action to "Slicer Bar Closed".

8. **Test Buttons:**
   - Use `Ctrl` + click to test button functionality.

---

By following these milestones, you will have a well-organized and interactive Power BI report, providing clear insights and a professional user experience.

### Screenshot
[Product Detail Page](C:\Users\Suado\Desktop\PowerBI\Screenshots\Product Detail Page.png)
---

## Milestone 8: Stores Map Page

### Overview
In this milestone, we focused on enhancing the Power BI report by adding interactive and detailed visuals for analyzing store performance. Key tasks included adding a map visual, creating a drillthrough page, and implementing a custom tooltip.

### 1. Stores Map Page
- **Added Map Visual:**
  - The map visual was added to the "Stores Map" page, occupying the majority of the page.
  - Configured map settings:
    - Auto-Zoom: On
    - Zoom buttons: Off
    - Lasso button: Off
  - Set the Location field to the Geography hierarchy and the Bubble size field to ProfitYTD.

- **Added Slicer:**
  - Positioned a slicer above the map for selecting countries.
  - Configured the slicer:
    - Field: Stores[Country]
    - Style: Tile
    - Selection settings: Multi-select with Ctrl/Cmd and Show "Select All".

- **Visual Configuration:**
  - Set the map visual style and ensured that Show Labels was set to On.

- **Screenshot:**
  ![Stores Map Page](C:\Users\Suado\Desktop\PowerBI\Screenshots\Stores Map Page.png)

### 2. Drillthrough Page: Stores Drillthrough
- **Page Creation:**
  - Created a new page named "Stores Drillthrough".
  - Set Page type to Drillthrough and configured drillthrough settings.

- **Visuals Added:**
  - **Top 5 Products Table:**
    - Columns: Description, Profit YTD, Total Orders, Total Revenue.
  - **Column Chart:**
    - Displayed Total Orders by product category for the store.
  - **Gauges:**
    - Showed Profit YTD against a profit target of 20% year-on-year growth.
  - **Card Visual:**
    - Displayed the currently selected store.

- **Measures Created:**
  - Profit YTD and Revenue YTD
  - Profit Goal and Revenue Goal (20% increase on the previous year’s YTD)

- **Screenshot:**
  ![Stores Drillthrough Page](C:\Users\Suado\Desktop\PowerBI\Screenshots\Stores Drillthrough Page.png)

### 3. Custom Tooltip Page
- **Tooltip Page Creation:**
  - Created a new page named "Profit Tooltip".
  - Set the page size to Tooltip and added a gauge visual for Profit YTD against the target.

- **Tooltip Configuration:**
  - Set the tooltip of the map visual to display the "Profit Tooltip" page on hover.

- **Screenshot:**
  ![Profit Tooltip](C:\Users\Suado\Desktop\PowerBI\Screenshots\Stores Profit Tooltip.png)

### File Upload
- The latest version of the Power BI .pbix file has been saved and uploaded to the repository.

### Conclusion
This milestone enhances the interactivity and detail of the Power BI report, providing better insights into store performance and progress.

---

## Milestone 9: Cross-Filtering and Navigation

### Visual Cross-Filtering Interactions

In this milestone, the following visual cross-filtering interactions were configured:

1. **Executive Summary Page**
   - **Product Category Bar Chart**: Configured not to filter the Card visuals or KPIs.
   - **Top 10 Products Table**: Configured not to filter the Card visuals or KPIs.

2. **Customer Detail Page**
   - **Top 20 Customers Table**: Configured not to filter any other visuals.
   - **Total Customers by Product Donut Chart**: Configured not to affect the Customers Line Graph.
   - **Total Customers by Country Donut Chart**: Configured to cross-filter the Total Customers by Product Donut Chart.

3. **Product Detail Page**
   - **Orders vs. Profitability Scatter Graph**: Configured not to affect any other visuals.
   - **Top 10 Products Table**: Configured not to affect any other visuals.

### Navigation Buttons Setup

Custom navigation buttons were added to each report page to facilitate easy navigation between pages. The following steps were undertaken:

1. **Button Creation and Configuration:**
   - Added blank buttons to the sidebar of each report page.
   - Configured each button to use custom icons:
     - **Default Icon**: White version of the icon.
     - **On Hover Icon**: Cyan version of the icon.
   - Enabled button actions for page navigation, linking to the respective report pages.

2. **Grouping and Copying Buttons:**
   - Grouped buttons on the Executive Summary Page.
   - Copied and pasted the grouped buttons to other report pages, ensuring consistent placement and functionality across the report.

### Screenshots

**Navigation Buttons Configuration:**
![Navigation Buttons Screenshot](C:\Users\Suado\Desktop\PowerBI\Screenshots\Navigation Buttons.png)

---

## Milestone 10: SQL Queries and Data Analysis for Power BI Project
# PostgreSQL Data Analysis Project

## Overview

This project involves connecting to a PostgreSQL database hosted on Microsoft Azure, querying the database to obtain insights, and exporting the results to CSV files. The project includes setting up your environment, performing various SQL queries, and documenting the results.

## Setup Instructions

### 1. Connect to the PostgreSQL Database

To connect to the PostgreSQL database from VSCode, follow these steps:

1. **Install SQLTools Extension**:
   - Open [Visual Studio Code](https://code.visualstudio.com/).
   - Go to the **Extensions** tab on the left sidebar (or press `Ctrl+Shift+X`).
   - Search for **SQLTools** in the Extensions Marketplace.
   - Install the **SQLTools** extension.

2. **Install SQLTools PostgreSQL Driver**:
   - Press `Ctrl+Shift+P` to open the Command Palette.
   - Type **SQLTools: Install Drivers** and select it.
   - Choose **PostgreSQL/Redshift** from the list and install it.

3. **Connect to the Database**:
   - Click on the SQLTools icon in the Activity Bar on the left.
   - Click **+ (Add New Connection)**.
   - Choose **PostgreSQL/Redshift** as the driver.

   Enter the following connection details:
   - **Connection Name**: (e.g., `Azure Postgres`)
   - **Server**: `powerbi-data-analytics-server.postgres.database.azure.com`
   - **Port**: `5432`
   - **Database**: `postgres`
   - **Username**: `maya`
   - **Password**: `AiCore127!`
   - **SSL**: Enable SSL encryption.

4. **Test and Save the Connection**:
   - Click **Test Connection** to verify the details.
   - If successful, click **Save**.

   If you encounter issues, click [here to book a call with a support engineer](#).

## Data Extraction and Analysis

### 2. List All Tables and Columns

1. **Print List of Tables**:
   - Run the following SQL query to list all tables:
     ```sql
     SELECT table_name
     FROM information_schema.tables
     WHERE table_schema = 'public';
     ```
   - Save the results to a CSV file named `tables_list.csv`.

2. **Print Columns for Each Table**:
   - To get columns for the `orders` table:
     ```sql
     SELECT column_name
     FROM information_schema.columns
     WHERE table_name = 'orders';
     ```
   - Save the results to a CSV file named `orders_columns.csv`.

   - For all tables, run:
     ```sql
     SELECT table_name, column_name
     FROM information_schema.columns
     WHERE table_schema = 'public'
     ORDER BY table_name, ordinal_position;
     ```
   - Save the results to separate CSV files named after each table (e.g., `table_name_columns.csv`).

   If you need help, click [here to book a call with a support engineer](#).

### 3. SQL Queries for Data Analysis

1. **How Many Staff Are There in All of the UK Stores?**
   - **SQL Query**:
     ```sql
     SELECT SUM(CAST("staff numbers" AS INTEGER)) AS total_staff
FROM dim_stores
WHERE "country_code" = 'GB'
AND "staff numbers" IS NOT NULL;
     ```
   - **Export Result**: Save the result to `question_1.csv`.
   - **Save Query**: Save the query to `question_1.sql`.

2. **Which Month in 2022 Had the Highest Revenue?**
   - **SQL Query**:
     ```sql
   SELECT 
    DATE_TRUNC('month', "Order Date"::DATE) AS month,  -- Truncate to month, cast to DATE if necessary
    COUNT(*) AS total_revenue                          -- Use COUNT as a proxy if revenue column is missing
FROM orders_powerbi
WHERE EXTRACT(YEAR FROM "Order Date"::DATE) = 2022   -- Extract the year, cast to DATE if necessary
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 1;
     ```
   - **Export Result**: Save the result to `question_2.csv`.
   - **Save Query**: Save the query to `question_2.sql`.

3. **Which German Store Type Had the Highest Revenue for 2022?**
   - **SQL Query**:
     ```sql
   -- Query to find the German store type with the highest revenue for 2022
SELECT
    ds.store_type,
    SUM(ss.total_sales) AS total_revenue
FROM store_sales_summary ss
JOIN dim_stores ds
    ON ds.store_type = ss.store_type  -- Join on store_type
WHERE ds.country_code = 'DE'  -- Filter for Germany
  AND ds.date_opened BETWEEN '2022-01-01' AND '2022-12-31'  -- Adjust if date_opened is in dim_stores
GROUP BY ds.store_type
ORDER BY total_revenue DESC
LIMIT 1;
     ```
   - **Export Result**: Save the result to `question_3.csv`.
   - **Save Query**: Save the query to `question_3.sql`.

4. **Create a View for Store Sales Summary**
   - **SQL Query**:
     ```sql
    CREATE VIEW store_type_summary AS
WITH total_sales_summary AS (
    SELECT
        store_type,
        SUM(total_sales) AS total_sales,
        COUNT(*) AS orders_count
    FROM store_sales_summary
    GROUP BY store_type
),
overall_totals AS (
    SELECT
        SUM(total_sales) AS total_sales
    FROM store_sales_summary
)
SELECT
    t.store_type,
    t.total_sales,
    (t.total_sales / o.total_sales) * 100 AS pct_total_sales,
    t.orders_count
FROM total_sales_summary t
JOIN overall_totals o
ON true;
     ```
   - **Save Query**: Save the view creation statement to `question_4.sql`.

5. **Which Product Category Generated the Most Profit for the "Wiltshire, UK" Region in 2021?**
   - **SQL Query**:
     ```sql
- Query to find the product category with the most profit in Wiltshire, UK for 2021
SELECT 
    p.category AS product_category,
    SUM(
        (op."Product Quantity" * p.sale_price) - (op."Product Quantity" * p.cost_price)
    ) AS total_profit
FROM 
    orders_powerbi op
JOIN 
    dim_products p
    ON op."product_code" = p."product_code"
JOIN 
    dim_stores ds
    ON op."Store Code" = ds."store code"
WHERE 
    ds.country_region = 'Wiltshire' 
    AND ds.country_code = 'GB'
    AND EXTRACT(YEAR FROM TO_DATE(op."Order Date", 'YYYY-MM-DD')) = 2021
GROUP BY 
    p.category
ORDER BY 
    total_profit DESC
LIMIT 1;
     ```
   - **Export Result**: Save the result to `question_5.csv`.
   - **Save Query**: Save the query to `question_5.sql`.

## Files Included

- **CSV Files**:
  - `tables_names.csv`: List of all tables in the database.
  - `orders_columns.csv`: Columns in the `orders` table.
  - `question_1.csv`: Result for the number of staff in UK stores.
  - `question_2.csv`: Result for the highest revenue month in 2022.
  - `question_3.csv`: Result for the highest revenue German store type for 2022.
  - 'question_4.csv' : Result for creating the store sales summary view
  - `question_5.csv`: Result for the most profitable product category in Wiltshire, UK for 2021.

- **SQL Files**:
  - `question_1.sql`: SQL query for the number of staff in UK stores.
  - `question_2.sql`: SQL query for the highest revenue month in 2022.
  - `question_3.sql`: SQL query for the highest revenue German store type for 2022.
  - `question_4.sql`: SQL query for creating the store sales summary view.
  - `question_5.sql`: SQL query for the most profitable product category in Wiltshire, UK for 2021.
