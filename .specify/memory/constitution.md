<!--
Sync Impact Report:
- Version Change: Initial creation → 1.0.0
- New Constitution: PEPFAR MER App Constitution established
- Added Principles:
  1. Offline-First Architecture
  2. User-Centered Design
  3. Data Integrity & Accuracy
  4. Modern UI Standards
  5. Performance & Responsiveness
- Templates Status:
  ✅ plan-template.md - reviewed, aligned with constitution gates
  ✅ spec-template.md - reviewed, aligned with user story prioritization
  ✅ tasks-template.md - reviewed, aligned with principle-driven task types
- Follow-up TODOs: None - all placeholders filled
-->

# PEPFAR MER Quick Reference App Constitution

## Core Principles

### I. Offline-First Architecture

**All app functionality MUST work without internet connectivity.**

The PEPFAR MER Quick Reference App is designed as a complete offline reference tool. This means:
- All indicator data, definitions, and content MUST be bundled with the app
- Search, filtering, and comparison features MUST function without network calls
- Data updates occur through app updates, not runtime downloads
- No user authentication or cloud synchronization required

**Rationale**: Field health workers in PEPFAR-supported regions often operate in areas with unreliable or no internet connectivity. The app must be a reliable reference tool regardless of network availability.

### II. User-Centered Design

**UI/UX decisions MUST prioritize clarity, simplicity, and quick information access.**

Design requirements:
- Modern, clean interface with ample white space (Grial UI kit style)
- Card-based layouts for content organization
- Maximum 2-second load time for any screen
- Intuitive navigation patterns (grid tiles, bottom nav, search)
- Consistent visual hierarchy across all screens
- Accessible color contrast and font sizing

**Rationale**: Healthcare professionals need to quickly reference indicators during reporting periods. The interface must not impede their workflow with complexity or slow performance.

### III. Data Integrity & Accuracy

**All MER indicator data MUST be verified against official PEPFAR documentation before inclusion.**

Data governance rules:
- Indicator definitions must match official PEPFAR MER guidance (version tracked)
- Numerator/denominator specifications must be exact
- Disaggregation categories must be complete and current
- Source attribution required for all indicators (e.g., "PEPFAR MER 2.6 (2024)")
- Version of MER guidance must be clearly displayed in the app

**Rationale**: Incorrect indicator definitions could lead to reporting errors affecting millions of dollars in program funding and patient care decisions. Data accuracy is non-negotiable.

### IV. Modern UI Standards

**The app MUST follow platform-specific design guidelines and modern Flutter best practices.**

Technical requirements:
- Material Design 3 (Material You) for Android
- Cupertino widgets for iOS platform-specific screens where appropriate
- Responsive layouts supporting phones and tablets
- Dark mode support with proper contrast ratios (WCAG AA minimum)
- Smooth animations and transitions (60fps target)
- Proper state management (Provider, Riverpod, or Bloc pattern)

**Rationale**: Users expect native-quality experiences. Following platform conventions reduces cognitive load and ensures the app feels professional and trustworthy.

### V. Performance & Responsiveness

**The app MUST maintain excellent performance even with hundreds of indicators.**

Performance standards:
- Cold start time: < 3 seconds
- Screen transitions: < 300ms
- Search results: < 500ms for any query
- Memory footprint: < 150MB during normal operation
- APK/IPA size: < 50MB (excluding platform overhead)
- Support devices 3+ years old (minimum Android 8.0, iOS 13.0)

**Rationale**: Healthcare workers may use older devices or devices shared among teams. The app must run smoothly across a range of hardware capabilities.

## Additional Requirements

### Maintainability

**Content updates MUST be achievable without code changes.**

- Indicator data stored in JSON format or SQLite database
- Data files can be replaced for content updates
- Clear data schema documentation maintained
- Migration scripts for schema changes (if using SQLite)

### Localization Readiness

**The app architecture MUST support future multilingual expansion.**

- Use Flutter's localization framework (flutter_localizations)
- All user-facing strings externalized to ARB files
- UI layouts must accommodate text expansion (30% buffer)
- Initial release: English only; architecture must support French, Spanish, Portuguese additions

### Testing Standards

**All core features MUST have automated test coverage.**

Testing requirements:
- Widget tests for all custom UI components
- Integration tests for critical user journeys (search, favorites, indicator detail)
- Unit tests for data models and business logic
- Manual testing checklist for each release

## Development Workflow

### Feature Development Process

1. **Specification**: Features documented using spec-template.md with prioritized user stories
2. **Planning**: Implementation plan created using plan-template.md with constitution gate checks
3. **Development**: Code follows Flutter best practices and passes linting
4. **Testing**: Automated tests written and passing before code review
5. **Review**: Code review checklist includes constitution compliance verification
6. **Documentation**: User-facing features documented in app or README

### Quality Gates

Before any release:
- ✅ All automated tests passing
- ✅ No lint errors or warnings
- ✅ Manual testing checklist completed
- ✅ Data accuracy verified against official PEPFAR documentation
- ✅ Performance benchmarks met on target devices
- ✅ Dark mode contrast verified (WCAG AA)

## Governance

### Amendment Process

Changes to this constitution require:
1. Documentation of the proposed change and rationale
2. Impact assessment on existing features and templates
3. Version bump following semantic versioning
4. Update to all dependent templates and documentation

### Versioning Policy

Constitution versions follow **MAJOR.MINOR.PATCH** format:
- **MAJOR**: Backward-incompatible principle changes or removals
- **MINOR**: New principles added or material expansions to existing ones
- **PATCH**: Clarifications, wording improvements, non-semantic changes

### Compliance Review

- All pull requests must include a constitution compliance statement
- Quarterly review of adherence to performance and data accuracy standards
- Post-release retrospective examines constitution effectiveness

### Dispute Resolution

When constitution principles conflict:
1. Data Integrity & Accuracy takes precedence over UI preferences
2. Offline-First Architecture takes precedence over feature richness
3. Performance & Responsiveness cannot be compromised for visual enhancements
4. Document the conflict and resolution in the relevant spec or plan

**Version**: 1.0.0 | **Ratified**: 2025-10-07 | **Last Amended**: 2025-10-07