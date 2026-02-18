#!/bin/bash
# TaxClaw Project Setup Script
# Run this from inside your ~/development/taxclaw folder
# Usage: bash setup-taxclaw.sh

set -e

echo "🏗️  Setting up TaxClaw project structure..."
echo ""

# Verify we're in the right place
CURRENT_DIR=$(basename "$PWD")
if [ "$CURRENT_DIR" != "taxclaw" ]; then
    echo "⚠️  Warning: You're not in a folder called 'taxclaw'."
    echo "   Current folder: $PWD"
    read -p "   Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting. cd into your taxclaw folder first."
        exit 1
    fi
fi

# Create directory structure
echo "📁 Creating directories..."
mkdir -p skill
mkdir -p tests/scenarios
mkdir -p .claude/agents

# Initialize git if not already
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repo..."
    git init
    git checkout -b main
else
    echo "📦 Git repo already exists, skipping init."
fi

# ============================================================
# CLAUDE.md — Project Context (Claude Code reads this automatically)
# ============================================================
echo "📝 Creating CLAUDE.md..."
cat > CLAUDE.md << 'CLAUDE_EOF'
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
CLAUDE_EOF

# ============================================================
# .claude/agents/tax-validator.md — Validation Subagent
# ============================================================
echo "📝 Creating .claude/agents/tax-validator.md..."
cat > .claude/agents/tax-validator.md << 'VALIDATOR_EOF'
---
name: tax-validator
description: Validates tax calculations, cross-checks form mappings, and verifies consistency across all TaxClaw files. Use after building or modifying any tax-related file.
tools:
  - Read
  - Grep
  - Glob
  - Bash
---

You are a tax calculation validator. Your job is to verify accuracy and consistency across TaxClaw's skill files.

When invoked, perform these checks:

1. CROSS-REFERENCE CHECK: Verify that every form mentioned in CLAUDE.md has matching extraction instructions in SKILL.md AND that every box-to-1040 mapping is consistent between SKILL.md and tax-rules.md.

2. CALCULATION VERIFICATION: For each test scenario in tests/scenarios/, independently calculate the correct answer using tax-rules.md and compare against the scenario's expected result.

3. THRESHOLD CONSISTENCY: Verify that all dollar thresholds, phaseout ranges, and credit amounts in SKILL.md match tax-rules.md exactly.

4. ESCALATION COMPLETENESS: Verify that every form listed in CLAUDE.md's "Detect and Escalate" section has a corresponding escalation trigger in SKILL.md's decision tree.

5. TEMPLATE INTEGRITY: Verify that intake-template.md covers every data field that SKILL.md collects during the interview.

