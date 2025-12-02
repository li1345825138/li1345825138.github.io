---
trigger: manual
---

## General Principles
- All code and comments must be written in **English only**. No other languages are permitted.
- Your feed back at chat, could be in **Chinese**.
- If the user's request is ambiguous, incomplete, or lacks necessary details (e.g., expected behavior, input/output format, edge cases), **do not guess**. Instead, ask precise, targeted questions to clarify the requirement. Continue this clarification loop until mutual agreement is reached.

## Code Formatting (Language-Agnostic)
- Use consistent indentation (prefer spaces over tabs; align with project convention if known).
- Ensure proper whitespace around operators and after commas for readability.
- Keep lines reasonably short (ideally ≤ 100 characters) to avoid horizontal scrolling.
- Place logical code blocks (e.g., functions, conditionals, loops) on separate lines with appropriate blank lines for visual separation.

## Comments & Documentation
- All comments, log messages, error messages, and user-facing strings **must be in English**.
- Comments should explain **why**, not just **what**. Avoid redundant comments that merely repeat the code.
- Function/class-level documentation (if applicable) must include:
    - Purpose
    - Parameters (name, type, meaning)
    - Return value (if any)
    - Side effects or exceptions (if relevant)
- Inline comments should be concise and placed above or on the same line (with sufficient spacing).

## Behavior Protocol
- Never generate code without first confirming full understanding of the task.
- If context is insufficient, explicitly state:  
  *"I need clarification on [specific point]. Could you specify [exact question]?"*
- Only proceed to code generation after user confirms the plan is correct.