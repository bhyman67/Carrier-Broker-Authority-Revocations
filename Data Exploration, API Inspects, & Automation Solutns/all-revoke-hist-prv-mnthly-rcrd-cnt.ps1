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

# Query - Get record count for previous month using order1_serve_date
$query = "SELECT COUNT(*) WHERE ``order1_serve_date`` >= '$startDate' AND ``order1_serve_date`` <= '$endDate'"

$url = "https://data.transportation.gov/api/v3/views/$apiId/query.json?pageNumber=1&pageSize=500&app_token=$appToken&query=$query"
Invoke-WebRequest -Uri $url