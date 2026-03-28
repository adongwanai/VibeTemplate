---
name: self-test-template
description: Run the template self-test and interpret failures before using the template on a real project.
---

# Self-Test Template

Run this skill whenever you change the template or before trusting it on a fresh project.

## Command

```bash
bash scripts/self-test.sh
```

## Interpret Results

- missing command or skill file → scaffold drift
- hook compile failure → Python hook path or syntax issue
- `.gitignore` failure → plan files will not be versioned correctly
- settings mismatch → Claude will save plans in the wrong place
- template smoke failure → review `test-template.js`

## Rule

Do not declare the template ready until `bash scripts/self-test.sh` exits zero.
