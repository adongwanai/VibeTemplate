#!/usr/bin/env node
/**
 * Template Self-Test
 * Verifies the multi-model template structure is correctly set up
 */

const fs = require('fs');
const path = require('path');

const REQUIRED_FILES = [
  'AGENTS.md',
  'ARCHITECTURE.md',
  'RELIABILITY.md',
  'CLAUDE.md',
  '.claude/settings.json',
  '.claude/rules/coding-style.md',
  '.claude/rules/security.md',
  '.claude/rules/git-workflow.md',
  '.claude/skills/plan-architecture/SKILL.md',
  '.claude/skills/generate-with-codex/SKILL.md',
  '.claude/skills/mutual-review/SKILL.md',
  '.claude/skills/execute-with-codex/SKILL.md',
  '.claude/skills/recover-failed-wave/SKILL.md',
  '.claude/skills/self-test-template/SKILL.md',
  '.claude/agents/architect.md',
  '.claude/agents/codex-executor.md',
  '.claude/agents/reviewer.md',
  '.claude/commands/24h-loop.md',
  '.claude/commands/plan-architecture.md',
  '.claude/commands/generate-with-codex.md',
  '.claude/commands/mutual-review.md',
  '.claude/commands/execute-codex-phase.md',
  '.claude/commands/codex-status.md',
  '.mcp.json',
  '.gitignore',
  'README.md',
  '.planning/config.json',
  'scripts/bootstrap-gsd.sh',
  'scripts/start-new-project.sh',
  'scripts/clean-runtime.sh',
  'scripts/codex-runner-example.sh',
  'scripts/execute-codex-phase.sh',
  'scripts/reconcile-wave.sh',
  'scripts/watchdog.sh',
  'scripts/self-test.sh',
  'templates/codex-task.md',
  'templates/codex-fix.md',
  'templates/codex-verify.md',
  'queue/failed/.gitkeep',
  'queue/pending-review/.gitkeep',
  'runtime/logs/.gitkeep',
  'runtime/checkpoints/.gitkeep',
];

const REQUIRED_HOOKS = [
  '.claude/hooks/scripts/hooks.py',
];

let allPassed = true;

console.log('🔍 Multi-Model Template Self-Test\n');

for (const file of REQUIRED_FILES) {
  const filePath = path.join(__dirname, file);
  const exists = fs.existsSync(filePath);
  const status = exists ? '✅' : '❌';
  console.log(`${status} ${file}`);
  if (!exists) allPassed = false;
}

for (const file of REQUIRED_HOOKS) {
  const filePath = path.join(__dirname, file);
  const exists = fs.existsSync(filePath);
  const status = exists ? '✅' : '❌';
  console.log(`${status} ${file}`);
  if (!exists) allPassed = false;
}

// Verify JSON files are valid
console.log('\n📋 JSON Validation:');
const jsonFiles = ['.claude/settings.json', '.mcp.json', 'package.json'];
for (const file of jsonFiles) {
  const filePath = path.join(__dirname, file);
  try {
    JSON.parse(fs.readFileSync(filePath, 'utf8'));
    console.log(`✅ ${file} is valid JSON`);
  } catch (e) {
    console.log(`❌ ${file} is invalid: ${e.message}`);
    allPassed = false;
  }
}

// Verify Python hooks syntax
console.log('\n🐍 Python Hooks Validation:');
const hookPath = path.join(__dirname, '.claude/hooks/scripts/hooks.py');
try {
  const { execSync } = require('child_process');
  execSync(`python3 -m py_compile "${hookPath}"`, { encoding: 'utf8' });
  console.log('✅ hooks.py syntax is valid');
} catch (e) {
  console.log('❌ hooks.py syntax error');
  allPassed = false;
}

console.log('\n🧭 Config Validation:');
try {
  const settings = JSON.parse(fs.readFileSync(path.join(__dirname, '.claude/settings.json'), 'utf8'));
  if (settings.plansDirectory === './docs/plans') {
    console.log('✅ plansDirectory points to docs/plans');
  } else {
    console.log(`❌ plansDirectory mismatch: ${settings.plansDirectory}`);
    allPassed = false;
  }
} catch (e) {
  console.log(`❌ Unable to validate settings.json: ${e.message}`);
  allPassed = false;
}

const gitignore = fs.readFileSync(path.join(__dirname, '.gitignore'), 'utf8');
if (gitignore.includes('docs/plans/*.md')) {
  console.log('❌ .gitignore still blocks docs/plans/*.md');
  allPassed = false;
} else {
  console.log('✅ docs/plans markdown files are versionable');
}

try {
  const config = JSON.parse(fs.readFileSync(path.join(__dirname, '.planning/config.json'), 'utf8'));
  const configOk = config.mode === 'yolo' && config.parallelization === true && config.workflow && config.workflow.auto_advance === true;
  if (configOk) {
    console.log('✅ GSD config defaults are automation-friendly');
  } else {
    console.log('❌ GSD config is missing yolo/parallelization/auto_advance defaults');
    allPassed = false;
  }
} catch (e) {
  console.log(`❌ Unable to validate .planning/config.json: ${e.message}`);
  allPassed = false;
}

const readme = fs.readFileSync(path.join(__dirname, 'README.md'), 'utf8');
if (readme.includes('template/gsd-default') && readme.includes('template/claude-codex-default') && readme.includes('GSD + superpowers')) {
  console.log('✅ README includes branch navigation and workflow guidance');
} else {
  console.log('❌ README is missing branch navigation or workflow guidance');
  allPassed = false;
}

const agents = fs.readFileSync(path.join(__dirname, 'AGENTS.md'), 'utf8');
if (agents.includes('README.md') && agents.includes('CLAUDE.md') && agents.includes('ARCHITECTURE.md') && agents.includes('RELIABILITY.md')) {
  console.log('✅ AGENTS.md points to the core docs');
} else {
  console.log('❌ AGENTS.md is missing core doc references');
  allPassed = false;
}

console.log('\n' + (allPassed ? '✅ All tests passed!' : '❌ Some tests failed'));
process.exit(allPassed ? 0 : 1);
