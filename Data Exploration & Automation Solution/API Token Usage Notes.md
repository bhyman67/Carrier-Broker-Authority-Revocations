# Socrata API Token Usage Notes

## API Endpoints

### SODA API (Modern - What We're Using)
- **URL Format**: `https://data.transportation.gov/resource/sa6p-acbp.json`
- **Type**: SODA (Socrata Open Data API) - RESTful API
- **Dataset ID**: `sa6p-acbp` (4x4 format)
- **Query Language**: SoQL (Socrata Query Language)
- **Parameters**: `$select`, `$where`, `$limit`, `$offset`, `$order`, etc.
- **Best For**: Programmatic access, filtering, pagination

### Legacy Views API (Older)
- **URL Format**: `https://data.transportation.gov/api/v3/views/$apiId/query.json`
- **Type**: Legacy Views endpoint
- **Best For**: Dataset metadata, views configuration, specialized queries

## App Token Requirements

### Without App Token
- **Access**: ✓ Works fine for public datasets
- **Rate Limit**: ~1,000 requests/hour per IP address
- **Throttling**: More aggressive
- **Use Case**: Manual testing, one-off queries, small scripts

### With App Token
- **Access**: ✓ Works the same
- **Rate Limit**: ~10,000 requests/hour (sometimes 50,000+)
- **Throttling**: More generous
- **Tracking**: Separate usage monitoring
- **Use Case**: Production automation, scheduled scripts, large datasets

## Recommendation for Monthly Report Script

**Keep the app token** because:
- Free to obtain and use
- Best practice for production automation
- Protects against rate limits if script runs multiple times
- Professional/production-ready approach
- No downside to using it

**Could remove it** because:
- Script only runs once per month
- Dataset queries are relatively small
- Public data doesn't require authentication
- Would still work, just with lower rate limits

## Conclusion

The app token is **optional but recommended**. It's already configured in the script and provides better rate limits at no cost, making it the better choice for any automated/production workflow.
