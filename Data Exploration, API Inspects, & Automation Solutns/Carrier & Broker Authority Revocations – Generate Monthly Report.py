#!/usr/bin/env python

# make sure to install these packages before running:
# pip install pandas
# pip install sodapy
# pip install openpyxl

import pandas as pd
from sodapy import Socrata
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
import os

# Read app token from file
script_dir = os.path.dirname(os.path.abspath(__file__))
token_file = os.path.join(script_dir, 'app_token.txt')
with open(token_file, 'r') as f:
    app_token = f.read().strip()

# Calculate first and last day of previous month
today = datetime.now()
first_day_current_month = today.replace(day=1)
last_day_previous_month = first_day_current_month - timedelta(days=1)
first_day_previous_month = last_day_previous_month.replace(day=1)

# Format dates as MM/DD/YYYY
start_date = first_day_previous_month.strftime('%m/%d/%Y')
end_date = last_day_previous_month.strftime('%m/%d/%Y')

print(f"Fetching revocation data for: {start_date} to {end_date}")

# Create authenticated Socrata client
client = Socrata("data.transportation.gov", app_token)

# Define query parameters
select_clause = "dot_number,docket_number,order2_type_desc,type_license,order1_serve_date,order2_effective_date"
where_clause = f"order2_effective_date >= '{start_date}' AND order2_effective_date <= '{end_date}'"

# Pagination parameters
limit = 1000
offset = 0
all_results = []

# Fetch data with pagination
print("Fetching data from API...")
while True:
    try:
        results = client.get(
            "sa6p-acbp",
            select=select_clause,
            where=where_clause,
            limit=limit,
            offset=offset
        )
        
        if not results:
            break
        
        all_results.extend(results)
        print(f"  Retrieved {len(results)} records (total: {len(all_results)})")
        
        # If we got fewer results than the limit, we've reached the end
        if len(results) < limit:
            break
        
        offset += limit
    except Exception as e:
        print(f"Error fetching data: {e}")
        break

# Close the client
client.close()

print(f"\nTotal records retrieved: {len(all_results)}")

# Convert to pandas DataFrame
if all_results:
    df = pd.DataFrame.from_records(all_results)
    
    # Sort by effective date
    df['order2_effective_date'] = pd.to_datetime(df['order2_effective_date'])
    df = df.sort_values('order2_effective_date')
    
    # Format the date column for display
    df['order2_effective_date'] = df['order2_effective_date'].dt.strftime('%m/%d/%Y')
    if 'order1_serve_date' in df.columns:
        df['order1_serve_date'] = pd.to_datetime(df['order1_serve_date'], errors='coerce')
        df['order1_serve_date'] = df['order1_serve_date'].dt.strftime('%m/%d/%Y')
    
    # Write to Excel with formatting
    output_file = os.path.join(os.path.dirname(script_dir), 'Generated Report.xlsx')
    
    print(f"\nWriting data to Excel: {output_file}")
    
    with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Revocations', index=False, startrow=0)
        
        # Get the workbook and worksheet
        workbook = writer.book
        worksheet = writer.sheets['Revocations']
        
        # Create a table
        from openpyxl.worksheet.table import Table, TableStyleInfo
        
        # Define table range
        max_row = len(df) + 1
        max_col = len(df.columns)
        table_ref = f"A1:{chr(64 + max_col)}{max_row}"
        
        # Create table
        tab = Table(displayName="RevocationsTable", ref=table_ref)
        
        # Add a table style
        style = TableStyleInfo(
            name="TableStyleMedium2",
            showFirstColumn=False,
            showLastColumn=False,
            showRowStripes=True,
            showColumnStripes=False
        )
        tab.tableStyleInfo = style
        
        # Add the table to the worksheet
        worksheet.add_table(tab)
        
        # Auto-adjust column widths
        for column in worksheet.columns:
            max_length = 0
            column_letter = column[0].column_letter
            for cell in column:
                try:
                    if cell.value:
                        max_length = max(max_length, len(str(cell.value)))
                except:
                    pass
            adjusted_width = min(max_length + 2, 50)
            worksheet.column_dimensions[column_letter].width = adjusted_width
    
    print(f"✓ Excel report generated successfully!")
    print(f"  File: {output_file}")
    print(f"  Records: {len(df)}")
else:
    print("\nNo data found for the specified date range.")
