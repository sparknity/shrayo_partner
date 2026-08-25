---
description: Universal Responsive Flutter UI enforcement — forms & inputs, OutlineInputBorder styling, fixed typography, headers, Figma fidelity, modal buttons, and card metadata overflow prevention
---

# Flutter UI Quality Rule & Workflow

Apply this on every prompt that touches UI (screens, widgets, forms, layouts) — whether building something new or editing existing code. Don't wait to be asked "check responsiveness" — apply it automatically every time.

---

## 1. Text Inputs & Form Fields — Universal Responsive Input UI Rule

This rule applies to **ALL** text inputs across the entire application (form fields, search bars, modal inputs, number fields, multiline text areas).

### 🚫 Prohibited Anti-Patterns
- **NEVER wrap `TextField` / `TextFormField` in a fixed-height `Container(height: X, ...)` with `border: InputBorder.none`**. This clips text vertically, breaks cursor positioning on font scale changes, and strips native focus/error border states.
- **NEVER attach BOTH `controller.addListener(...)` calling `setState` AND `onChanged: (...)` calling `setState`**. Firing duplicate state updates during keyboard composition causes the IME to duplicate characters ("double input" bug). Use a single unidirectional handler.

### ✅ Standard Responsive Input Template
All text inputs must use native `InputDecoration` with `OutlineInputBorder` and explicit focus/error states:

```dart
TextField( // or TextFormField
  controller: _controller,
  textInputAction: TextInputAction.search, // or next / done
  onTapOutside: (_) => FocusScope.of(context).unfocus(),
  onChanged: (val) {
    setState(() => _query = val.trim());
  },
  style: const TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: Color(0xFF0F172A),
  ),
  decoration: InputDecoration(
    hintText: 'Enter text here...',
    hintStyle: const TextStyle(
      color: Color(0xFF94A3B8),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
    suffixIcon: _query.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.cancel, color: Color(0xFF94A3B8), size: 18),
            onPressed: () {
              _controller.clear();
              setState(() => _query = '');
            },
          )
        : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF0052CC), width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.8),
    ),
  ),
)
```

### 📐 Form Screen Layout Rules
- **Scrollability**: Wrap every form/input screen in `SingleChildScrollView` (or `ListView`) so it never overflows when the keyboard opens.
- **Parent-Driven Width**: Never give text fields fixed pixel widths. Let them flex with `Expanded`, `Flexible`, or fill horizontal padding to adapt across phone (~360dp, ~412dp) and tablet (~768dp+) widths.
- **Multi-Field Rows**: Multi-field rows (e.g. First Name / Last Name) must wrap or collapse to single-column on narrow widths rather than squeezing fields.
- **Keyboard Insets**: Use `resizeToAvoidBottomInset: true` on the `Scaffold` so bottom submit buttons are never clipped by the virtual keyboard.

---

## 1b. Action & Modal Bottom Sheet Buttons (Emergency & Medicines Rule)

Buttons inside modals, confirmation bottom sheets, and cards must maintain high usability and contrast:

- **Touch Target & Height**: Modal action buttons (e.g. Cancel & Confirm) and card action buttons (e.g. "View Hospital on Map", "Mark as Given") must have a minimum height of **46–48dp**.
- **Clear Visual Hierarchy**:
  - **Secondary / Cancel Button**: High-contrast outline or solid white/slate surface (`side: BorderSide(color: Color(0xFFCBD5E1), width: 1.5)`), readable text (`fontSize: 14.5–15`, `fontWeight: FontWeight.w700`, color: `#334155`).
  - **Primary / Confirm Button**: Filled theme color (`#0052CC` or `#16A34A`), white text (`color: Colors.white`, `fontWeight: FontWeight.w800`, `fontSize: 14.5–15`).
- **No Text Squeezing or Clipping**: Never use fixed-width buttons that can clip translated or longer action text. Wrap button labels with `FittedBox(fit: BoxFit.scaleDown)` or let them expand evenly (`Row` with `Expanded` children).
- **Human-Readable Action Text**: Use clear, descriptive action text (e.g. "View Hospital on Map", "Confirm", "Cancel", "Call Ambulance (911)") rather than generic or unstyled labels. Always provide interactive SnackBar or navigation feedback on tap.

