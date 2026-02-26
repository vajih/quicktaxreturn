# Scenario 09 — Escalation: Self-Employment Income Detected at Triage
# Tax Year 2025 | Expected result: ESCALATE TO CPA — no calculation performed
# Tests: Tier 1 triage detection, escalation script A, intake package offer

---

## TAXPAYER PROFILE

| Field | Value |
|-------|-------|
| Filing status | Unknown (not determined — escalation occurs at triage) |
| Age | 34 |
| Situation | Freelance graphic designer with W-2 from a day job and 1099-NEC from freelance work |

---

## INPUT DOCUMENTS (disclosed during triage)

- W-2 from employer (wages $55,000)
- 1099-NEC from freelance clients (total ~$22,000)

---

## EXPECTED TRIAGE OUTCOME

**ESCALATE IMMEDIATELY at Triage Question 1.**

Trigger: "freelance" / "1099-NEC" / "self-employment income"
Escalation tier: Tier 1 (within first 3–5 questions)
Script: Script A (from escalation-config.md §4)

---

## EXPECTED AGENT BEHAVIOR — TRANSCRIPT

### Q1 Exchange
> Agent: "What kinds of income did you have in 2025? Things like wages from a job, freelance or gig work, Social Security, retirement withdrawals, interest from savings, or anything else?"

> Taxpayer: "I have a W-2 from my regular job, and I also did some freelance graphic design on the side — I got a 1099-NEC for that."

### Escalation Trigger Detected
Keyword matched: "freelance," "1099-NEC"
Tier 1 trigger active. Agent must NOT proceed to Question 2.

### Agent Response (Script A)
> "I can see you received a 1099-NEC — that means you have freelance or self-employment income. I want to be upfront: this triggers something called Schedule C and self-employment tax, which involves more complexity than I'm set up to handle accurately. I don't want to give you numbers that are off.
>
> The good news is I can connect you with [FIRM NAME], a CPA firm that QuickTaxReturn partners with. They handle exactly this kind of return and have a dedicated booking link for QuickTaxReturn users. Want me to share that?"

### Intake Package Offer (if taxpayer says yes to CPA referral)
> "Would you like me to put together a summary of what we know so far? You can bring it to your CPA appointment — it has your situation organized so they can get started quickly."

If yes: Agent populates intake-template.md §3 "OUT-OF-SCOPE INCOME" section with:
```
[X] 1099-NEC received from: [freelance clients]
    Approximate amount:     ~$22,000
    Business activity:      freelance graphic design

W-2 also present (CPA will include with Schedule C return):
    Employer: [name not yet collected]
    Box 1 wages: $55,000 (approximate — not yet confirmed)
```

### Booking Link Delivery
> "Here's the booking link for [FIRM NAME]: [CONFIGURE: booking URL]
>
> When you book, let them know QuickTaxReturn sent you — the link already includes a referral code.
>
> They'll be able to handle your W-2, your Schedule C for the freelance work, and the self-employment tax calculation all in one return."

---

## WHAT AGENT MUST NOT DO

- Must NOT ask for W-2 box values before escalating
- Must NOT calculate tax on the W-2 wages alone
- Must NOT suggest the taxpayer can separate the return (W-2 only vs. freelance)
- Must NOT attempt to estimate self-employment tax

---

## WHY THIS ESCALATION IS REQUIRED

A 1099-NEC triggers:
1. Schedule C — Profit or Loss from Business (itemize deductible business expenses)
2. Schedule SE — Self-Employment Tax (15.3% on net SE income up to $176,100 SS wage base)
3. Possible QBI deduction (Section 199A) — up to 20% of qualified business income
4. Estimated tax obligations — SE taxpayers must pay quarterly

These are outside QuickTaxReturn MVP scope. Attempting to calculate them without all expense data would produce materially incorrect results.
