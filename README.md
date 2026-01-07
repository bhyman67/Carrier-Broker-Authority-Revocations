# Carrier & Broker Authority Revocations
## Monthly Monitoring & Automation Case Study

## 1. Business Need

The business need is to build a reliable way to detect when a motor carrier or freight broker is no longer legally allowed to conduct commercial transportation business in the United States. This happens when a company’s operating authority is revoked by the Federal Motor Carrier Safety Administration (FMCSA).

**Goal:**  
Create an automated process (scheduled monthly) to identify new authority revocations and surface them to relevant teams via a nicely formatted Excel spreadsheet.

## 2. Business Process Understanding

### Current State:
A 3-person Risk and Compliance team manually checks FMCSA authority status for 5,000+ companies. Checks are reactive—typically performed only when concerns arise. This manual lookup process is time-consuming and doesn't scale.
  
The team needs a faster, more proactive way to identify revoked authorities rather than discovering them after issues occur.

### Key Definitions & Acronyms

Understanding these is important for context and domain understanding. For building intuition and avoiding modeling errors.

**FMCSA**  
Federal Motor Carrier Safety Administration  
The U.S. regulatory body responsible for carrier and broker oversight.

**USDOT Number**  
A unique identifier for motor carriers used for safety and compliance tracking.

**Docket Number**  
An operating authority identifier used for both carriers and brokers.

## 3. Proposed Automated Solution

### High-level approach

Build an automated monthly report in Excel that identifies:

- Motor carriers
- Freight brokers

whose FMCSA operating authority revocations went into effect (using the effective date) in the previous month. Deliver in an email.

**In simple terms:**  
The process pulls data from official DOT/FMCSA APIs to identify carriers and brokers that had their authority revocations take effect in the previous month, writes that information to a nicely formatted Excel spreadsheet, and emails it to the business for review.

## 4. Data Sources

### Primary Data Source

**FMCSA Authority Revocations Dataset**  
https://dev.socrata.com/foundry/data.transportation.gov/sa6p-acbp

This dataset contains **only revoked authorities** (all records have a revoked status). It provides complete historical records including:

- **Revocation type** - Distinguishes between voluntary, involuntary, and administrative revocations
- **Revocation dates** - Serve date and effective date
- **Entity identifiers** - USDOT number, MC/Docket number
- **Operating authority registration type** - Type of authority that was revoked

### Optional Enrichment Source (Later Down the Road)

**FMCSA QCMobile API**  
https://mobile.fmcsa.dot.gov/QCDevsite/

Can be used to enrich revocation records (joined on the USDOT number) with additional carrier information:

- Legal business names
- DBA (Doing Business As) names
- Additional company details

### Parent Portal

**Transportation.gov Open Data**  
https://data.transportation.gov/

The official U.S. Department of Transportation open data portal hosting all DOT-related datasets.