Report findings as:
- ✅ PASS: [what was verified]
- ❌ FAIL: [what's wrong, where, and the correct value]
- ⚠️ WARNING: [potential issues that need human review]

Write your full report to tests/validation-report.md.
VALIDATOR_EOF

# ============================================================
# .claude/agents/irs-researcher.md — IRS Research Subagent
# ============================================================
echo "📝 Creating .claude/agents/irs-researcher.md..."
cat > .claude/agents/irs-researcher.md << 'RESEARCHER_EOF'
---
name: irs-researcher
description: Researches and verifies tax rules, thresholds, and form instructions from IRS.gov. Use when building or updating tax-rules.md or when any tax number needs verification.
tools:
  - Read
  - Bash
---

You are an IRS tax research specialist. Your job is to find and verify tax information from official IRS sources.

When asked about any tax number, threshold, or rule:
1. Search IRS.gov for the specific topic
2. Find the relevant Revenue Procedure, Publication, or Form Instructions
3. Extract the EXACT number with its source citation
4. Format as: "[number] — Source: IRS [Publication/Rev Proc] [number], [section]"

Primary sources in order of authority:
- Revenue Procedures (e.g., Rev. Proc. 2024-40 for 2025 inflation adjustments)
- IRS Publications (e.g., Pub 17, Pub 501, Pub 596)
- Form Instructions (e.g., 1040 Instructions, Form 8863 Instructions)
- IRS.gov topic pages

NEVER provide a number without a source citation. If uncertain, say so.
RESEARCHER_EOF

# ============================================================
# Placeholder files for the skill directory
# ============================================================
echo "📝 Creating skill file placeholders..."

cat > skill/SKILL.md << 'SKILL_EOF'
# TaxClaw Skill — Placeholder

This file will be built by Claude Code Agent 1.
See the build guide for the full prompt to use.

Remove this placeholder content before building.
SKILL_EOF

cat > skill/tax-rules.md << 'RULES_EOF'
# TaxClaw Tax Rules — Placeholder

This file will be built by Claude Code Agent 2.
See the build guide for the full prompt to use.

Remove this placeholder content before building.
RULES_EOF

cat > skill/escalation-config.md << 'CONFIG_EOF'
# TaxClaw Escalation Config — Placeholder

This file will be built by Claude Code Agent 3.
See the build guide for the full prompt to use.

Remove this placeholder content before building.
CONFIG_EOF

cat > skill/intake-template.md << 'TEMPLATE_EOF'
# TaxClaw Intake Template — Placeholder

This file will be built by Claude Code Agent 3.
See the build guide for the full prompt to use.

Remove this placeholder content before building.
TEMPLATE_EOF

# ============================================================
# .gitignore
# ============================================================
echo "📝 Creating .gitignore..."
cat > .gitignore << 'GITIGNORE_EOF'
# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
*.swp
*.swo
*~

# Claude Code local settings (don't share personal config)
.claude/settings.local.json

# Node (if any tooling added later)
node_modules/
GITIGNORE_EOF

# ============================================================
# README.md — starter
# ============================================================
echo "📝 Creating README.md..."
cat > README.md << 'README_EOF'
# TaxClaw: Your AI Tax Prep Assistant

> Send me your W-2 and I'll tell you your refund in 2 minutes. Free. Private. No upsells.

An OpenClaw skill that helps US individual taxpayers prepare their federal tax returns through conversational AI.

## Status: 🚧 Under Development

Built for Tax Year 2025 (filing in 2026).

## Supported Forms
- W-2, 1099-INT, 1099-DIV, 1099-G, 1099-R, SSA-1099, 1098-E, 1098-T
- Complex situations (freelance, investments, crypto, rental) → referred to CPA partner

## Installation
```
clawhub install taxclaw
```

## License
[TBD]
README_EOF

# ============================================================
# Initial git commit
# ============================================================
echo ""
echo "📦 Creating initial git commit..."
git add -A
git commit -m "feat: initial TaxClaw project structure

- CLAUDE.md with full project context
- Custom subagents (tax-validator, irs-researcher)
- Skill directory with placeholder files
- Tests directory structure
- README with project overview"

echo ""
echo "============================================"
echo "✅ TaxClaw project setup complete!"
echo "============================================"
echo ""
echo "Your project structure:"
echo ""
find . -not -path './.git/*' -not -path './.git' | sort | head -25
echo ""
echo "============================================"
echo "NEXT STEPS:"
echo "============================================"
echo ""
echo "1. You're ready to start building with Claude Code."
echo "   The CLAUDE.md is already in place — Claude Code"
echo "   will read it automatically when you start a session."
echo ""
echo "2. To build files IN PARALLEL (recommended):"
echo "   Create git worktrees for each agent:"
echo ""
echo "   git worktree add ../taxclaw-skill -b feature/skill-core"
echo "   git worktree add ../taxclaw-rules -b feature/tax-rules"
echo "   git worktree add ../taxclaw-cpa -b feature/cpa-integration"
echo ""
echo "   Then open 3 iTerm2 tabs:"
echo "   Tab 1: cd ~/development/taxclaw-skill && claude"
echo "   Tab 2: cd ~/development/taxclaw-rules && claude"
echo "   Tab 3: cd ~/development/taxclaw-cpa && claude"
echo ""
echo "3. To build files SEQUENTIALLY (simpler):"
echo "   Just stay in this folder and run: claude"
echo "   Then paste the prompts from the build guide one at a time."
echo ""
echo "4. Use the build guide (in your Claude chat) for the"
echo "   detailed prompts to paste into each Claude Code session."
echo ""
