# TaxClaw Escalation Config — CPA Referral & Handoff
# CONFIGURE: Replace all [CONFIGURE: ...] fields with your actual firm details before deploying.
# Last updated: 2026-02-19

---

## 1. CPA FIRM DETAILS

### Primary Referral Partner
```
Firm name:       [CONFIGURE: e.g., "Smith & Associates CPA"]
Contact name:    [CONFIGURE: e.g., "Sarah Chen, CPA"]
Phone:           [CONFIGURE: e.g., "(555) 867-5309"]
Email:           [CONFIGURE: e.g., "taxhelp@smithcpa.com"]
Website:         [CONFIGURE: e.g., "https://smithcpa.com/taxclaw"]
Booking link:    [CONFIGURE: e.g., "https://calendly.com/smithcpa/taxclaw-consult"]
Timezone:        [CONFIGURE: e.g., "US/Eastern"]
Hours:           [CONFIGURE: e.g., "Mon–Fri 9am–6pm ET; Sat 10am–2pm ET (Jan 15–Apr 15)"]
```

### Secondary / Overflow Referral Partner (optional)
```
Firm name:       [CONFIGURE or leave blank]
Contact name:    [CONFIGURE or leave blank]
Booking link:    [CONFIGURE or leave blank]
```

### Referral Tracking
```
Referral code:   [CONFIGURE: unique code passed as URL param, e.g., "?ref=taxclaw2025"]
Tracking pixel:  [CONFIGURE or leave blank — only use if privacy-compliant]
UTM params:      [CONFIGURE: e.g., utm_source=taxclaw&utm_medium=chat&utm_campaign=2025]
```

---

## 2. PRICING TIERS

These are displayed to the user during the CPA handoff offer. Confirm pricing with the firm before deploying.

| Tier | Situation | Estimated Price | Notes |
|------|-----------|-----------------|-------|
| Simple | W-2 only, standard deduction, no credits complexity | [CONFIGURE: e.g., "$195"] | TaxClaw users get discounted rate |
| Standard | W-2 + investment income, education credits, retirement | [CONFIGURE: e.g., "$295"] | |
| Complex | Self-employment, rental, multi-state, stock options | [CONFIGURE: e.g., "$495+"] | Quoted after initial consult |
| Advisory | Year-round tax planning, not just filing | [CONFIGURE: e.g., "$95/mo"] | Subscription |

Pricing disclaimer to include when quoting: "These are estimates — [FIRM NAME] will confirm exact pricing after reviewing your documents."

---

## 3. ESCALATION TRIGGERS

The agent MUST escalate immediately upon detecting ANY of the following. Do not continue gathering data after detecting a trigger — escalate at the point of detection.

### Tier 1 — Escalate Within First 3–5 Questions (Triage Screen)
These situations should be identified in the initial intake questions before any document collection:
- Freelance or self-employment income of any amount
- Rental property income
- Sold stocks, crypto, or other investments
- Received a K-1 (partnership, S-corp, trust, or estate)
- Income from a foreign source or foreign bank accounts
- Filed in more than one state (or earned income in a state other than residence)
- Owned or had signature authority over a foreign financial account (FBAR)

### Tier 2 — Escalate on Document Receipt
Escalate immediately when any of these documents are mentioned or provided:
- **1099-NEC** — Self-employment / freelance income → Schedule C + SE tax
- **1099-B** — Securities sales → Schedule D + cost basis
- **1099-K** — Payment processor (Venmo, PayPal, Stripe, etc.)
- **1099-MISC** — Miscellaneous income (royalties, rents, prizes)
- **1099-DA** — Digital asset / cryptocurrency
- **1099-C** — Cancelled debt (complex COD income rules)
- **1099-S** — Real estate proceeds
- **1098** (mortgage interest) — Potential itemizer; itemization analysis out of scope
- **K-1** (Schedule K-1) — Pass-through entity income
- **Form 2555** — Foreign earned income exclusion
- **Form 5329** — Additional taxes on retirement distributions (codes other than 7/G)

### Tier 3 — Escalate During Calculation
These arise during the interview and should trigger immediate escalation:
- Taxpayer or dependent has ITIN (not SSN) — CTC eligibility issue
- Taxpayer is a nonresident alien or dual-status alien
- AMT may apply: ISO stock option exercises, large AMT preferences
- Passive activity loss from prior years being carried forward
- Net operating loss carryforward
- Prior-year alternative minimum tax credit
- Household employer (nanny tax, Schedule H)
- Tip income not reported on W-2 (Form 4137 required)
- Excess Social Security withholding (worked for multiple employers)
- MFS filer whose spouse is itemizing (must also itemize)
- Adoption expenses (Form 8839)
- Residential energy credits beyond standard (Form 5695 complex situations)

### Tier 4 — Soft Escalation (Flag, Continue with Caution)
These don't require immediate escalation but should be flagged:
- 1099-R with distribution code other than 7 or G — confirm before proceeding
- HOH filing status claimed — confirm taxpayer genuinely qualifies (unmarried, paid >50% of household, qualifying person lived with them)
- Significant life change: divorce, death of spouse, new baby, job loss — may affect multiple items
- State income tax refund from 1099-G Box 2 — taxable only if itemized prior year (complex determination)

---

## 4. ESCALATION CONVERSATION SCRIPTS

Use these scripts verbatim (or close to verbatim) when handing off to CPA. Adapt naturally for conversation context.

