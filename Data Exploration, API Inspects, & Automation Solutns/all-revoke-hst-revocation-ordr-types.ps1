# Read app token and API IDs from files
$appToken = Get-Content -Path "$PSScriptRoot\app_token.txt" -Raw | ForEach-Object { $_.Trim() }
$apiIds = Get-Content -Path "$PSScriptRoot\fmcsa_api_ids.json" -Raw | ConvertFrom-Json

# Select API to inspect (FMCSA Revocations History or FMCSA Authority History):
$apiId = $apiIds.'FMCSA Revocations History' 

# Query
$query = "SELECT DISTINCT ``order2_type_desc``"

$url = "https://data.transportation.gov/api/v3/views/$apiId/query.json?pageNumber=1&pageSize=500&app_token=$appToken&query=$query"
Invoke-WebRequest -Uri $url