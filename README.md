## RFM Analysis(Recency, Frequency, Monetary)
RFM analysis is a marketing technique used to segment customers based on the recency, frequency and monetary total of their recent transactions to identify the best customers and perform targeted marketing campaigns.

RFM ranks each customer on the following factors:
### Recency:
How recent was the customer's last purchase in the eCommerce site? If a customer's last purchase was very recent, it shows they were active on the site. Usually businesses calculate recency in days. 
### Frequency:
How often did this customer make a purchase in a given period? Customers who purchased once are often more likely to purchase again. Additionally, first time customers may be good targets for follow-up advertising to convert them into more frequent customers.
### Monetary:
How much money did the customer spend in a given period? Customers who spend a lot of money are more likely to spend money in the future and have a high value to a business.

### How RFM Analysis is performed
1. Customers receive recency, frequency, and monetary (RFM) scores based on their purchasing patterns, with 5 being the highest score and 1 the lowest. For example, a customer with a recency score of 5 indicates that they made a purchase on our site very recently. The same scoring applies to frequency and monetary scores.

2. In this case study, we followed the steps below to calculate RFM scores:
    
   #### Recency Score:
   We grouped all customers and identified their most recent purchase date. We then calculated percentiles based on these dates. If the calculated percentile falls within the range of [80, 100], the recency score is assigned a value of 5. We continued to calculate the scores accordingly.
   #### Frequency Score:
   We grouped all customers, calculated the period between the first_purchase and the last_purchase dates, and counted the number of invoices. Used the below formula to calculate frequency. We then calculated percentiles based on these frequencies. If the calculated percentile falls within the range of [80, 100], the frequency score is assigned a value of 5. We continued to calculate the scores accordingly.

   frequency = number of invoices/period
   #### Monetary Score:
   We grouped all customers, calculated the total money spent by each customer. We then calculated percentiles based on the total money. If the calculated percentile falls within the range of [80, 100], the recency score is assigned a value of 5. We continued to calculate the scores accordingly.
   
