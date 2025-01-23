-- Set the date we want the Eod Positions for
DECLARE @date DATETIME = CAST('2023-10-11' AS DATE)

SELECT 
    @date AS TradeDate,  
    f.InstrumentId,
    f.AccountId,
    SUM(CASE WHEN f.Side = 'B' THEN f.Quantity ELSE -f.Quantity END) AS Quantity,  -- Negative quantity for when we have a Sell
    MAX(f.Price) AS Mark   -- value using Eod price, rather than original price of position as we are using MTM
FROM 
    Fills f
WHERE 
    CAST(f.FillTime AS DATE) = @date  -- Filter for the specific trade date
GROUP BY 
    f.InstrumentId, f.AccountId
HAVING 
    SUM(CASE WHEN f.Side = 'B' THEN f.Quantity ELSE -f.Quantity END) <> 0;