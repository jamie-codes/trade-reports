INSERT INTO Instruments (InstrumentId, DisplaySymbol, Currency, PrimaryExchange, HandleValue)
VALUES
(1, 'AAPL', 'USD', 'XNAS', 0.01),
(2, 'TSLA', 'USD', 'XNAS', 0.01),
(3, 'MSFT', 'USD', 'XNAS', 0.01),
(4, 'GOOGL', 'USD', 'XNAS', 0.01),
(5, 'AMZN', 'USD', 'XNAS', 0.01),
(6, 'NFLX', 'USD', 'XNAS', 0.01),
(7, 'BABA', 'HKD', 'XHKG', 0.01),
(8, 'TSM', 'TWD', 'XTAI', 0.01);


INSERT INTO Accounts (AccountId, AccountName)
VALUES
(101, 'Alpha Investments'),
(102, 'Beta Holdings'),
(103, 'Gamma Trading'),
(104, 'Delta Capital'),
(105, 'Epsilon Ventures'),
(106, 'Zeta Investments'),
(107, 'Theta Management'),
(108, 'Omega Securities');


INSERT INTO Traders (TraderId, Username, Team)
VALUES
(201, 'jmckee', 'EUCB'),
(202, 'asmith', 'GLPM'),
(203, 'bwhite', 'EUFX'),
(204, 'ckim', 'USTM'),
(205, 'mlee', 'USQM'),
(206, 'mjackson', 'EUQM'),
(207, 'arobinson', 'EUFX'),
(208, 'rgreen', 'GLPM');



INSERT INTO Exchanges (ExchangeId, MIC, CC, Name)
VALUES
(301, 'XNAS', 'US', 'NASDAQ'),
(302, 'XNYS', 'US', 'New York Stock Exchange'),
(303, 'XLON', 'GB', 'London Stock Exchange'),
(304, 'XHKG', 'HK', 'Hong Kong Stock Exchange'),
(305, 'XTAI', 'TW', 'Taiwan Stock Exchange'),
(306, 'XTKS', 'JP', 'Tokyo Stock Exchange'),
(307, 'XFRA', 'DE', 'Frankfurt Stock Exchange'),
(308, 'XNSE', 'IN', 'National Stock Exchange of India');


INSERT INTO Fills (FillId, InstrumentId, AccountId, TraderId, Quantity, Side, Price, ExchangeId, FillTime, ExchangeFillId)
VALUES
(1001, 1, 101, 201, 100, 'B', 150.12, 301, '2023-10-10 14:30:00.1234567', 'EX12345678'),
(1002, 2, 102, 202, 50, 'S', 780.98, 302, '2023-10-10 14:31:00.1234567', 'EX98765432'),
(1003, 3, 103, 203, 200, 'B', 280.54, 303, '2023-10-10 14:32:00.1234567', 'EX87654321'),
(1004, 4, 104, 204, 150, 'B', 2800.87, 301, '2023-10-11 10:15:00.7654321', 'EX12349876'),
(1005, 5, 105, 205, 75, 'S', 3300.56, 302, '2023-10-11 10:16:00.8765432', 'EX23456789'),
(1006, 6, 106, 206, 125, 'B', 500.23, 303, '2023-10-11 10:17:00.9876543', 'EX34567890'),
(1007, 7, 107, 207, 200, 'S', 210.12, 304, '2023-10-11 10:18:00.1234567', 'EX45678901'),
(1008, 8, 108, 208, 300, 'B', 125.56, 305, '2023-10-11 10:19:00.2345678', 'EX56789012');



INSERT INTO EodPositions (TradeDate, InstrumentId, AccountId, Quantity, Mark)
VALUES
('2023-10-10', 1, 101, 100, 151.12),
('2023-10-10', 2, 102, 50, 781.98),
('2023-10-10', 3, 103, 200, 281.54),
('2023-10-11', 4, 104, 150, 2805.76),
('2023-10-11', 5, 105, 75, 3310.87),
('2023-10-11', 6, 106, 125, 505.87),
('2023-10-11', 7, 107, 200, 215.98),
('2023-10-11', 8, 108, 300, 130.87);