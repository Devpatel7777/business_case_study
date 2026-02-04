CREATE DATABASE SkyRoutes;
USE SkyRoutes;

CREATE TABLE AirlineRoutesData (
    FlightID VARCHAR(10) PRIMARY KEY,
    RouteCode VARCHAR(20),
    Origin VARCHAR(50),
    Destination VARCHAR(50),
    OriginCountry VARCHAR(50),
    DestinationCountry VARCHAR(50),
    FlightDate DATE,
    FlightDurationMins INT,
    AircraftType VARCHAR(20),
    SeatsAvailable INT,
    SeatsSold INT,
    Revenue BIGINT,
    OperationalCost BIGINT
);

SELECT COUNT(*) FROM AirlineRoutesData;
SELECT * FROM AirlineRoutesData LIMIT 10;

-- 1 Top 10 most frequent routes

SELECT RouteCode, COUNT(*)  FROM AirlineRoutesData GROUP BY RouteCode ORDER BY COUNT(*) DESC LIMIT 10;

-- 2 Average revenue, cost & profit per route

SELECT RouteCode, AVG(Revenue), AVG(OperationalCost), AVG(Revenue - OperationalCost) FROM AirlineRoutesData GROUP BY RouteCode; 

-- 3 Underperforming routes (loss routes)

SELECT RouteCode, AVG(Revenue - OperationalCost) FROM AirlineRoutesData GROUP BY RouteCode HAVING AVG(Revenue - OperationalCost) < 0;

-- 4 Seat occupancy % per route

SELECT RouteCode, (SUM(SeatsSold) * 100 / SUM(SeatsAvailable)) FROM AirlineRoutesData GROUP BY RouteCode;

-- 5 Monthly profit trend per route

SELECT RouteCode, MONTH(FlightDate), SUM(Revenue - OperationalCost) FROM AirlineRoutesData GROUP BY RouteCode, MONTH(FlightDate);  

-- 6 Domestic vs International profitability

SELECT
    CASE
        WHEN OriginCountry = DestinationCountry THEN 'Domestic'
        ELSE 'International'
    END AS RouteType,
    ROUND(AVG(Revenue - OperationalCost), 2) AS AvgProfit
FROM AirlineRoutesData
GROUP BY RouteType;

-- 7 Revenue per minute (route ranking)
SELECT 
    RouteCode,
    ROUND(SUM(Revenue) / SUM(FlightDurationMins), 2) AS RevenuePerMinute
FROM AirlineRoutesData
GROUP BY RouteCode
ORDER BY RevenuePerMinute DESC;
