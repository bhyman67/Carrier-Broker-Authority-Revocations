
# #################################################################################################

# Trying to get a sense of the different revocation order types in the FMCSA Revocations History API
#     -> this seams to correspond to the Revocation Type field in the FMCSA dataset description doc

# Used PowerShell b/c initially I just wanted something to run curl commands easily and quickly.
# But copilot ended up switching me over to Invoke-WebRequest. And just kept building on that.

# #################################################################################################

# Read app token and API IDs from files
$appToken = Get-Content -Path "$PSScriptRoot\app_token.txt" -Raw | ForEach-Object { $_.Trim() }
$apiIds = Get-Content -Path "$PSScriptRoot\fmcsa_api_ids.json" -Raw | ConvertFrom-Json

# Select API to inspect (FMCSA Revocations History or FMCSA Authority History):
$apiId = $apiIds.'FMCSA Revocations History' 

# Query
$query = "SELECT DISTINCT ``order2_type_desc``"

$url = "https://data.transportation.gov/api/v3/views/$apiId/query.json?pageNumber=1&pageSize=500&app_token=$appToken&query=$query"
Invoke-WebRequest -Uri $url