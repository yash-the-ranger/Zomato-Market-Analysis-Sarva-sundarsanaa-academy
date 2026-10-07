CREATE DATABASE IF NOT EXISTS zomato_market_analysis;
USE zomato_market_analysis;


-- 1. Price Segment Distribution
SELECT
    `Price Segment`,
    COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY `Price Segment`
ORDER BY restaurant_count DESC;


-- 2. Average Rating by Price Segment
SELECT
    `Price Segment`,
    ROUND(AVG(`Aggregate rating`), 2) AS avg_rating
FROM restaurants
GROUP BY `Price Segment`
ORDER BY avg_rating DESC;


-- 3. Online Delivery Adoption by Price Segment
SELECT
    `Price Segment`,
    COUNT(*) AS total_restaurants,
    SUM(`Has Online delivery` = 'Yes') AS online_delivery_restaurants,
    ROUND(
        SUM(`Has Online delivery` = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS adoption_percent
FROM restaurants
GROUP BY `Price Segment`
ORDER BY adoption_percent DESC;


-- 4. Service Segment Performance
SELECT
    `Service Segment`,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(`Aggregate rating`), 2) AS avg_rating,
    ROUND(AVG(Votes), 0) AS avg_votes
FROM restaurants
GROUP BY `Service Segment`
ORDER BY restaurant_count DESC;


-- 5. City Performance
CREATE OR REPLACE VIEW city_performance AS
SELECT
    City,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(`Aggregate rating`), 2) AS avg_rating,
    ROUND(AVG(Votes), 0) AS avg_votes
FROM restaurants
GROUP BY City
HAVING COUNT(*) >= 50;


-- 6. Cuisine Performance
CREATE OR REPLACE VIEW cuisine_performance AS
SELECT
    `Primary Cuisine`,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(`Aggregate rating`), 2) AS avg_rating,
    ROUND(AVG(Votes), 0) AS avg_votes
FROM restaurants
GROUP BY `Primary Cuisine`
HAVING COUNT(*) >= 50;


-- 7. Market Opportunity by Price Segment
CREATE OR REPLACE VIEW market_opportunity AS
SELECT
    `Price Segment`,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(Votes), 0) AS avg_votes,
    ROUND(AVG(`Aggregate rating`), 2) AS avg_rating,
    ROUND(
        SUM(`Has Online delivery` = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS online_delivery_percent
FROM restaurants
GROUP BY `Price Segment`;


8. High-Opportunity Cuisine Candidates
SELECT
    `Primary Cuisine`,
    restaurant_count,
    avg_rating,
    avg_votes
FROM cuisine_performance
WHERE avg_rating >= 3.5
  AND avg_votes >= 200
ORDER BY avg_votes DESC;