
# #######################################################################################

# Data preview with column subset for FMCSA Revocations History API (printed to terminal)

# At this point, based off what I was seeing (and didn't see :)) in the socrata API  
# exploerer, I thought I needed to filter on the order1_serve_date field to get data for 
# the previous month. I didn't realize that I needed to look for (and use) the 
# effective_date until I had the Q&A with Chris. 

# https://dev.socrata.com/foundry/data.transportation.gov/sa6p-acbp

# #######################################################################################

# Read app token and API IDs from files
$appToken = Get-Content -Path "$PSScriptRoot\app_token.txt" -Raw | ForEach-Object { $_.Trim() }
$apiIds = Get-Content -Path "$PSScriptRoot\fmcsa_api_ids.json" -Raw | ConvertFrom-Json

# Select API to inspect (FMCSA Revocations History or FMCSA Authority History):
$apiId = $apiIds.'FMCSA Revocations History' 

# Calculate previous month date range
$today = Get-Date
$firstDayOfCurrentMonth = Get-Date $today -Day 1
$lastDayOfPreviousMonth = $firstDayOfCurrentMonth.AddDays(-1)
$firstDayOfPreviousMonth = Get-Date $lastDayOfPreviousMonth -Day 1

$startDate = $firstDayOfPreviousMonth.ToString("MM/dd/yyyy")
$endDate = $lastDayOfPreviousMonth.ToString("MM/dd/yyyy")

Write-Host "Querying for period: $startDate to $endDate"

# Query - Get data for previous month with selected columns
$select = "docket_number,dot_number,type_license,order1_serve_date,order2_type_desc"
$where = "order1_serve_date >= '$startDate' AND order1_serve_date <= '$endDate'"

$url = "https://data.transportation.gov/resource/$apiId.json?`$select=$select&`$where=$where&`$limit=100&`$`$app_token=$appToken"

$response = Invoke-RestMethod -Uri $url -Method Get

# Display results
Write-Host "`nTotal records retrieved: $($response.Count)" -ForegroundColor Cyan
Write-Host "`nSample data:" -ForegroundColor Green
$response | ConvertTo-Json -Depth 5

# Create browser-friendly URL with proper encoding
$browserUrl = "https://data.transportation.gov/resource/$apiId.json?`$select=$([System.Uri]::EscapeDataString($select))&`$where=$([System.Uri]::EscapeDataString($where))&`$limit=100&`$`$app_token=$appToken"
Write-Host "Browser-friendly URL: $browserUrl" -ForegroundColor Yellow