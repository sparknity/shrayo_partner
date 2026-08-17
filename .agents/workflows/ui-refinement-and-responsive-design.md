---
description: Responsive Flutter UI enforcement + Figma fidelity check activation: always_on
---


# Responsive UI & Overflow Guard

On every UI-related prompt (screens, widgets, layouts), before finishing your response:

1. **Check for overflow risks**
   - Flag any `Row`/`Column` that isn't wrapped in `Flexible`, `Expanded`, or scrollable
     ancestors when children could exceed available space.
   - Watch for fixed `width`/`height` values that won't adapt to smaller screens
     (use `MediaQuery`, `LayoutBuilder`, or percentage-based sizing instead).
   - Text widgets near the edge of constrained space should have `overflow:
     TextOverflow.ellipsis`, `softWrap`, or `maxLines` set explicitly.
   - Wrap scrollable content in `SingleChildScrollView` or `ListView` where content
     length is dynamic (e.g. user-generated text, lists of variable length).

2. **Verify responsiveness across breakpoints**
   - Every screen must render correctly on: small phones (~360dp width), standard
     phones (~412dp), and tablets (~768dp+).
   - Use `LayoutBuilder`, `MediaQuery.of(context).size`, or a responsive package
     (e.g. `flutter_screenutil`) — never hardcode pixel values for spacing/sizing
     unless justified (e.g. icon size).
   - Prefer `Expanded`/`Flexible`/`Wrap` over fixed-width rows for adaptive layouts.

3. **Match Figma spec**
   - Cross-check spacing, font sizes, colors, and component proportions against the
     Figma frame referenced in the prompt (or the "Elder-Care-Prototype-Client"
     project if none is specified).
   - Call out any deviation from Figma explicitly rather than silently
     approximating it.

4. **Fix, don't just flag**
   - If you generate or edit a widget and detect a likely overflow or non-responsive
     pattern, fix it in the same response — don't leave a TODO unless the fix
     needs a design decision from me.

5. **Report back briefly**
   - After the code, add a short checklist: what was checked, what was fixed, and
     any Figma mismatch that needs my confirmation.