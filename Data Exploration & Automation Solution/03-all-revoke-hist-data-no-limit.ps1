
# ###############################################################################################

# Script to retrieve FMCSA Revocations History data for the previous month without record limits

# - looks like the limit is 1,000 records per page. 
# - Socrata metadata fields are excluded (:id, :version, :created_at, :updated_at).

# ###############################################################################################

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
#$select = "docket_number,dot_number,type_license,order1_serve_date,order2_type_desc"
$select = "*"
#$where = "order1_serve_date >= '$startDate' AND order1_serve_date <= '$endDate'"
$where = "1=1"  # No date filter to get all records

$url = "https://data.transportation.gov/resource/$apiId.json?`$select=$select&`$where=$where&`$`$app_token=$appToken"

$response = Invoke-RestMethod -Uri $url -Method Get

# Display results
Write-Host "`nTotal records retrieved: $($response.Count)" -ForegroundColor Cyan

# Export to CSV
$csvPath = "$PSScriptRoot\revocations_history_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$response | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "`nData exported to: $csvPath" -ForegroundColor Green

# Create browser-friendly URL with proper encoding
$browserUrl = "https://data.transportation.gov/resource/$apiId.json?`$select=$([System.Uri]::EscapeDataString($select))&`$where=$([System.Uri]::EscapeDataString($where))&`$`$app_token=$appToken"
Write-Host "`nBrowser-friendly URL: $browserUrl" -ForegroundColor Yellow