# QuickTaxReturn

> Send me your W-2. I'll tell you your refund in 2 minutes. Free. Private. No upsells.

[![ClawHub](https://img.shields.io/badge/ClawHub-quicktaxreturn-blue)](https://clawhub.ai/skills/quicktaxreturn)
[![Tax Year](https://img.shields.io/badge/Tax%20Year-2025-green)](https://clawhub.ai/skills/quicktaxreturn)
[![License](https://img.shields.io/badge/license-MIT-brightgreen)](LICENSE)

**QuickTaxReturn** is an [OpenClaw](https://openclaw.ai) skill for US individual federal tax preparation. It runs as a chat conversation — in WhatsApp, Telegram, Slack, or any channel OpenClaw supports — interviewing the taxpayer, reading their documents box-by-box, running explicit bracket-by-bracket arithmetic, and routing to the right outcome: DIY filing, CPA handoff, or tax planning.

**Tax Year:** 2025 &nbsp;|&nbsp; **Scope:** US federal individual (Form 1040) &nbsp;|&nbsp; **State filing:** Not included

---

## Install

```bash
clawhub install quicktaxreturn
```

Then open `skill/escalation-config.md` and fill in your CPA partner details before going live.

---

## What a Session Looks Like

```
You:      "Here's my W-2"
QuickTaxReturn:  "I'm reading Box 1 wages as $67,450 and Box 2 withheld as $8,200 —
           does that look right?"
You:      "Yes"
QuickTaxReturn:  "10% on $11,925 = $1,192.50
           12% on $36,550 = $4,386.00
           22% on $18,975 = $4,174.50
           Income tax: $9,753.00"
QuickTaxReturn:  "Great news — you're getting a $2,847 federal refund.
           Your AGI of $52,450 qualifies for IRS Free File — completely free to file."
```

Every value is confirmed before it enters a calculation. Every calculation shows the full arithmetic. Every number traces to a specific box on a specific form at a specific 1040 line.

---

## Why QuickTaxReturn

**Accurate by design.** Bracket-by-bracket arithmetic — never effective rates, never estimates. Integer-cent precision internally; rounds only for final 1040 values per IRS instructions.

**Confirm before compute.** Every extracted document value is read back to the taxpayer for confirmation before use. The taxpayer always knows what numbers are being used and why.

**Escalates conservatively.** Complex situations (freelance income, investment sales, crypto, rental property) are detected in the first 3–5 questions — before the user has invested time — and routed to a CPA. QuickTaxReturn never produces numbers it can't stand behind.

**Private by default.** All data stays on the user's local device. No cloud storage, no third-party APIs for tax data. OpenClaw processes everything locally.

**Three clean exits.** Every session ends at exactly one of: (1) complete DIY summary with free filing recommendations, (2) structured CPA intake package with booking link, or (3) post-filing tax planning advisory.

---

## What It Handles

### In Scope — Full Calculation

| Form     | What It Is                  | Credits / Deductions                 |
| -------- | --------------------------- | ------------------------------------ |
| W-2      | Wages and salary            | Income, withholding                  |
| 1099-INT | Bank interest               | Line 2b income                       |
| 1099-DIV | Dividends                   | Ordinary + qualified rates           |
| 1099-G   | Unemployment / state refund | Schedule 1                           |
| 1099-R   | Retirement distributions    | Lines 4a/4b, 5a/5b + penalty         |
| SSA-1099 | Social Security             | Taxability worksheet (0 / 50% / 85%) |
| 1098-E   | Student loan interest       | Up to $2,500 deduction               |
| 1098-T   | Tuition                     | AOTC up to $2,500 · LLC up to $2,000 |

**Credits calculated:** Child Tax Credit ($2,200/child) · ACTC (up to $1,700/child refundable) · EITC (up to $8,046) · AOTC · LLC · Child and Dependent Care Credit

**Deductions applied:** Standard deduction (all filing statuses) · Age 65+/blind add-ons · Student loan interest · IRA deduction · HSA (direct contributions) · Educator expenses

### Detected and Escalated to CPA

QuickTaxReturn identifies these within the first 3–5 questions and hands off cleanly rather than producing incorrect numbers:

`1099-NEC` `1099-B` `1099-K` `1099-DA` `1099-C` `1099-S` `1099-MISC` `K-1` `1098 (mortgage)` `Schedule C/D/E/SE` · Multi-state filing · Foreign income · AMT situations · FBAR

---

## Configuration

After installing, edit three files:

| File                         | What to Configure                                       |
| ---------------------------- | ------------------------------------------------------- |
| `skill/escalation-config.md` | CPA firm name, phone, email, booking URL, pricing tiers |
| `skill/tax-rules.md`         | Update annually each November after new IRS Rev. Proc.  |
| `skill/intake-template.md`   | Customize CPA handoff package branding if desired       |

---

## Test Coverage

10 hand-calculated test cases with exact expected outputs, step-by-step arithmetic, and 1040 line references. All built from real TY2025 IRS numbers.

| Scenario                              | What It Tests                                   | Expected Result  |
| ------------------------------------- | ----------------------------------------------- | ---------------- |
| 01 — Single, W-2 only                 | Basic bracket calc, no credits                  | Refund $2,298    |
| 02 — MFJ, two children                | CTC $4,400 fully absorbed by tax                | Refund $6,777    |
| 03 — HOH, one child                   | CTC partial + ACTC + EITC stacking              | Refund $6,635    |
| 04 — MFJ retirees                     | SS worksheet (50% tier), age-65+ deduction      | Refund $2,640    |
| 05 — MFJ, college student             | AOTC: $1,500 non-refundable + $1,000 refundable | Refund $5,377    |
| 06 — Single, early IRA withdrawal     | Code 1 → income tax + 10% penalty               | Balance due $762 |
| 07 — Single, dividends + student loan | QD at 0% LTCG rate, SLI deduction               | Refund $820      |
| 08 — MFJ, $420k income                | CTC phase-out math + Additional Medicare Tax    | Refund $4,576    |
| 09 — Freelancer                       | Tier 1 triage trigger, no calculation           | Escalate to CPA  |
| 10 — Single retiree                   | SS worksheet (85% tier), age-68 deduction       | Refund $1,127    |

---

## Project Structure

```
quicktaxreturn/
├── clawhub.yaml                 # ClawHub marketplace manifest
├── skill/
│   ├── SKILL.md                 # Core agent behavior: interview flow, calculations,
│   │                            #   escalation logic, exit routing, tone guide
│   ├── tax-rules.md             # TY2025 reference data: all bracket tables, standard
│   │                            #   deductions, CTC/ACTC, EITC, AOTC/LLC, SS worksheet,
│   │                            #   FICA, LTCG rates, AMT, retirement limits — IRS-sourced
│   ├── escalation-config.md     # CPA partner details, pricing tiers, escalation scripts,
│   │                            #   three exit paths — configure before deploying
│   └── intake-template.md       # Structured CPA handoff package the agent populates
└── tests/
    └── scenarios/               # 10 hand-calculated test cases with exact expected outputs
```

---

## CPA Partner

Complex returns are routed to a CPA partner you configure. The default configuration points to:

**M.S.Ayubi CPA PLLC** · Aisha Moin, CPA · The Woodlands, TX  
Text: (832) 466-4385 · [woodlandsqb.com](https://woodlandsqb.com/) · [Book an appointment](https://woodlandsqb.com/contact?ref=quicktaxreturn2025&utm_source=quicktaxreturn&utm_medium=chat&utm_campaign=2025)

| Tier     | Situation                            | Estimated Price |
| -------- | ------------------------------------ | --------------- |
| Simple   | W-2 only                             | $150            |
| Standard | W-2 + retirement / education         | $250            |
| Complex  | Self-employment, rental, multi-state | $400+           |
| Advisory | Planning consultation                | $75/session     |

Replace these details in `skill/escalation-config.md` with your own CPA partner before deploying.

---

## Tax Data Sources

Every number in `skill/tax-rules.md` is sourced from IRS primary documents:

| Source                            | Coverage                                                                                |
| --------------------------------- | --------------------------------------------------------------------------------------- |
| Rev. Proc. 2024-40                | Brackets, standard deductions, CTC/ACTC, EITC, LTCG rates, AMT, student loan phase-outs |
| IRS Notice 2024-80                | 401(k), IRA, SIMPLE limits and IRA phase-out ranges                                     |
| Schedule 8812 Instructions (2025) | CTC $2,200/child, ACTC $1,700/child                                                     |
| Form 8863 Instructions (2025)     | AOTC and LLC phase-out ranges                                                           |
| IRS Publication 15 (2025)         | SS wage base ($176,100), FICA rates                                                     |
| IRS Publication 596 (2025)        | EITC eligibility and tables                                                             |
| IRS Publication 915 (2025)        | Social Security taxability worksheet                                                    |

> **Note on the CTC:** The maximum credit increased to **$2,200 per child** for TY2025 (up from $2,000) under the Tax Relief for American Families and Workers Act of 2025, confirmed in Schedule 8812 Instructions dated January 23, 2026.

---

## Annual Update Checklist

Each November, after the IRS releases the new Revenue Procedure:

- [ ] Update `skill/tax-rules.md` — new brackets, deductions, credit amounts, EITC tables
- [ ] Update the CTC amount if legislation changed it (check Schedule 8812 Instructions)
- [ ] Update Social Security wage base (IRS Publication 15)
- [ ] Update retirement contribution limits (IRS Notice — typically released late October)
- [ ] Update `skill/escalation-config.md` — confirm CPA pricing is still current
- [ ] Update test scenarios with new year's numbers
- [ ] Update tax year references throughout `skill/SKILL.md`
- [ ] Run all 10 test scenarios against the updated rules

---

## Accuracy Principles

1. **Explicit arithmetic.** Every calculation is shown bracket-by-bracket. Never effective rates. Never estimates.
2. **Confirm before compute.** Every value from a document is read back to the taxpayer for confirmation before it enters any calculation.
3. **Escalate conservatively.** When any doubt exists about scope, QuickTaxReturn routes to a CPA. Detection happens in the first 3–5 questions.

---

## Disclaimer

QuickTaxReturn is a tax preparation tool, not a licensed tax advisor. Calculations are based on IRS published rules for Tax Year 2025. Taxpayers are responsible for the accuracy of their returns. For complex situations, consult a licensed CPA or enrolled agent. Federal returns only — state filing requirements vary.

---

## License

MIT
