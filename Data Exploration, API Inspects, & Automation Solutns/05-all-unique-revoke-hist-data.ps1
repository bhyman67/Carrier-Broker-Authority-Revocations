


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

# Query - Get all data for previous month with pagination
$select = "docket_number,dot_number,type_license,order1_serve_date,order2_type_desc"
$where = "order1_serve_date >= '$startDate' AND order1_serve_date <= '$endDate'"

$allRecords = @()
$limit = 1000
$maxIterations = 10

Write-Host "`nFetching data in batches of $limit records..." -ForegroundColor Yellow

for ($i = 0; $i -lt $maxIterations; $i++) {
    $offset = $i * $limit
    $url = "https://data.transportation.gov/resource/$apiId.json?`$select=$select&`$where=$where&`$limit=$limit&`$offset=$offset&`$`$app_token=$appToken"
    
    Write-Host "Fetching batch $($i + 1)/$maxIterations (offset: $offset)..." -ForegroundColor Gray
    $response = Invoke-RestMethod -Uri $url -Method Get
    
    if ($response.Count -eq 0) {
        Write-Host "No more records found. Stopping pagination." -ForegroundColor Yellow
        break
    }
    
    $allRecords += $response
    Write-Host "Retrieved $($response.Count) records" -ForegroundColor Gray
}

# Display results
Write-Host "`nTotal records retrieved: $($allRecords.Count)" -ForegroundColor Cyan

# Count distinct values
$distinctDocketNumbers = ($allRecords | Select-Object -Property docket_number -Unique).Count
$distinctDotNumbers = ($allRecords | Select-Object -Property dot_number -Unique).Count
$distinctTypeTypes = ($allRecords | Select-Object -Property type_license -Unique).Count

Write-Host "`nDistinct docket_number count: $distinctDocketNumbers" -ForegroundColor Green
Write-Host "Distinct dot_number count: $distinctDotNumbers" -ForegroundColor Green
Write-Host "Distinct type_license count: $distinctTypeTypes" -ForegroundColor Green

# Create browser-friendly URL with proper encoding (for first page)
$browserUrl = "https://data.transportation.gov/resource/$apiId.json?`$select=$([System.Uri]::EscapeDataString($select))&`$where=$([System.Uri]::EscapeDataString($where))&`$limit=$limit&`$`$app_token=$appToken"
Write-Host "`nBrowser-friendly URL (first page): $browserUrl" -ForegroundColor Yellow