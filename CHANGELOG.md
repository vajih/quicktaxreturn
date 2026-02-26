# Changelog

All notable changes to QuickTaxReturn are documented here. This project follows [Semantic Versioning](https://semver.org/).

---

## [1.0.0] — 2026-02-24

### Initial release

**Skill behavior (`skill/SKILL.md`)**

- Full interview flow: OPEN → TRIAGE → FILING STATUS → PERSONAL INFO → DOCUMENTS → ADJUSTMENTS → DEDUCTION CHECK → CREDITS → CALCULATE → PRESENT → EXIT
- All filing statuses: Single, MFJ, MFS, HOH, Qualifying Surviving Spouse
- Triage in first 3–5 questions — detects out-of-scope situations before document collection begins
- Dependent qualification logic (qualifying child vs. qualifying relative, CTC eligibility)
- Age 65+/blind additional standard deduction
- Explicit bracket-by-bracket arithmetic for all four filing status tables
- AMT check with escalation if triggered
- Additional Medicare Tax detection at $250k (MFJ)
- Qualified dividend / capital gain preferential rate routing
- Three exit paths: DIY filing, CPA handoff (with intake package), advisory
- Post-calculation planning opportunities (IRA deadline, W-4 adjustment, Saver's Credit)
- 14 edge case and error-handling procedures

**In-scope forms and calculations**

- W-2: wages, withholding, Box 12 codes (D/W/AA/BB/G/E), excess SS withholding check
- 1099-INT: taxable interest, Schedule B threshold check ($1,500)
- 1099-DIV: ordinary / qualified dividends, capital gain distributions
- 1099-R: codes 1/2/3/4/7/G — early withdrawal penalty, IRA vs. pension routing
- SSA-1099: full Social Security taxability worksheet (0% / 50% / 85% tiers)
- 1099-G: unemployment compensation, state refund taxability determination
- 1098-E: student loan interest deduction with MAGI phase-out
- 1098-T: AOTC ($2,500, 40% refundable) and LLC ($2,000) with MAGI phase-out
- Child Tax Credit ($2,200/child) with phase-out and ACTC refundable portion ($1,700/child)
- Earned Income Tax Credit (EITC) — all four child categories, both MFJ and other statuses
- Child and Dependent Care Credit (Form 2441)
- IRA deduction with active-participant and spousal coverage phase-outs
- HSA direct contribution deduction
- Educator expenses ($300 / $600 MFJ)

**Tax rules (`skill/tax-rules.md`)**

- All four bracket tables (TY2025): MFJ, HOH, Single, MFS — from Rev. Proc. 2024-40
- Standard deductions for all filing statuses, including age/blind add-ons
- CTC/ACTC per Schedule 8812 Instructions (January 23, 2026) — $2,200/$1,700
- EITC phase-in/phase-out rates and amounts for all categories — Rev. Proc. 2024-40
- Education credit phase-out ranges — Form 8863 Instructions (2025)
- Student loan interest phase-out ranges
- Social Security taxability thresholds and complete §7c worksheet formulas (both tiers)
- FICA rates and $176,100 SS wage base — IRS Publication 15 (2025)
- LTCG / qualified dividend rates (0% / 15% / 20%) for all filing statuses
- AMT exemptions and phase-out thresholds
- Retirement contribution limits (401k, IRA, SIMPLE) — IRS Notice 2024-80
- IRA deduction phase-out ranges including spousal coverage rules
- Form-to-1040-line mapping reference table
- 1099-R Box 7 distribution code reference table
- Bracket calculation examples (single, MFJ, ACTC, SS taxability)

**CPA escalation (`skill/escalation-config.md`)**

- Four-tier escalation taxonomy (Triage / Document Receipt / Calculation / Soft Flag)
- Five conversation scripts (A–E) for consistent handoff language
- Three exit path definitions with agent action steps
- CPA partner configured: M.S.Ayubi CPA PLLC (Aisha Moin, CPA — The Woodlands, TX)
- Referral tracking UTM parameters

**CPA handoff package (`skill/intake-template.md`)**

- 10-section structured intake document
- Taxpayer identity, dependents, income documents, adjustments, credits, life changes
- Notes section for context from QuickTaxReturn session
- Pre-populated from collected session data; reduces CPA billable time

**Test coverage (`tests/scenarios/`)**

- 10 hand-calculated scenarios with exact expected outputs:
  01 Single W-2 only | 02 MFJ + CTC | 03 HOH + EITC + ACTC | 04 MFJ retirees + SS
  05 AOTC education | 06 Early IRA withdrawal | 07 Qualified dividends + SLI
  08 CTC phase-out $420k | 09 Self-employment escalation | 10 SS 85% tier

**ClawHub publishing**

- `clawhub.yaml` marketplace manifest with full metadata
- MIT license

---

## Annual Update Process

Each November after IRS releases the new Revenue Procedure:

1. Update `skill/tax-rules.md` — new brackets, deductions, credits, EITC, SS limits
2. Update CTC if legislation changed it (check Schedule 8812 Instructions release date)
3. Update SS wage base (IRS Publication 15)
4. Update retirement limits (IRS Notice — typically late October)
5. Update `skill/escalation-config.md` — confirm CPA pricing is current
6. Update all 10 test scenarios with new year's numbers
7. Update `version` in `clawhub.yaml`
8. Tag a new release: `git tag vX.Y.Z`