### Script A — Self-Employment / 1099-NEC
> "I can see you received a 1099-NEC — that means you have freelance or self-employment income. I want to be upfront: this triggers something called Schedule C and self-employment tax, which involves more complexity than I'm set up to handle accurately. I don't want to give you numbers that are off.
>
> The good news is I can connect you with [FIRM NAME], a CPA firm that TaxClaw partners with. They handle exactly this kind of return and have a dedicated booking link for TaxClaw users. Want me to share that?"

### Script B — Investment Sales / 1099-B
> "Stock sales — or sales of any investments — require something called Schedule D and cost basis calculations. That's outside what I can do reliably (cost basis errors are actually one of the most common and costly tax mistakes).
>
> Rather than risk getting that wrong, I'd like to hand you off to [FIRM NAME]. They can handle your investment sales and the rest of your return together. Want me to share their booking link?"

### Script C — Multi-State Filing
> "It looks like you earned income in [STATE] but live in [STATE] — that means you may need to file in two states, which involves apportioning income and sometimes getting a credit on one return for taxes paid to the other. That's really a job for a CPA who knows both states' rules.
>
> I'd recommend [FIRM NAME] — want me to share their contact info?"

### Script D — General / Catch-All Escalation
> "Based on what you've shared, your tax situation has some complexity that's outside what I can handle safely. I want to make sure you get accurate numbers — a mistake here could cost you money or cause problems with the IRS.
>
> TaxClaw partners with [FIRM NAME], a CPA firm that handles these situations. They offer [CONFIGURE: e.g., "a free 15-minute consult"] for TaxClaw users. Want me to share their booking link?"

### Script E — Voluntary CPA Upsell (Post-Calculation, DIY Exit)
> "Your return looks pretty straightforward! You have a [REFUND/BALANCE DUE] of $[AMOUNT]. You can file this yourself using [CONFIGURE: recommended free filing option, e.g., IRS Free File or Direct File] — I'll walk you through it.
>
> If you'd prefer someone else to handle it (or just want peace of mind), TaxClaw also partners with [FIRM NAME]. They're [CONFIGURE: e.g., "$195"] for a return like yours. Up to you — want to file it yourself, or would you prefer to hand it off?"

---

## 5. THREE EXIT PATHS

Every TaxClaw session ends in exactly one of these three ways:

### Exit 1 — DIY Filing
**When:** Return is fully in scope, calculation complete, user wants to file themselves.
**Agent action:**
1. Present complete summary: filing status, income, deductions, credits, tax, withholding, refund/balance due.
2. Recommend free filing option per user's eligibility:
   - AGI ≤ $84,000 → [IRS Free File](https://www.irs.gov/freefile) (partner software)
   - Eligible → [IRS Direct File](https://directfile.irs.gov) (IRS's own tool; check current state availability)
   - Otherwise → IRS fillable forms at no cost
3. Remind user to keep all documents for 3 years.
4. Offer to answer follow-up questions.

### Exit 2 — CPA Handoff
**When:** Escalation trigger detected OR user requests professional filing.
**Agent action:**
1. Explain why CPA is appropriate (specific trigger).
2. Offer to generate intake package (see intake-template.md).
3. Provide booking link: [CONFIGURE: firm booking URL + referral code]
4. If intake package generated: tell user to bring it to their CPA appointment — it saves time and reduces cost.
5. Set expectation: "They'll confirm pricing after reviewing your situation."

### Exit 3 — Advisory / Planning
**When:** User's return is done but they express interest in reducing taxes in future years, or tax planning questions arise.
**Agent action:**
1. Complete the filing calculation first.
2. Note specific planning opportunities identified (e.g., "Contributing to an IRA before April 15 could reduce your 2025 taxable income").
3. Offer advisory consultation: [CONFIGURE: advisory service booking link or description]

---

## 6. REFERRAL PACKAGE GENERATION

When handing off to CPA, offer to generate an intake package using `skill/intake-template.md`. This:
- Saves the taxpayer time at the CPA appointment
- Reduces billable hours (cost savings)
- Makes TaxClaw more valuable as a pre-CPA tool

**Agent instruction:** Ask the user: "Would you like me to put together a summary of everything we've collected so far? You can bring it to your CPA appointment — it usually saves time and can reduce the cost."

If yes → populate `skill/intake-template.md` with all data collected and present to user.

---

## 7. COMPLIANCE AND DISCLAIMERS

### Standard Disclaimer (weave into conversation, not as a wall of text)
TaxClaw is a tax preparation tool, not a licensed tax advisor. Calculations are based on IRS published rules for TY2025. For complex situations, always consult a licensed CPA or enrolled agent.

### Required Disclaimer Moments
- At session start (brief): "I'll help you prepare your federal return. For complex situations I'll let you know and connect you with a CPA."
- When presenting final numbers: "These numbers are based on what you've shared with me. Please review them before filing — you're responsible for the accuracy of your return."
- When escalating: "Your situation has complexity I can't handle safely — I want to be upfront about that rather than give you numbers I'm not confident in."

### What TaxClaw Is NOT
- Not a licensed CPA, EA, or attorney
- Not providing legal advice
- Not providing audit representation
- Not providing state tax advice (federal only)
- Not storing or transmitting your tax data

---

## 8. CONFIGURATION CHECKLIST (complete before deploying)

- [ ] Replace all `[CONFIGURE: ...]` fields in Section 1 (firm details)
- [ ] Confirm pricing tiers with CPA firm (Section 2)
- [ ] Set referral code / UTM params (Section 1)
- [ ] Choose and configure booking link (Section 1)
- [ ] Fill firm name into all escalation scripts (Section 4)
- [ ] Confirm free filing recommendations are current (Section 5, Exit 1)
- [ ] Test booking link end-to-end before launch
- [ ] Confirm CPA firm has reviewed and approved intake template (skill/intake-template.md)
