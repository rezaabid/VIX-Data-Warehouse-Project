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

Store Procedure to display summary sales order based on delivery status is done by writing SQL query in SQL Server Management Studio (SSMS) application. This can be done by right-clicking the DWH_Project database on the **Databases** node and selecting **New Query**.

The syntax of Store Procedure `summary_order_status` is as follows:

```sql
CREATE PROCEDURE dbo.summary_order_status
(
	@StatusID int
)
AS
BEGIN
	SELECT FSO.OrderID, DC.CustomerName, DP.ProductName, FSO.Quantity, DSO.StatusOrder
	FROM FactSalesOrder FSO
	JOIN DimCustomer DC ON FSO.CustomerID = DC.CustomerID
	JOIN DimProduct DP ON FSO.ProductID = DP.ProductID
	JOIN DimStatusOrder DSO ON FSO.StatusID = DSO.StatusID
	WHERE DSO.StatusID = @StatusID;
END;
```

The summary sales order for delivery status "Awaiting Payment" or `StatusID = 1` is obtained by executing the following syntax:

 ```sql
EXEC dbo.summary_order_status @StatusID = 1;
```

With the results as follows:

| OrderID | CustomerName | ProductName | Quantity | StatusOrder |
|---------|--------------|-------------|----------|-------------|
| 1303 | BUDISANTOSO | Macbook Air 2020 13 inch | 1 | Awaiting Payment |
| 1310 | LIARAHMAWATI | Kipas Angin Cosmos | 2 | Awaiting Payment |

The summary sales order for delivery status "Awaiting Shipment" or `StatusID = 2` is obtained by executing the following syntax:

 ```sql
EXEC dbo.summary_order_status @StatusID = 2;
```

With the results as follows:

| OrderID | CustomerName | ProductName | Quantity | StatusOrder |
|---------|--------------|-------------|----------|-------------|
| 1301 | LIARAHMAWATI | Converse Cap Original | 2 | Awaiting Shipment |
| 1304 | AJENGSRIASIH | T-Shirt Polo Nevada | 2 | Awaiting Shipment |
| 1307 | RAHMAAMELIA | Pull & Bear T-Shirt | 1 | Awaiting Shipment |

The summary sales order for delivery status "Shipped" or `StatusID = 3` is obtained by executing the following syntax:

 ```sql
EXEC dbo.summary_order_status @StatusID = 3;
```

With the results as follows:

| OrderID | CustomerName | ProductName | Quantity | StatusOrder |
|---------|--------------|-------------|----------|-------------|
| 1305 | BAGUSPRAKOSO | Blender Philips 500 watt | 3 | Shipped |
| 1308 | BELAADRILIA | Luciana Set Dress 2 in 1 | 2 | Shipped |

The summary sales order for delivery status "Completed" or `StatusID = 4` is obtained by executing the following syntax:

 ```sql
EXEC dbo.summary_order_status @StatusID = 4;
```

With the results as follows:

| OrderID | CustomerName | ProductName | Quantity | StatusOrder |
|---------|--------------|-------------|----------|-------------|
| 1302 | RIFKIMUHAMMAD | HP Elitebook 840 G4 | 1 | Completed |
| 1306 | RIFKIMUHAMMAD | Asus Zenbook 800 | 1 | Completed |
| 1309 | AJENGSRIASIH | Bagpack Navy Club | 1 | Completed |

The summary sales order for delivery status "Cancelled" or `StatusID = 5` is obtained by executing the following syntax:

 ```sql
EXEC dbo.summary_order_status @StatusID = 5;
```

With the results as follows:

| OrderID | CustomerName | ProductName | Quantity | StatusOrder |
|---------|--------------|-------------|----------|-------------|
|  |  |  |  |  |

Note that for delivery status "Cancelled" or `StatusID = 5` does not display the summary sales order. This is because in the `FactSalesOrder` table there are no records worth of 5 for the `StatusID` column or there are no canceled orders.
