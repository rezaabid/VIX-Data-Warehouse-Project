# ID/X Partners Data Engineer Virtual Internship Program by Rakamin Academy

## Case study:

One of the clients from ID/X Partners engaged in the field of e-commerce has a need to create Data
Warehouse derived from multiple tables from the source database. This Data Warehouse will later consist of one Fact table and multiple Dimension tables.

## Tasks that need to be done:

### 1. Import/restore the Staging database

To restore the Staging database can be done using the SQL Server Management Studio (SSMS) application with the following steps:

1. Right-click the **Databases** node in **Object Explorer** and select **Restore Database...**.
2. Select **Device:**, then select ellipses (...) to locate the backup file.
3. Select **Add** and navigate to where the .bak file is located, in this case `Staging.bak`. Select the .bak file then select **OK**.
4. Select **OK** to close the **Select backup devices** dialog box.
5. Select **OK** to restore the Staging database.

The following is the Staging database schema:

<div align="center"><img src="https://drive.google.com/uc?export=view&id=12wtje7-s1769VsSrkNEy3_BiylL6MazS"></div>

### 2. Create a database named DWH_Project, and create Fact and Dimension tables from the tables in the Staging database

Creating a database with the name DWH_Project can be done in the SQL Server Management Studio (SSMS) application with the following steps:

1. Right-click the **Databases** node in **Object Explorer** and select **New Database**.
2. Enter the database name, namely DWH_Project, in the **Database name:** section then select **OK**.

Meanwhile, table creation for the DWH_Project database is done by the following steps:
1. Expand the **Databases** node in **Object Explorer**.
2. Expand the **DWH_project** database.
3. Right-click the **Tables** node and select **New Table**.
4. Specify the features or table columns that you want to create.
5. Click **Save *table name*** on the **File** menu.
6. Specify the name of the table created in the **Choose Name** dialog box then select **OK**.

Determination of table names and table column names for the DWH_Project database adapts from the Staging database with some adjustments. For the Dimension table, the name "Dim" is given to the table name prefix, while the Fact table is given the name "Fact" to the table name prefix. Then for naming table columns, do not use underscore and are written using Pascal Case.

The following is the schema of the DWH_Project database:

<div align="center"><img src="https://drive.google.com/uc?export=view&id=1sw15UIyUNA833oInyu9ohJ3CbRsFVTOl"></div><br>

Note that in the `DimCustomer` table, there is a `CustomerName` column and no `FirstName` or `LastName` columns. This is because in the next process, a data transformation is performed by converting the data in the `FirstName` and `LastName` columns to uppercase and combining them into only one column, `CustomerName`.

### 3. Create an ETL job in the Talend application to migrate data from Staging to Data Warehouse, and perform transformations for the DimCustomer table

In migrating and transforming data from the Staging database to the DWH_Project database, it is done by using the Talend Open Studio for Data Integration application. The migration and transformation process can be realized by creating a Job. Job creation in the Talend application can be done with the following steps:

1. Right-click the **Job Designs** node in **Repository** and select **Create Job**. 
2. In the **New Job** dialog box, fill in the name, purpose, and description of the Job to be created. In this case, it is to migrate and transform data. Then select **Finish**.
3. Drag and drop components such as `tMSSqlInput`, `tMSSqlOutput`, and `tMap` from the **Palette** to create the Job flow.
4. Right-click each component, select **Row**, and select **Main** to connect the added components.
5. For the `tMSSqlInput` component, the configuration is done by connecting the `tMSSqlInput` component with the Staging database and querying to retrieve all the data in the database.
6. For the `tMSSqlOutput` component, the configuration is done by connecting the `tMSSqlOutput` component with the DWH_Project database and setting the action to insert data.
7. For the `tMap` component, the transformation process is configured by changing the data in the `first_name` and `last_name` columns from the Staging database to uppercase. Then merge the data from the two columns into the `CustomerName` column in the DWH_project database and select **Ok**.
8. Right-click on the Job that has been created and select **Run Job**.

The following is a view of the Job flow that has been created:

<div align="center"><img src="https://drive.google.com/uc?export=view&id=14wft5a4zKOP3h_ndwVaNdXvL4l_4WLo_"></div>

### 4. Create a Store Procedure (SP) to display summary sales order based on delivery status

One of the clients from ID/X Partners engaged in the field of e-commerce has a need to create Data
Warehouse derived from multiple tables from the source database. This Data Warehouse will later consist of one Fact table and multiple Dimension tables.
