

Serve Date (order1_serve_date): The date when the revocation notice/order was officially served/delivered to the carrier or broker. This is when they were notified that their authority would be revoked.

Effective Date (order2_effective_date): The date when the revocation actually takes effect and the company can no longer legally operate.

Looks like there's typically about a 30-35 day gap (e.g., served 12/01/2025, effective 01/05/2026). This gives companies time to wind down operations, notify customers, and potentially resolve the issues that led to the revocation.

https://mobile.fmcsa.dot.gov/QCDevsite/ 

note on the powershell 




Please generate Python code that'll pull data from the Revocation - All With History api. Here's the endpoint: https://data.transportation.gov/api/v3/views/sa6p-acbp/query.json?pageNumber=1&pageSize=10&app_token=$YOUR_APP_TOKEN

Get the token from app_token.txt.

However, please use the Socrata module from the sodapy lib and pandas. Here's an example:
#!/usr/bin/env python

# make sure to install these packages before running:
# pip install pandas
# pip install sodapy

import pandas as pd
from sodapy import Socrata

# Unauthenticated client only works with public data sets. Note 'None'
# in place of application token, and no username or password:
client = Socrata("data.transportation.gov", None)

# Example authenticated client (needed for non-public datasets):
# client = Socrata(data.transportation.gov,
#                  MyAppToken,
#                  username="user@example.com",
#                  password="AFakePassword")

# First 2000 results, returned as JSON from API / converted to Python list of
# dictionaries by sodapy.
results = client.get("sa6p-acbp", limit=2000)

# Convert to pandas DataFrame
results_df = pd.DataFrame.from_records(results)

Let's add a query to the query string of the request (to subset cols and filter on the effective date):
$select = "dot_number,docket_number,order2_type_desc,type_license,order1_serve_date,order2_effective_date"
$where = "order2_effective_date >= '$startDate' AND order2_effective_date <= '$endDate'"

Before making the API calls, you'll need to determine (and set variables for) the date (not datetime) of the first and last day of the previous month. An example format is: 12/31/2025. Parameterize those dates into the request query.

You'll also need to paginate every 1,000 to get the full data.

After that, let's write the dataset to Excel nicely formatted in an Excel data table. Let's call the workbook Generated Report.xlsx (for now) and save it to the parent directory.