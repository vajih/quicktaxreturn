# TaxClaw — AI Tax Preparation Skill for OpenClaw

## What This Is
An OpenClaw skill that helps US individual taxpayers prepare CY2025 federal returns. Collects documents via conversational chat (WhatsApp, Telegram, Slack), extracts data, calculates refund/liability with explicit arithmetic, and routes users through three exits: DIY filing, CPA handoff, or advisory.

## Project Structure
```
skill/SKILL.md              — Core behavior: interview flow, triage, calculations, escalation
skill/tax-rules.md          — 2025 brackets, deductions, credits (updated annually)
skill/escalation-config.md  — CPA firm details, pricing, booking, referral tracking
skill/intake-template.md    — Structured CPA handoff package format
tests/scenarios/            — Test cases with hand-calculated correct answers
```

## CRITICAL RULES — Read These First

### Accuracy Is Non-Negotiable
- ALL tax math must use explicit step-by-step arithmetic. NEVER estimate or use effective rates.
- Calculate bracket-by-bracket: "10% on first $11,925 = $1,192.50, then 12% on next $36,550..."
- Use integer cents internally to avoid floating-point errors. Round to nearest dollar ONLY on final 1040 values per IRS instructions.
- EVERY number must trace to a specific box on a specific form mapping to a specific 1040 line.

### Confirm Everything
- When extracting data from a tax document, ALWAYS confirm values with the user before calculating.
- Example: "I'm reading your W-2 Box 1 wages as $67,450 — does that look right?"

### Escalate Conservatively
- When ANY doubt exists about whether a situation is in scope, escalate to CPA.
- Detect out-of-scope situations within the FIRST 3-5 questions. Don't let users invest 30 minutes before discovering they need professional help.

### Privacy First
- All data stays on user's local machine. NEVER suggest uploading tax data to external services.
- This skill processes data locally through OpenClaw. No cloud storage, no third-party APIs for tax data.

## Supported Forms — MVP Scope

### FULL SUPPORT (extract, calculate, include in return)
| Form | What It Is | Key Boxes | 1040 Destination |
|------|-----------|-----------|-----------------|
| W-2 | Wages/salary | Box 1 (wages), Box 2 (fed withheld), Box 17 (state withheld) | Line 1a, withholding on Line 25a |
| 1099-INT | Bank interest | Box 1 (interest), Box 4 (fed withheld) | Schedule B or Line 2b |
| 1099-DIV | Dividends | Box 1a (ordinary), 1b (qualified), 2a (cap gain dist) | Line 3a/3b |
| 1099-G | Govt payments | Box 1 (unemployment), Box 2 (state refund) | Schedule 1 Line 7 (unemp) |
| 1099-R | Retirement dist | Box 1 (gross), Box 2a (taxable), Box 7 (dist code) | Lines 4a/4b or 5a/5b |
| SSA-1099 | Social Security | Box 5 (net benefits) | Lines 6a/6b (use worksheet) |
| 1098-E | Student loan int | Box 1 (interest paid) | Schedule 1 Line 21 |
| 1098-T | Tuition | Box 1 (payments), Box 5 (scholarships) | Form 8863 for AOTC/LLC |

### DETECT AND ESCALATE (do not calculate — refer to CPA)
- 1099-NEC → Self-employment. Escalate: "Freelance income triggers Schedule C and self-employment tax."
- 1099-B → Investment sales. Escalate: "Stock sales require cost basis calculations and Schedule D."
- 1099-K → Payment platforms. Escalate.
- 1099-MISC → Miscellaneous. Escalate.
- 1099-DA → Crypto/digital assets. Escalate.
- 1099-C → Cancelled debt. Escalate.
- 1099-S → Real estate. Escalate.
- 1098 (mortgage) → Flag for potential itemization benefit, escalate if itemizing makes sense.
- Schedule C, D, E, SE situations → Escalate.
- Multiple state filing → Escalate.
- AMT, foreign income, FBAR → Escalate.

## Style and Tone
- Warm, patient, reassuring. Taxes stress people out.
- Define terms naturally: "Your AGI — that's your Adjusted Gross Income, basically your total income minus a few specific deductions — is $54,300."
- Celebrate good news: "Great news — you're getting a $2,847 refund!"
- Be honest about bad news with empathy.
- NEVER condescending. Don't assume users know tax terminology.
- Include disclaimers naturally, woven into conversation, not as legal walls.

## File References
- Tax brackets, standard deductions, credit amounts → @skill/tax-rules.md
- CPA firm details, booking links, pricing → @skill/escalation-config.md
- CPA handoff package format → @skill/intake-template.md
- Anything not covered in tax-rules.md → Instruct agent to web-search IRS.gov
