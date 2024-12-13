-- Table bill consists customerID, InvoiceNo and total amount spent by each customer per invoice.
WITH bill AS
  (
    SELECT customerID, InvoiceNo, SUM(Quantity * UnitPrice) AS total_spent
    FROM sales
    GROUP BY InvoiceNo, customerID
  )
  
-- To calculate frequency, we need to determine the number of purchases (invoices) made by each customer during their active period. The active period for each customer is defined as the time between their first purchase date and their most recent purchase date.
-- After executing the query provided below, we create a new table that includes the following columns: customer ID, number of purchases, total amount spent by each customer, the most recent purchase date, the first purchase date, the period of activity, and recency (the number of days since the last purchase). For this analysis, I used '2013-01-01' as the reference date.
  
WITH saleDetails AS( 
SELECT tbl1.customerID, tbl1.no_of_purchases, ROUND(tbl1.total, 2) AS total, tbl2.recent_date, tbl2.first_purchase_date, DATE_DIFF(tbl2.recent_date, tbl2.first_purchase_date, MONTH) AS time_period, DATE_DIFF('2013-01-01', tbl2.recent_date, DAY) AS recency
FROM
(SELECT customerID, COUNT(InvoiceNo) AS no_of_purchases, SUM(total_spent) as total
FROM `Sales.bill`
GROUP BY customerID)tbl1 
JOIN (SELECT customerID, DATE(MAX(InvoiceDate)) AS recent_date, DATE(MIN(InvoiceDate)) AS first_purchase_date
      FROM `Sales.sales`
    GROUP BY customerID)tbl2
ON tbl1.customerID = tbl2.customerID)

-- Calculating percentiles over total, frequency (no_of_purchases/IF(time_period = 0, 1, time_period), and recency columns
WITH Resultant AS(
SELECT customerID, first_purchase_date, recent_date, no_of_purchases, total, ROUND(CUME_DIST() OVER(ORDER BY total ASC) * 100, 2) AS monetary_percentile, ROUND(CUME_DIST() OVER(ORDER BY (no_of_purchases/IF(time_period = 0, 1, time_period)) ASC) *100, 2) AS frequency_percentile, ROUND(CUME_DIST() OVER(ORDER BY recency DESC) * 100, 2) AS recency_percentile
FROM `Sales.saleDetails`)
  
--Create m_rank, f_rank, and r_rank columns that contain ranks based on the monetary_percentile, frequency_percentile, and recency_percentile, respectively. fm_rank is the average of f_rank and m_rank.
WITH customerSegmentation AS(
SELECT customerID, m_rank, f_rank, r_rank, CAST(ROUND((f_rank + m_rank)/2, 0) AS INT64) AS fm_rank
FROM(
SELECT *, 
        CASE  WHEN  monetary_percentile < 20 THEN 1
              WHEN  monetary_percentile < 40 THEN 2
              WHEN  monetary_percentile < 60 THEN 3
              WHEN  monetary_percentile < 80 THEN 4
              WHEN  monetary_percentile <= 100 THEN 5 END AS m_rank,
        CASE  WHEN  frequency_percentile < 20 THEN 1
              WHEN  frequency_percentile < 40 THEN 2
              WHEN  frequency_percentile < 60 THEN 3
              WHEN  frequency_percentile < 80 THEN 4
              WHEN  frequency_percentile <= 100 THEN 5 END AS f_rank,
        CASE  WHEN  recency_percentile < 20 THEN 1
              WHEN  recency_percentile < 40 THEN 2
              WHEN  recency_percentile < 60 THEN 3
              WHEN  recency_percentile < 80 THEN 4
              WHEN  recency_percentile <= 100 THEN 5 END AS r_rank
FROM `Sales.Resultant`) tbl)
  
-- Assign labels based on the r_rank and fm_rank. The resultant table includes columns: customerID, r_rank, fm_rank, customer_segmentation.
SELECT customerID, r_rank, fm_rank,
      CASE WHEN (r_rank = 5 AND fm_rank = 1) THEN 'Price sensitive'
           WHEN (r_rank = 5 AND fm_rank = 2) THEN 'Recent users'
           WHEN (r_rank = 4 AND fm_rank = 1) THEN 'Promising'
           WHEN (r_rank = 4 AND fm_rank = 2) OR (r_rank = 4 AND fm_rank = 3) OR (r_rank = 5 AND fm_rank = 2) OR (r_rank = 5 AND fm_rank = 3) THEN 'Potential loyalist'
           WHEN (r_rank = 5 AND fm_rank = 4) OR (r_rank = 5 AND fm_rank = 5) THEN 'Champions'
           WHEN (r_rank = 3 AND fm_rank = 4) OR (r_rank = 3 AND fm_rank = 5) OR (r_rank = 4 AND fm_rank = 4) OR (r_rank = 4 AND fm_rank = 5) THEN 'Loyal customers'
           WHEN (r_rank = 3 AND fm_rank = 3) THEN 'Needs attention'
           WHEN (r_rank = 1 AND fm_rank = 1) OR (r_rank = 1 AND fm_rank = 2) OR (r_rank = 2 AND fm_rank = 1) OR (r_rank = 2 AND fm_rank = 2) THEN 'Lost'
           WHEN (r_rank = 1 AND fm_rank = 3) OR (r_rank = 1 AND fm_rank = 4) OR (r_rank = 2 AND fm_rank = 3) OR (r_rank = 2 AND fm_rank = 4) THEN 'Hibernating'
           WHEN (r_rank = 1 AND fm_rank = 5) OR (r_rank = 2 AND fm_rank = 5) THEN 'Cannot lose them'
           WHEN (r_rank = 3 AND fm_rank = 1) OR (r_rank = 3 AND fm_rank = 2) THEN 'About to sleep'
        END AS customer_segmentation
FROM `Sales.customerSegmentation`







