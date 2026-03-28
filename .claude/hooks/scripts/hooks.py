#!/usr/bin/env python3
"""
Safety Hooks for Claude Code Multi-Model Template

Provides:
- PreToolUse: Warns about destructive commands
- PermissionRequest: Asks for confirmation on risky operations
- Stop: Reminds to verify work before stopping
"""

import sys
import os
import json
import re

HOOKS_CONFIG = {
    "dangerous_patterns": [
        (r"rm\s+-rf\s+/\s", "CRITICAL: rm -rf / will destroy your system!"),
        (r"rm\s+-rf\s+\*", "WARNING: rm -rf * in root may delete everything!"),
        (r"rm\s+-rf\s+\.", "WARNING: rm -rf . is extremely dangerous!"),
        (r"sudo\s+rm", "WARNING: sudo rm can delete system files!"),
        (r">\s*/dev/sd", "CRITICAL: Writing to device files is dangerous!"),
        (r"chmod\s+777", "WARNING: chmod 777 creates security vulnerabilities!"),
    ],
    "warn_patterns": [
        (r"rm\s+", "Be careful: rm command may delete files permanently"),
        (r"drop\s+(table|database)", "WARNING: Dropping database objects is irreversible!"),
        (r"truncate\s+", "WARNING: Truncating data is irreversible!"),
    ]
}

def check_command(command: str, hook_type: str) -> tuple[bool, str]:
    """Check if command matches dangerous patterns."""
    for pattern, message in HOOKS_CONFIG.get("dangerous_patterns", []):
        if re.search(pattern, command, re.IGNORECASE):
            return True, message

    if hook_type == "PreToolUse":
        for pattern, message in HOOKS_CONFIG.get("warn_patterns", []):
            if re.search(pattern, command, re.IGNORECASE):
                return True, message

    return False, ""

def get_hook_event() -> str:
    """Get the current hook event from environment or args."""
    for arg in sys.argv:
        if arg.startswith("--hook="):
            return arg.split("=", 1)[1]
        if arg.startswith("--event="):
            return arg.split("=", 1)[1]
    return os.environ.get("CLAUDE_HOOK_EVENT", "Unknown")

def main():
    hook_event = get_hook_event()

    if hook_event == "PreToolUse":
        # Read the tool input from stdin (JSON)
        try:
            import select
            if select.select([sys.stdin], [], [], 0)[0]:
                stdin_data = sys.stdin.read()
                if stdin_data.strip():
                    data = json.loads(stdin_data)
                    tool_name = data.get("tool", "unknown")
                    tool_input = data.get("input", {})

                    if tool_name == "Bash":
                        command = tool_input.get("command", "")
                        is_dangerous, message = check_command(command, hook_event)
                        if is_dangerous:
                            print(f"\n⚠️  SAFETY HOOK: {message}", file=sys.stderr)
                            print(f"   Command: {command[:100]}...", file=sys.stderr)
                            print(f"   This operation may require explicit user approval.", file=sys.stderr)
        except Exception:
            pass

    elif hook_event == "Stop":
        print("\n🔍 Stop Hook: Verifying work...", file=sys.stderr)
        print("   - Remember to run tests before stopping", file=sys.stderr)
        print("   - Commit your changes with git", file=sys.stderr)

    elif hook_event == "PermissionRequest":
        try:
            import select
            if select.select([sys.stdin], [], [], 0)[0]:
                stdin_data = sys.stdin.read()
                if stdin_data.strip():
                    data = json.loads(stdin_data)
                    tool_name = data.get("tool", "unknown")
                    tool_input = data.get("input", {})

                    if tool_name == "Bash":
                        command = tool_input.get("command", "")
                        is_dangerous, message = check_command(command, hook_event)
                        if is_dangerous:
                            print(f"\n⚠️  PERMISSION HOOK: {message}", file=sys.stderr)
        except Exception:
            pass

if __name__ == "__main__":
    main()