---

## 1c. Cards, Badges & Multi-Item Metadata Rows (Vaccination & Timeline Rule)

Multi-item metadata cards must never trigger horizontal renderflex overflows on narrow screens:

- **Title & Badge Header Rows**:
  - When placing entity titles next to a status badge (e.g. `COVID-19 Booster (Pfizer)` next to `Completed` badge), wrap the title column in `Expanded` and set `softWrap: true` so multi-word medical titles wrap gracefully onto two lines without pushing badges off-screen.
- **Sub-Metadata & Facility/Batch Rows**:
  - Do NOT place two independent metadata strings (e.g. `Facility: St. Jude Medical Center` and `Batch: TDP-2020-001`) in a rigid `Row(mainAxisAlignment: MainAxisAlignment.spaceBetween)` without flex constraints.
  - **Always use `Wrap`** (`alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, runSpacing: 4`) so that long facility or provider names automatically wrap to the next line on ~360dp viewports instead of overflowing by 10–20px.
- **Content Boundaries**: Constrain top-level layout with `ConstrainedBox(constraints: BoxConstraints(maxWidth: 800))` inside a centered `SafeArea` for consistent tablet/desktop presentation.

---

## 2. Typography — Fixed, Never Device-Scaled

The app's text size must look identical for every user, regardless of their phone's system font-size/accessibility settings. Do NOT let OS text scaling break the layout.

- At the root of the app (`MaterialApp` / `MaterialApp.router`), disable system text scaling globally using a builder:
```dart
MaterialApp.router(
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: child!,
    );
  },
  ...
)
```
- Never rely on the default `textScaleFactor` from the device. All font sizes must come from a single fixed typography source (`AppTextStyles` or theme `TextTheme`).
- Flag and fix any widget using raw `Text('...', style: TextStyle(fontSize: X))` with ad-hoc sizes instead of pulling from the shared design system.

---

## 3. Headers — Consistent, Proper Structure

Every screen's header/app bar must follow one consistent pattern, matching Figma, not be rebuilt ad hoc per screen.

- Use a single shared header widget (`CustomAppBar` / `VisitAppBar` / standard `AppBar`) reused across all screens.
- Header height, padding, back-button style/position, title alignment, and font must be pixel-matched to the Figma header spec.
- Respect `SafeArea` / notch and status bar insets — header content must never sit under the status bar.
- Long titles must truncate with ellipsis (`overflow: TextOverflow.ellipsis`) or wrap cleanly.
- Verify header behaves correctly when the keyboard is open or when scrolling.

### 3a. Only One Header Per Screen — Resolve Duplicates

- A screen gets exactly ONE header. Never stack a generic AppBar and a second card-style greeting/header block with duplicate bells or avatar icons.
- If two header variants conflict, pick the one with better information density and Figma fidelity, merge essential elements, and remove redundant duplicates.

---

## 4. Figma Fidelity

- Cross-check spacing, colors, font sizes, corner radius, and component proportions against the relevant Figma frame (`Developer handoff (5)`).
- Explicitly call out any deviation from Figma instead of silently approximating.

---

## 5. Fix, Don't Just Flag

If you generate or edit a widget and detect an overflow, non-responsive pattern, unwanted font scaling, or inconsistent header, fix it immediately in the same response.

---

## 6. Report Back Checklist

After writing UI code, include a short checklist covering:

1. **Universal Input & Form UI**: Confirmed native `OutlineInputBorder` (idle `#CBD5E1` + focused `#0052CC`), no fixed-height Container wrapping, no duplicate controller listener/onChanged, `onTapOutside` keyboard dismiss, and `SingleChildScrollView`.
2. **Modal & Action Button UI**: Confirmed 46–48dp minimum heights, high-contrast labels, and clear primary/secondary visual hierarchy.
3. **Card & Metadata Overflow Prevention**: Confirmed `softWrap: true` on titles and `Wrap` on multi-item metadata rows (e.g. Facility + Batch) to prevent renderflex overflow on ~360dp widths.
4. **Font Scaling**: Locked to fixed size (confirmed no OS accessibility text scaling leakage).
5. **Header Consistency**: Single header with proper back navigation and pixel-matched Figma styling.