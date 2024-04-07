## Slowly Changing Dimension (Example - Product Dimension)

# Overview
Slowly Changing Dimension (SCD) is a common technique used in data warehousing to manage changes to dimension data over time. In this example, we focus on a Product dimension table and implement three levels of SCD:

* Level 0: No change tracking. ProductName and Brand attributes.
* Level 1: Tracking updates. OutOfStock and Url attributes.
* Level 2: Tracking changes and preserving history. Price attribute.
  
The implementation includes the creation of staging and dimension tables, as well as the loading of data into these tables. Additionally, a stored procedure named SlowlyChangeDimension_Product is provided to demonstrate how to apply SCD techniques in practice.

** Scripts
1. Product Script
   
   Purpose: Creates the Dim and Stage schemas, Product and Stage_Product tables, and loads data into Product and Stage_Product tables.
   File: Product.sql

2. InsertToStage Script
   
   Purpose: Test script to update staged table for testing stored procedures.
   File: InsertToStage.sql

3. StoredProcedure Script
   
   Purpose: Creates a stored procedure (SlowlyChangeDimension_Product) to apply SCD techniques to the Product dimension.
   File: StoredProcedureScript.sql

# Usage
Execute the ProductScript.sql to create the necessary schemas and tables and load data into them.
Use the InsertToStage.sql script for testing by updating the staged table.
Execute the StoredProcedureScript.sql to create the stored procedure for applying SCD techniques.
exec the SlowlyChangeDimension_Product stored procedure to manage changes to the Product dimension table.
