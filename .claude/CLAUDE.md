# User-Level Claude Code Configuration

This file contains user-level instructions that apply across all projects.

## Agent Delegation

**IMPORTANT: Always use the git agent for git operations.**

When the user asks to commit, push, create branches, or perform any git operation, you MUST use the Task tool with `subagent_type: "git"` instead of running git commands directly. This ensures proper confirmation workflows and consistent commit formatting.

Examples of requests that MUST use the git agent:
- "commit" / "commit my changes" / "commit this"
- "push" / "push to origin"
- "create a branch" / "switch to branch X"
- "show me the diff" / "what changed"
- Any other git-related request

## Commit Confirmation Format

**CRITICAL: When displaying commit confirmations from the git agent, you MUST use this EXACT format:**

═══════════════════════════════════════
        READY TO COMMIT
═══════════════════════════════════════

Stage:
  - path/to/file1.ts
  - path/to/file2.ts

Message: JIRA-123: fix: Summary of changes
  - First change detail
  - Second change detail

═══════════════════════════════════════
Proceed? (yes/no)

**Rules:**
- Always use the ═══ box characters exactly as shown
- Always include "READY TO COMMIT" header
- List files under "Stage:"
- Show the full commit message under "Message:"
- End with "Proceed? (yes/no)"
- Do NOT use alternative formats like "Files to commit:" or "Proposed commit message:"

## Preferences

- Prefer concise responses unless asked for detail

## Project-Specific Patterns

- StudyTrax: Follow Angular conventions, use Jira keys (ST-XXXX) in commits
