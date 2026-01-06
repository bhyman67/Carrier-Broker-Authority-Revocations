# Carrier & Broker Authority Revocations
## Monthly Monitoring & Automation Case Study

## 1. Business Need

The business need is to build a reliable way to detect when a motor carrier or freight broker is no longer legally allowed to conduct commercial transportation business in the United States. This happens when a company’s operating authority is revoked by the Federal Motor Carrier Safety Administration (FMCSA).

**Goal:**  
Create an automated process (scheduled monthly) to identify new authority revocations and surface them to relevant teams via a nicely formatted Excel spreadsheet.

## 2. Proposed Automated Solution

### High-level approach

Build an automated monthly report that identifies:

- Motor carriers
- Freight brokers

whose FMCSA operating authority has been revoked since the previous reporting period.

**In simple terms:**  
The process pulls data from official DOT/FMCSA APIs to identify carriers and brokers that had their authority revoked, writes that information to a nicely formatted Excel spreadsheet, and emails it to the business for review.

## 3. Data Sources

**Transportation.gov and FMCSA APIs**
- https://data.transportation.gov/ (Official Dept of Transportation APIs)
  -  https://dev.socrata.com/foundry/data.transportation.gov/sa6p-acbp (FMCSA Revocations All History from DOT)
- https://mobile.fmcsa.dot.gov/QCDevsite/ (FMCSA QCMobile API – Carrier Info from FMCSA)

Specifically, FMCSA-related datasets that expose:

- Operating authority status
- Revocation dates
- Entity identifiers (USDOT number, MC/Docket number)
- Company name for given USDOT number

## 4. Key Definitions & Acronyms

Understanding these is important for context and Domain Understanding.

**FMCSA**  
Federal Motor Carrier Safety Administration  
The U.S. regulatory body responsible for carrier and broker oversight.

**USDOT Number**  
A unique identifier for motor carriers used for safety and compliance tracking.

**MC / Docket Number**  
An operating authority identifier used for both carriers and brokers.

While deep regulatory knowledge isn't required to build the automation, understanding these concepts helps build intuition and avoid modeling errors.

## 5. Discovery & Clarifying Questions (Early Phase)

### Business process understanding

- How does the risk and compliance team currently check FMCSA authority status?
- How often are checks performed today?
- What triggers a manual check (new customer, transaction, periodic review)?

Even if not required for automation, this helps:

- Identify pain points
- Validate assumptions
- Ensure the automated output aligns with real workflows

## 7. Data Exploration & Validation 

**Explore the datasets manually:**

- Browse records
- Inspect fields
- Understand how revocations are represented
- Confirm date fields and status transitions

**Key questions:**

- ...

## 8. Technical Considerations

### JSON parsing & transformation

Which tool is best suited for parsing and transforming the API responses?

- Python
- Low-code / No-code tools

Before choosing tooling:

- Manually browse sample payloads
- Understand nested structures
- Identify edge cases

## 9. Open Questions for Q&A / Interview Discussion

- Which low-code or no-code tools does the team currently use?
- What subscriptions or platforms are already in place?
- Where does automation typically live today (custom code vs platforms)?
- How are outputs consumed (dashboard, alerts, tickets, reports)?