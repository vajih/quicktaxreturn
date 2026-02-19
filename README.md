# TaxClaw

> "Send me your W-2 and I'll tell you your refund in 2 minutes. Free. Private. No upsells."

TaxClaw is an [OpenClaw](https://openclaw.ai) skill that helps US individual taxpayers prepare their federal income tax returns through conversational AI. It works in WhatsApp, Telegram, Slack, or any channel OpenClaw connects to.

The agent interviews the taxpayer, reads their documents box-by-box, runs explicit bracket-by-bracket arithmetic, and routes to one of three exits: file it yourself (free), hand off to a CPA partner, or book a planning session.

**Tax Year:** 2025 (returns filed in 2026)
**Scope:** US federal income tax only

---

## How It Works

```
You: "Here's my W-2"
TaxClaw: "I'm reading Box 1 wages as $67,450 — does that look right?"
You: "Yes"
TaxClaw: "10% on $11,925 = $1,192.50, 12% on $36,550 = $4,386 ..."
TaxClaw: "Great news — you're getting a $2,847 refund."
```

The agent collects every relevant document value, confirms each number with the taxpayer before using it, shows all arithmetic step-by-step, and never estimates or uses effective rates. Every number traces to a specific box on a specific form on a specific 1040 line.

**Privacy:** All data stays on the user's local device. TaxClaw processes locally through OpenClaw — no cloud storage, no third-party APIs for tax data.

---

## What It Handles

### In Scope — Full Support

| Form | What It Is | Key Data Extracted |
|------|-----------|-------------------|
| W-2 | Wages and salary | Box 1 wages, Box 2 federal withheld, Box 12 codes |
| 1099-INT | Bank interest | Box 1 taxable interest, Box 4 withheld |
| 1099-DIV | Dividends | Box 1a ordinary, Box 1b qualified, Box 2a cap gain dist |
| 1099-G | Govt payments | Box 1 unemployment, Box 2 state refund |
| 1099-R | Retirement distributions | Box 1 gross, Box 2a taxable, Box 7 distribution code |
| SSA-1099 | Social Security | Box 5 net benefits (SS taxability worksheet runs automatically) |
| 1098-E | Student loan interest | Box 1 interest paid → Schedule 1 Line 21 deduction |
| 1098-T | Tuition | Box 1 payments, Box 5 scholarships → AOTC or LLC credit |

### Out of Scope — Escalate to CPA

TaxClaw detects these in the first 3–5 questions and routes to a CPA partner rather than producing incorrect numbers:

- **1099-NEC** — Freelance / self-employment → Schedule C + self-employment tax
- **1099-B** — Investment sales → Schedule D + cost basis
- **1099-K** — Payment platforms (Venmo, PayPal, Stripe)
- **1099-DA** — Crypto / digital assets
- **1099-C / 1099-S** — Cancelled debt, real estate
- **1099-MISC / K-1** — Miscellaneous income, pass-through entities
- **Multiple states** — Multi-state filing
- **Mortgage interest (1098)** — Potential itemizer
- **Foreign income, AMT, FBAR** — Complex situations

---

## Project Structure

```
taxclaw/
├── CLAUDE.md                    # Project context — Claude Code reads this automatically
├── skill/
│   ├── SKILL.md                 # Core agent behavior: interview flow, calculation sequence,
│   │                            #   escalation logic, exit routing, tone guide
│   ├── tax-rules.md             # TY2025 tax reference data: all four filing status bracket
│   │                            #   tables, standard deductions, CTC/ACTC, EITC tables,
│   │                            #   AOTC/LLC, SS taxability worksheet, FICA, LTCG rates,
│   │                            #   AMT, retirement limits — every number sourced to IRS
│   ├── escalation-config.md     # CPA partner details (configure before deploying),
│   │                            #   pricing tiers, escalation trigger taxonomy,
│   │                            #   conversation scripts, three exit paths
│   └── intake-template.md       # Structured 10-section CPA handoff package that the
│                                #   agent populates and gives to the taxpayer
└── tests/
    └── scenarios/               # 10 hand-calculated test cases with exact expected outputs
        ├── 01-single-w2-only.md
        ├── 02-mfj-two-children-ctc.md
        ├── 03-hoh-eitc-actc.md
        ├── 04-mfj-retired-ss-pension.md
        ├── 05-aotc-education-credit.md
        ├── 06-early-withdrawal-penalty.md
        ├── 07-qualified-dividends-student-loan.md
        ├── 08-ctc-phase-out-high-income.md
        ├── 09-escalation-self-employment.md
        └── 10-ss-taxability-85pct-tier.md
```

---

## Installation

```bash
clawhub install taxclaw
```

Then configure the CPA partner details before going live (see [Configuration](#configuration)).

---

## Configuration

Before deploying, edit `skill/escalation-config.md` and fill in all `[CONFIGURE: ...]` fields:

```
# Section 1 — CPA firm details
Firm name:       [your CPA partner's firm name]
Contact name:    [primary contact at the firm]
Phone:           [firm phone number]
Email:           [intake email]
Booking link:    [Calendly or equivalent booking URL]
Referral code:   [unique tracking code]
```

The file includes a configuration checklist (§8) — complete it before launch.

---

## Test Scenarios

`tests/scenarios/` contains 10 hand-calculated test cases built from real TY2025 numbers. Each file includes:

- Full taxpayer profile and input documents
- Expected triage outcome (in scope vs. escalate)
- Step-by-step arithmetic with 1040 line references
- Complete expected summary output block
- Agent behavior checkpoints

| Scenario | What It Tests | Expected Result |
|----------|--------------|-----------------|
| 01 — Single, W-2 only | Basic bracket calc, no credits | Refund $2,298 |
| 02 — MFJ, two children | CTC $4,400 fully absorbed by tax | Refund $6,777 |
| 03 — HOH, one child | CTC partial + ACTC + EITC stacking | Refund $6,635 |
| 04 — MFJ retirees | SS worksheet (50% tier), age-65+ deduction | Refund $2,640 |
| 05 — MFJ, college student | AOTC split: $1,500 non-refundable + $1,000 refundable | Refund $5,377 |
| 06 — Single, early IRA withdrawal | Code 1 → income tax + 10% penalty | Balance due $762 |
| 07 — Single, dividends + student loan | QD at 0% LTCG rate, SLI deduction | Refund $820 |
| 08 — MFJ, $420k income | CTC phase-out math, Additional Medicare Tax | Refund $4,576 |
| 09 — Freelancer | Tier 1 triage trigger, no calculation | Escalate to CPA |
| 10 — Single retiree | SS worksheet (85% tier), age-68 deduction | Refund $1,127 |

---

## Tax Data Sources

All numbers in `skill/tax-rules.md` are sourced from IRS primary documents:

| Source | Coverage |
|--------|---------|
| Rev. Proc. 2024-40 | Brackets, standard deductions, CTC/ACTC, EITC, LTCG rates, AMT, student loan phase-outs |
| IRS Notice 2024-80 | 401(k), IRA, SIMPLE contribution limits and IRA phase-out ranges |
| Schedule 8812 Instructions (2025) | CTC $2,200/child (legislative increase), ACTC $1,700/child |
| Form 8863 Instructions (2025) | AOTC and LLC phase-out ranges |
| IRS Publication 15 (2025) | Social Security wage base ($176,100), FICA rates |
| IRS Publication 596 (2025) | EITC eligibility rules and tables |
| IRS Publication 915 (2025) | Social Security benefit taxability worksheet |

**Note on the CTC:** The maximum credit increased to **$2,200 per child** for TY2025 (up from $2,000) under the Tax Relief for American Families and Workers Act of 2025. This was enacted after Rev. Proc. 2024-40 and is confirmed in the Schedule 8812 Instructions dated January 23, 2026.

---

## Annual Update Checklist

Each November, after the IRS releases the new Revenue Procedure:

- [ ] Update `skill/tax-rules.md` — new brackets, deductions, credit amounts, EITC tables
- [ ] Update the CTC amount if legislation changed it (check Schedule 8812 Instructions)
- [ ] Update Social Security wage base (IRS Publication 15)
- [ ] Update retirement contribution limits (IRS Notice — typically released late October)
- [ ] Update `skill/escalation-config.md` — confirm CPA pricing is still current
- [ ] Update test scenarios with new year's numbers
- [ ] Update the tax year references throughout `skill/SKILL.md`
- [ ] Run all 10 test scenarios against the updated rules

---

## Accuracy Principles

TaxClaw is designed around three non-negotiable accuracy rules:

1. **Explicit arithmetic.** Every calculation is shown bracket-by-bracket: "10% on $11,925 = $1,192.50, then 12% on $36,550 = $4,386..." Never effective rates. Never estimates.

2. **Confirm before compute.** Every value extracted from a document is read back to the taxpayer for confirmation before it enters any calculation.

3. **Escalate conservatively.** When any doubt exists about scope, TaxClaw routes to a CPA rather than producing numbers it can't stand behind. Detection happens in the first 3–5 questions — before the taxpayer has invested significant time.

---

## Disclaimer

TaxClaw is a tax preparation tool, not a licensed tax advisor. Calculations are based on IRS published rules for Tax Year 2025. Taxpayers are responsible for the accuracy of their returns. For complex situations, consult a licensed CPA or enrolled agent. TaxClaw handles federal returns only — state filing requirements vary.

---

## License

MIT
