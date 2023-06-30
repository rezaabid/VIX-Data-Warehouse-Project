CREATE PROCEDURE dbo.summary_order_status
(
	@StatusID int
)
AS
BEGIN
	SELECT FSO.OrderID, DC.CustomerName, DP.ProductName, FSO.Quantity, DSO.StatusOrder
	FROM FactSalesOrder FSO
	INNER JOIN DimCustomer DC ON FSO.CustomerID = DC.CustomerID
	INNER JOIN DimProduct DP ON FSO.ProductID = DP.ProductID
	INNER JOIN DimStatusOrder DSO ON FSO.StatusID = DSO.StatusID
	WHERE DSO.StatusID = @StatusID;
END;

EXEC dbo.summary_order_status @StatusID = 1;

