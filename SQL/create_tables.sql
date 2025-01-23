
CREATE TABLE Instruments (
    InstrumentId INT PRIMARY KEY, 
    DisplaySymbol VARCHAR(65) NOT NULL, 
    Currency VARCHAR(3) NOT NULL, 
    PrimaryExchange VARCHAR(4) NOT NULL, 
    HandleValue DECIMAL(18, 10) NOT NULL
);

CREATE TABLE Accounts (
    AccountId INT PRIMARY KEY, 
    AccountName VARCHAR(32) NOT NULL
);

CREATE TABLE Exchanges (
    ExchangeId INT PRIMARY KEY, 
    MIC VARCHAR(4) NOT NULL, 
    CC VARCHAR(2) NOT NULL, 
    Name VARCHAR(128) NOT NULL
);

CREATE TABLE Traders (
    TraderId INT PRIMARY KEY, 
    Username VARCHAR(32) NOT NULL, 
    Team VARCHAR(32) NOT NULL
);



CREATE TABLE Fills (
    FillId INT PRIMARY KEY, 
    InstrumentId INT NOT NULL, 
    AccountId INT NOT NULL, 
    TraderId INT NOT NULL, 
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Side VARCHAR(1) CHECK (Side IN ('B', 'S')),
    Price DECIMAL(18, 10) NOT NULL,
    ExchangeId INT NOT NULL,
    FillTime DATETIME2(7) NOT NULL,
    ExchangeFillId VARCHAR(65) NOT NULL,
	CONSTRAINT FK_Fills_Instrument FOREIGN KEY (InstrumentId) REFERENCES Instruments(InstrumentId),
    CONSTRAINT FK_Fills_Account FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId),
    CONSTRAINT FK_Fills_Trader FOREIGN KEY (TraderId) REFERENCES Traders(TraderId),
    CONSTRAINT FK_Fills_Exchange FOREIGN KEY (ExchangeId) REFERENCES Exchanges(ExchangeId)
);

CREATE TABLE EodPositions (
    TradeDate DATE NOT NULL, 
    InstrumentId INT NOT NULL, 
    AccountId INT NOT NULL, 
    Quantity INT NOT NULL,
    Mark DECIMAL(18, 10) NOT NULL,
    PRIMARY KEY (TradeDate, InstrumentId, AccountId),
    CONSTRAINT FK_EodPositions_Instrument FOREIGN KEY (InstrumentId) REFERENCES Instruments(InstrumentId),
    CONSTRAINT FK_EodPositions_Account FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId),
);

