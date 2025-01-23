SELECT 
    a.AccountName,
    i.DisplaySymbol,
    SUM(CASE WHEN f.Side = 'B' THEN f.Quantity ELSE 0 END) AS BuyQuantity, --If no price set to 0 to avoid NULLs
    AVG(CASE WHEN f.Side = 'B' THEN f.Price END) AS BuyAveragePrice,
    SUM(CASE WHEN f.Side = 'S' THEN f.Quantity ELSE 0 END) AS SellQuantity,
    AVG(CASE WHEN f.Side = 'S' THEN f.Price END) AS SellAveragePrice,
    t.Team
FROM 
    Fills f
JOIN 
    Accounts a ON f.AccountId = a.AccountId
JOIN 
    Instruments i ON f.InstrumentId = i.InstrumentId
JOIN 
    Traders t ON f.TraderId = t.TraderId
GROUP BY 
    a.AccountName, i.DisplaySymbol, t.Team
ORDER BY 
    t.Team DESC,
    i.DisplaySymbol DESC;