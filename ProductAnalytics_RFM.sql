WITH bill AS
  (
    SELECT customerID, InvoiceNo, SUM(Quantity * UnitPrice) AS total_spent
    FROM sales
    GROUP BY InvoiceNo, customerID
  )

SELECT customerID, COUNT(InvoiceNo) AS no_of_purchases, SUM(total_spent) as total
FROM bill
GROUP BY customerID
