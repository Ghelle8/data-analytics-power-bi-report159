# data-analytics-power-bi-report159

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

## Project Milestone 3

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

## Project Milestone 4

### Report Pages Setup and Color Theme

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

## Project Milestone 5 

### Executive Summary Page
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

#### Screenshots
![Executive Summary Page](path/to/executive_summary_screenshot.png)
![Donut Chart](path/to/donut_chart_screenshot.png)
![Column Chart](path/to/column_chart_screenshot.png)
![Line Chart](path/to/line_chart_screenshot.png)
![Top Customer Table](path/to/top_customer_table_screenshot.png)
![Top Customer Card Visuals](path/to/top_customer_card_visuals_screenshot.png)

### Date Slicer
- Added a date slicer for filtering by year with the "Between" slicer style.

#### Screenshot
![Date Slicer](path/to/date_slicer_screenshot.png)

# Project Milestone 6: Executive Summary Page Enhancements

## Overview

In this milestone, we enhanced the Executive Summary page by adding and configuring several key visuals. The updates provide a comprehensive overview of key metrics, trends, and targets.

## 1. Card Visuals

- **Total Revenue, Total Orders, and Total Profit Cards:**
  - **Visuals Created:** Added three card visuals to display `Total Revenue`, `Total Orders`, and `Total Profit`.
  - **Formatting:**
    - **Total Revenue:** Displayed to 2 decimal places.
    - **Total Orders:** Displayed to 1 decimal place.
    - **Total Profit:** Displayed to 2 decimal places.
  - **Arrangement:** Positioned the cards to span approximately half of the page width.

  **Screenshot of Card Visuals:**
  ![Card Visuals](path/to/card_visuals_screenshot.png)

## 2. Line Chart

- **Revenue Over Time Line Chart:**
  - **Configuration:**
    - **X-Axis:** Set to `Date Hierarchy` with only `Start of Year`, `Start of Quarter`, and `Start of Month` levels displayed.
    - **Y-Axis:** Set to `Total Revenue`.
  - **Positioning:** Placed the line chart just below the card visuals.

  **Screenshot of Line Chart:**
  ![Line Chart](path/to/line_chart_screenshot.png)

## 3. Donut Charts

- **Revenue by Store Country and Store Type:**
  - **Configuration:**
    - **First Donut Chart:** Shows `Total Revenue` broken down by `Store[Country]`.
    - **Second Donut Chart:** Shows `Total Revenue` broken down by `Store[Store Type]`.
  - **Positioning:** Placed to the right of the cards along the top of the page.

  **Screenshot of Donut Charts:**
  ![Donut Charts](path/to/donut_charts_screenshot.png)

## 4. Bar Chart

- **Orders by Product Category:**
  - **Configuration:**
    - **Visual Type:** Converted from a donut chart to a clustered bar chart.
    - **X-Axis:** Set to `Total Orders`.
  - **Formatting:** Applied colors consistent with the report theme.

  **Screenshot of Bar Chart:**
  ![Bar Chart](path/to/bar_chart_screenshot.png)

## 5. KPI Visuals

- **Quarterly Revenue, Orders, and Profit KPIs:**
  - **KPIs Created:**
    - **Revenue KPI:** Displays `Total Revenue`, trends over `Start of Quarter`, and targets `Target Revenue`.
    - **Profit KPI:** Displays `Total Profit`, trends over `Start of Quarter`, and targets `Target Profit`.
    - **Orders KPI:** Displays `Total Orders`, trends over `Start of Quarter`, and targets `Target Orders`.
  - **Formatting:**
    - **Trend Axis:** Set to `On` with `High is Good` direction, `Red` for bad color, and `15%` transparency.
    - **Callout Value:** Set to 1 decimal place.

  **Screenshot of KPIs:**
  ![KPI Visuals](path/to/kpi_visuals_screenshot.png)

## 6. Final Page Layout

- **Completed Layout:**
  - The Executive Summary page now includes a combination of card visuals, line chart, donut charts, bar chart, and KPIs arranged to provide a clear and insightful overview of key metrics.

  **Screenshot of Completed Page:**
  ![Completed Page](path/to/completed_page_screenshot.png)

## 7. Power BI File

- **Latest Power BI .pbix File:** [Download the latest Power BI .pbix file](path/to/PowerBI_Project_Latest.pbix)

  # Power BI Report Design - Milestones 7 through 12

## Milestone 7: Adding KPI Gauges

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

## Adding Filter State Cards

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

## Adding an Area Chart

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

## Adding a Top 10 Products Table

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

## Creating a Scatter Chart for Product Performance

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

## Creating a Pop-Out Slicer Toolbar

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

