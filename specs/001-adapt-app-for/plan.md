# Implementation Plan: NIDS App - South African National Indicators

**Branch**: `001-adapt-app-for` | **Date**: 2025-10-07 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/001-adapt-app-for/spec.md`

## Summary

Transform the PEPFAR MER Quick Reference App into NIDS (National Indicator Data Set) - a South African Department of Health branded application for accessing national health indicators. Replace PEPFAR-specific indicators with South African national indicator data organized by reporting groups (Routine Facility Health Services, Routine ART Quarterly, TB Quarterly, etc.). Add first-launch user role selection (Nurse, Doctor, Data Clerk, etc.) for future personalization. Implement official government branding with coat of arms, government green color scheme, and redesigned home screen with search bar, navigation cards, and summary statistics.

**Technical Approach**: Extend existing Flutter app architecture by adapting data models to support SA indicator schema (Reno/ID, Group ID, Sort Order, etc.), replace mock PEPFAR data with SA national indicators, implement SharedPreferences-based user profile storage for role selection, redesign home screen with official branding and Material Design 3 components, and maintain offline-first architecture with bundled JSON data.

## Technical Context

**Language/Version**: Dart with Flutter SDK 3.5.3  
**Primary Dependencies**: flutter (Material Design 3), flutter_localizations, shared_preferences (for user role storage)  
**Storage**: JSON files in assets/ for indicator data + SharedPreferences for user profile  
**Testing**: flutter_test, widget tests, integration tests  
**Target Platform**: iOS 13.0+ and Android 8.0+ mobile devices  
**Project Type**: Mobile (cross-platform Flutter app)  
**Performance Goals**: 
- Cold start < 3 seconds
- Screen transitions < 300ms  
- Search results < 500ms
- 60fps animations

**Constraints**: 
- 100% offline functionality required
- Memory footprint < 150MB
- APK/IPA size < 50MB
- Support devices 3+ years old
- WCAG AA contrast ratios for dark mode

**Scale/Scope**: 
- ~250 total South African national indicators
- ~500 data elements
- 6 major indicator groups (Routine Facility Services, Routine ART Quarterly, TB Quarterly, EMS, Non-Facility Services, Periodic Campaigns, Selected Sites)
- Single mobile app (iOS + Android)
- 5-10 app screens (home, role selection, indicator groups, indicator detail, search, settings)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ Principle I: Offline-First Architecture

**Status**: PASS  
**Verification**: All functionality works without internet connectivity. User role stored locally via SharedPreferences. Indicator data bundled in assets/data/ as JSON files. No network calls or cloud synchronization.

### ✅ Principle II: User-Centered Design

**Status**: PASS  
**Verification**: 
- Role selection completes in < 60 seconds on first launch
- Home screen search bar enables < 30 second indicator lookup
- Clean card-based layouts with Grial-style spacing
- 2-second max load time for any screen
- Intuitive navigation with bottom nav and home screen cards

### ✅ Principle III: Data Integrity & Accuracy

**Status**: PASS with DEPENDENCY  
**Verification**: 
- Indicator schema supports all required SA fields (Reno/ID, Group ID, Sort Order, Name, Shortname, Numerator, Formula, Definition, Use/Context, Factor/Type, Frequency)
- Data import process will validate completeness before bundling
- Version display on home screen (v.YYYY.MM format)
- Source attribution in indicator details

**Dependency**: Complete and verified South African national indicator dataset must be provided before implementation.

### ✅ Principle IV: Modern UI Standards

**Status**: PASS  
**Verification**: 
- Material Design 3 enabled (useMaterial3: true)
- Dark mode with WCAG AA contrast ratios (already implemented with AppColors utility)
- Smooth 60fps transitions
- Platform-appropriate widgets (Material for Android, Cupertino for iOS where needed)
- Responsive layouts for phones and tablets

### ✅ Principle V: Performance & Responsiveness

**Status**: PASS  
**Verification**: 
- Search requirement: < 500ms (FR-029)
- Cold start: < 3 seconds (Constitution requirement)
- Returning user launch: < 2 seconds (SC-009)
- Screen transitions: < 300ms (Constitution requirement)
- Memory: < 150MB (Constitution requirement)
- Supports Android 8.0+ and iOS 13.0+ (3+ year old devices)

**Overall Assessment**: ✅ All constitutional principles satisfied. Feature aligns with offline-first, user-centered, accurate, modern, and performant requirements.

## Project Structure

### Documentation (this feature)

```
specs/001-adapt-app-for/
├── spec.md              # Feature specification (already created)
├── plan.md              # This file
├── research.md          # Phase 0 output (next step)
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   ├── IndicatorService.contract.md
│   ├── UserProfileService.contract.md
│   └── SAIndicator.model.contract.md
├── checklists/
│   └── requirements.md  # Quality validation checklist (already created)
└── tasks.md             # Phase 2 output (created via /speckit.tasks command)
```

### Source Code (repository root)

```
lib/
├── main.dart                          # App entry point
└── src/
    ├── app.dart                       # Root app widget with theme
    ├── models/
    │   ├── mer_models.dart            # EXISTING: Current PEPFAR models
    │   ├── sa_indicator.dart          # NEW: South African indicator model
    │   ├── indicator_group.dart       # NEW: Indicator group model
    │   └── user_profile.dart          # NEW: User role profile model
    ├── services/
    │   ├── mer_data_service.dart      # EXISTING: To be replaced/adapted
    │   ├── sa_indicator_service.dart  # NEW: SA indicator data service
    │   └── user_profile_service.dart  # NEW: User profile management
    ├── home/
    │   ├── home_screen.dart           # MODIFY: Redesign with NIDS branding
    │   └── widgets/                   # NEW: Home screen components
    │       ├── nids_header.dart       # Coat of arms + branding
    │       ├── home_search_bar.dart   # Search bar widget
    │       ├── navigation_card.dart   # Grid navigation cards
    │       └── summary_card.dart      # Indicator/element count cards
    ├── onboarding/                    # NEW: First-launch experience
    │   ├── role_selection_screen.dart # Role selection UI
    │   └── widgets/
    │       └── role_option_card.dart  # Individual role option
    ├── indicators/
    │   ├── indicator_list_screen.dart # MODIFY: Update for SA groups
    │   ├── indicator_detail_screen.dart # MODIFY: Update for SA schema
    │   └── widgets/                   # EXISTING: Reuse where possible
    ├── search/
    │   └── search_screen.dart         # MODIFY: Update for SA indicators
    ├── settings/
    │   └── settings_screen.dart       # MODIFY: Add role management option
    ├── utils/
    │   ├── app_colors.dart            # EXISTING: Theme-aware colors
    │   └── constants.dart             # NEW: App constants (roles, colors)
    └── localization/                  # EXISTING: Keep for future i18n

assets/
├── images/
│   ├── sa_coat_of_arms.png           # NEW: Official SA coat of arms
│   └── (2.0x, 3.0x variants)
└── data/
    ├── sa_indicators.json             # NEW: SA indicator data
    ├── indicator_groups.json          # NEW: Indicator group metadata
    └── recent_updates.json            # NEW: Recent updates content

test/
├── unit_test.dart                     # EXISTING: Add new unit tests
├── widget_test.dart                   # EXISTING: Add new widget tests
└── models/
    ├── sa_indicator_test.dart         # NEW: SA indicator model tests
    └── user_profile_test.dart         # NEW: User profile tests
```

**Structure Decision**: Using Option 3 (Mobile) structure extended from existing Flutter project. The app already has established directories (home/, indicators/, search/, settings/, models/, services/) which will be adapted for SA indicators. New directories added for onboarding (role selection) and home screen widgets. Assets expanded to include SA-specific data and branding images. Maintaining single project structure (not web/backend split) as this is a mobile-only offline app.

## Complexity Tracking

*No constitutional violations - this section not required.*

All implementation choices align with the five core principles. The feature adds new functionality (role selection, home screen redesign) while maintaining the existing architectural patterns (offline-first, bundled data, Material Design 3, performance standards).

## Phase 0: Research & Discovery

**Objective**: Understand existing PEPFAR app architecture, identify reusable components, research SA indicator data structure, and establish technical foundation for migration.

**Deliverable**: `research.md` document containing:

1. **Current Architecture Analysis**
   - Document existing MERIndicator model structure and fields
   - Map current ProgramArea grouping to SA indicator groups
   - Analyze MERDataService data loading and caching patterns
   - Review search implementation and filter logic
   - Document theme system (AppColors utility, dark mode support)

2. **Data Schema Mapping**
   - Compare PEPFAR MER schema vs SA indicator schema
   - Create field mapping table (e.g., MER "code" → SA "Indicator ID")
   - Identify new fields (Reno/ID, Sort Order, Factor/Type, Frequency)
   - Document any missing or deprecated fields
   - Define JSON schema for sa_indicators.json file

3. **User Role Management Research**
   - Evaluate SharedPreferences vs other local storage options
   - Research first-launch detection patterns in Flutter
   - Review best practices for onboarding flows (skip prevention)
   - Document role enum vs free-text storage approach

4. **Branding & Asset Requirements**
   - Research South African government branding guidelines (if publicly available)
   - Document required asset formats (coat of arms in PNG 1x/2x/3x)
   - Identify official government green color specifications
   - Review Material Design 3 color scheme generation
   - Document version numbering format (v.YYYY.MM)

5. **Performance Baseline**
   - Measure current app cold start time
   - Measure current search performance with PEPFAR data
   - Estimate memory usage with ~250 indicators vs current ~5 mock indicators
   - Identify potential performance bottlenecks for scaling

6. **Dependency Assessment**
   - Confirm if shared_preferences package is already included or needs adding
   - Check if any additional packages needed (e.g., intl for localization)
   - Review asset bundle size implications (250 indicators + branding)

**Research Questions**:
- How is current indicator data loaded at app startup? (Synchronous vs async)
- Does the existing search support multiple fields or just name/code?
- Are program areas hardcoded or data-driven?
- What navigation pattern is used between home → groups → indicators?
- How are indicator details formatted (cards, sections, collapsible)?

**Expected Duration**: 1-2 days

## Phase 1: Design & Data Modeling

**Objective**: Create concrete data models, service contracts, and UI specifications ready for implementation.

**Deliverables**:

### 1. `data-model.md`

Complete data model specifications:

**SAIndicator Model**:
```dart
class SAIndicator {
  final String renoId;           // Reno/ID field
  final String groupId;          // Links to IndicatorGroup
  final String indicatorId;      // Unique indicator identifier
  final int sortOrder;           // Display order within group
  final String name;             // Full indicator name
  final String shortname;        // Abbreviated name
  final String numerator;        // Numerator description
  final String? numeratorFormula; // Optional formula
  final String? denominator;     // Denominator description (nullable)
  final String? denominatorFormula; // Optional formula
  final String definition;       // Full definition text
  final String useContext;       // Use and Context guidance
  final String factorType;       // Factor/Type classification
  final String frequency;        // Reporting frequency (Monthly, Quarterly)
  final IndicatorStatus status;  // NEW, AMENDED, RETAINED_WITH_NEW, RETAINED_WITHOUT_NEW
  
  // Constructor, fromJson, toJson, equality, hashCode
}

enum IndicatorStatus {
  newIndicator,
  amended,
  retainedWithNew,
  retainedWithoutNew
}
```

**IndicatorGroup Model**:
```dart
class IndicatorGroup {
  final String id;               // Unique group identifier
  final String name;             // Display name
  final int displayOrder;        // Sort order for groups
  final List<String> subGroups;  // Sub-categories (e.g., "TB monthly", "Women's Health")
  final int indicatorCount;      // Total indicators in group
  
  // Constructor, fromJson, toJson
}
```

**UserProfile Model**:
```dart
class UserProfile {
  final UserRole role;           // Selected role enum
  final String? customRoleText;  // If role == other
  final DateTime selectionDate;  // When role was set
  
  // Constructor, fromJson, toJson
}

enum UserRole {
  nurse,
  doctor,
  dataClerk,
  programManager,
  pharmacist,
  communityHealthWorker,
  other
}
```

**JSON Schema Examples**:
- sa_indicators.json structure (array of indicator objects)
- indicator_groups.json structure
- recent_updates.json structure

**Data Relationships**:
- IndicatorGroup (1) → (many) SAIndicator via groupId
- UserProfile stored independently in SharedPreferences
- No relationships between UserProfile and indicators (future enhancement)

### 2. Service Contracts (`contracts/` directory)

**SAIndicatorService.contract.md**:
```dart
/// Service for managing South African national indicator data
class SAIndicatorService {
  /// Loads all indicators from assets/data/sa_indicators.json
  /// Throws: FormatException if JSON is malformed
  /// Performance: Must complete in < 2 seconds
  Future<void> loadIndicators();
  
  /// Returns all indicator groups sorted by displayOrder
  List<IndicatorGroup> getAllGroups();
  
  /// Returns indicators for a specific group, sorted by sortOrder
  List<SAIndicator> getIndicatorsByGroup(String groupId);
  
  /// Searches indicators by name, shortname, indicatorId, or definition
  /// Performance: Must return in < 500ms
  List<SAIndicator> searchIndicators(String query);
  
  /// Returns a single indicator by its indicatorId
  SAIndicator? getIndicatorById(String indicatorId);
  
  /// Returns total count of indicators and data elements
  Map<String, int> getStatistics(); // {indicators: 250, dataElements: 500}
}
```

**UserProfileService.contract.md**:
```dart
/// Service for managing user profile and role selection
class UserProfileService {
  /// Checks if user has completed first-launch role selection
  Future<bool> hasCompletedOnboarding();
  
  /// Saves user profile to SharedPreferences
  /// Returns: true if successful, false otherwise
  Future<bool> saveProfile(UserProfile profile);
  
  /// Retrieves saved user profile
  /// Returns: null if no profile exists
  Future<UserProfile?> getProfile();
  
  /// Updates existing profile (for settings screen)
  Future<bool> updateProfile(UserProfile profile);
  
  /// Clears profile (for testing/reset)
  Future<void> clearProfile();
}
```

### 3. `quickstart.md`

Developer guide for working with the new features:

**Setting Up Development Environment**:
1. Clone repository and checkout `001-adapt-app-for` branch
2. Run `flutter pub get` to install dependencies
3. Verify Flutter SDK 3.5.3+ installed
4. Place SA coat of arms asset in `assets/images/`
5. Add `sa_indicators.json` to `assets/data/`

**Running the App**:
```bash
# iOS Simulator
flutter run -d "iPhone 15"

# Android Emulator
flutter run -d emulator-5554

# With hot reload enabled (development)
flutter run --hot
```

**Testing Role Selection Flow**:
```bash
# Clear app data to trigger first-launch
flutter clean
flutter run

# Or use SharedPreferences debug tool to clear "hasCompletedOnboarding" key
```

**Adding/Updating Indicator Data**:
1. Edit `assets/data/sa_indicators.json`
2. Validate JSON schema
3. Hot restart app (not hot reload - assets require restart)
4. Verify indicators display correctly

**Running Tests**:
```bash
# All tests
flutter test

# Specific test file
flutter test test/models/sa_indicator_test.dart

# Widget tests only
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

**Performance Profiling**:
```bash
# Profile mode (optimized but debuggable)
flutter run --profile

# Monitor performance overlay
# Press 'P' in terminal to toggle overlay
```

**Expected Duration**: 2-3 days

## Phase 2: Implementation Tasks

**Objective**: Generate detailed, prioritized task list using `/speckit.tasks` command.

**Deliverable**: `tasks.md` (created by separate command, not this plan)

**Task Categories** (preview):

1. **Foundation Tasks** (P1)
   - Create SA indicator data models
   - Implement SAIndicatorService
   - Create JSON data files structure
   - Add shared_preferences dependency

2. **Data Migration Tasks** (P1)
   - Replace PEPFAR mock data with SA indicator data
   - Create indicator_groups.json
   - Import actual SA indicator dataset (BLOCKED on data availability)
   - Validate data integrity

3. **User Role Feature Tasks** (P2)
   - Implement UserProfile model
   - Implement UserProfileService
   - Create RoleSelectionScreen UI
   - Add first-launch detection logic
   - Add role management to settings screen

4. **Home Screen Redesign Tasks** (P1)
   - Create NIDSHeader widget with coat of arms
   - Implement home search bar widget
   - Create navigation card grid
   - Create summary cards (indicators/data elements count)
   - Update bottom navigation theme (green)
   - Add Recent Updates section

5. **Branding & Visual Tasks** (P1)
   - Obtain and add SA coat of arms assets
   - Define government green color constant
   - Update app theme with NIDS colors
   - Add version display (v.YYYY.MM format)
   - Update app name in configuration files

6. **Indicator Display Tasks** (P1)
   - Update indicator list screen for SA groups
   - Update indicator detail screen for SA schema
   - Add indicator status badges (NEW, AMENDED, RETAINED)
   - Update search screen for SA indicators

7. **Testing Tasks** (P1-P2)
   - Unit tests for SAIndicator model
   - Unit tests for UserProfile model
   - Unit tests for SAIndicatorService
   - Unit tests for UserProfileService
   - Widget tests for RoleSelectionScreen
   - Widget tests for NIDSHeader
   - Integration tests for full app flow
   - Performance tests (search < 500ms)

8. **Polish & Optimization Tasks** (P3)
   - Add loading indicators
   - Optimize JSON parsing performance
   - Add error handling for data loading failures
   - Implement indicator favorites feature (if time permits)
   - Add analytics for role usage (future enhancement)

**Task Prioritization Logic**:
- P1: Core functionality blocking release (data models, home screen, branding)
- P2: Important features not blocking core value (role selection, settings)
- P3: Nice-to-have enhancements (polish, future features)

**Next Command**: Run `/speckit.tasks` after Phase 1 completion to generate detailed task breakdown.

## Implementation Strategy

### Migration Approach

**Incremental Replacement** (recommended):
1. Keep existing PEPFAR code initially
2. Build SA indicator system in parallel (new models/services)
3. Update screens one at a time to use SAIndicatorService
4. Remove PEPFAR code after full migration verified
5. Allows for comparison testing and rollback if needed

**Benefits**:
- Lower risk (can revert if issues found)
- Easier testing (compare old vs new side-by-side)
- Clearer code review (new code in separate files)

**Drawbacks**:
- Temporary code duplication
- Larger intermediate commits

### Dependency Management

**Critical Path**:
1. ✅ Constitution established
2. ✅ Specification complete
3. ✅ Implementation plan created (this document)
4. ⏳ **BLOCKED**: SA indicator dataset required
5. ⏳ **BLOCKED**: SA coat of arms asset required
6. ⏳ Research phase (Phase 0)
7. ⏳ Design phase (Phase 1)
8. ⏳ Implementation (Phase 2)
9. ⏳ Testing & QA
10. ⏳ Release preparation

**Unblocking Dependencies**:
- **SA Indicator Data**: Contact South African Department of Health or data custodians. Need CSV/Excel/JSON with schema matching spec (Reno/ID, Group ID, Sort Order, Name, Shortname, Numerator, Numerator Formula, Denominator, Denominator Formula, Definition, Use and Context, Factor/Type, Frequency). Estimated 250 indicators across 6 groups.

- **SA Coat of Arms**: Download from official government website or request from Department of Health. Need high-resolution PNG (minimum 512x512) or SVG vector format. Must include 1x, 2x, 3x variants for Flutter asset system.

- **Government Green Color**: Confirm exact hex code from official branding guidelines. If unavailable, extract from provided screenshot and document as "approximation pending official confirmation."

### Testing Strategy

**Unit Tests** (models and services):
- Test SAIndicator fromJson/toJson
- Test UserProfile fromJson/toJson
- Test SAIndicatorService search logic
- Test UserProfileService SharedPreferences operations
- Test indicator filtering and sorting
- Target: 80%+ code coverage for business logic

**Widget Tests** (UI components):
- Test RoleSelectionScreen renders all role options
- Test role selection state changes
- Test NIDSHeader displays branding correctly
- Test search bar navigation
- Test navigation cards tap handling
- Test indicator list rendering
- Test indicator detail display

**Integration Tests** (end-to-end flows):
- Test first-launch onboarding flow (install → role selection → home screen)
- Test indicator browsing flow (home → group → indicator detail)
- Test search flow (search bar → results → detail)
- Test role change flow (settings → update role → persist)
- Test offline functionality (disable network, verify all features work)

**Performance Tests**:
- Measure cold start time (target: < 3 seconds)
- Measure search response time (target: < 500ms)
- Measure memory usage (target: < 150MB)
- Test with full dataset (250 indicators)

### Rollout Plan

**Phase 1: Internal Testing**
- Deploy to developer devices
- Verify all constitutional requirements met
- Test on older devices (Android 8.0, iOS 13.0)
- Validate dark mode contrast
- Performance profiling

**Phase 2: Beta Release**
- Deploy to small group of healthcare workers
- Gather feedback on role selection UX
- Verify indicator accuracy and completeness
- Monitor crash reports and performance

**Phase 3: Production Release**
- Publish to App Store and Google Play
- Monitor user adoption
- Track success criteria metrics (SC-001 to SC-013)
- Prepare for first update cycle (v.YYYY.MM+1)

## Risk Assessment

### High Risk

**Risk**: South African indicator dataset unavailable or incomplete  
**Impact**: Cannot proceed with implementation  
**Mitigation**: 
- Contact data custodians immediately
- Request specific schema documentation
- Offer to help format existing data
- Prepare mock data for development if delays expected

**Risk**: Official branding assets not accessible  
**Impact**: Cannot meet branding requirements (FR-014, FR-015)  
**Mitigation**:
- Use publicly available coat of arms from government websites
- Extract colors from provided screenshot as interim solution
- Document "pending official approval" for compliance

### Medium Risk

**Risk**: Performance degradation with 250 indicators vs 5 mock indicators  
**Impact**: May not meet < 500ms search requirement  
**Mitigation**:
- Implement efficient search indexing
- Use lazy loading for indicator lists
- Profile early and optimize data structures
- Consider caching search results

**Risk**: User confusion during role selection  
**Impact**: May not meet 90% success rate on first attempt (SC-007)  
**Mitigation**:
- Clear, concise role descriptions
- Add optional help text/tooltips
- Consider role icons for visual clarity
- User testing during beta phase

### Low Risk

**Risk**: Asset bundle size exceeds 50MB limit  
**Impact**: Violates constitutional performance requirement  
**Mitigation**:
- Compress coat of arms images
- Minify JSON data files
- Monitor bundle size during development
- Remove unused assets

**Risk**: SharedPreferences data corruption  
**Impact**: User role lost, re-prompts for selection  
**Mitigation**:
- Implement data validation on read
- Add fallback to re-prompt if corrupted
- Document as edge case in spec

## Success Metrics Tracking

**How to Validate Constitutional Compliance**:

| Principle | Metric | Target | Measurement Method |
|-----------|--------|--------|-------------------|
| Offline-First | Functionality without network | 100% | Disable network, test all features |
| User-Centered | Cold start time | < 3s | Performance profiling in release mode |
| User-Centered | Indicator lookup time | < 30s | Manual timing: launch → search → result |
| Data Integrity | Indicator accuracy | 100% match | Cross-reference with official SA docs |
| Modern UI | Dark mode contrast | WCAG AA | Contrast checker tool on all screens |
| Performance | Search response | < 500ms | Performance profiling with full dataset |
| Performance | Memory usage | < 150MB | Memory profiler with full dataset |

**How to Validate Success Criteria** (from spec.md):

| Criteria | Measurement Method | Pass Threshold |
|----------|-------------------|----------------|
| SC-001: Locate indicator in 30s | Manual user testing (5 users, 3 indicators each) | 90% complete within 30s |
| SC-002: 100% offline | Disable network, test all 250 indicators | All display correctly |
| SC-003: Role selection in 60s | Time first-launch flow | Average < 60s |
| SC-004: Search accuracy | Test 20 common queries | 19+ return relevant results |
| SC-005: Role change persists | Settings → change role → restart app | Role retained |
| SC-006: Correct indicator counts | Compare to official SA data | Exact match |
| SC-007: 90% role selection success | User testing (10 users) | 9+ complete without errors |
| SC-008: Formulas readable | Manual review on 3 devices | All formatted correctly |
| SC-009: Returning user launch < 2s | Performance profiling | < 2s cold start |
| SC-010: 100% brand recognition | User survey (10 users) | All recognize as official SA app |
| SC-011: Navigation within 3 taps | Manual testing of 6 features | All accessible in ≤ 3 taps |
| SC-012: 80% use home search | Analytics (beta testing) | Home search bar traffic > 80% |
| SC-013: Recent Updates functional | Manual testing | Content displays, "See all" works |

## Next Steps

**Immediate Actions**:

1. ✅ **Create this plan.md** (completed)

2. **⏳ Unblock Dependencies** (HIGH PRIORITY)
   - [ ] Request SA indicator dataset from Department of Health
   - [ ] Obtain SA coat of arms graphic (PNG 512x512+ or SVG)
   - [ ] Confirm government green color hex code
   - [ ] Request or create recent_updates.json content

3. **⏳ Phase 0: Research** (NEXT STEP)
   - [ ] Run through existing app to document current architecture
   - [ ] Analyze MERIndicator and MERDataService implementation
   - [ ] Create research.md document
   - [ ] Estimate performance impact of scaling to 250 indicators

4. **⏳ Phase 1: Design**
   - [ ] Create data-model.md with complete specifications
   - [ ] Write service contracts for SAIndicatorService and UserProfileService
   - [ ] Create quickstart.md developer guide
   - [ ] Validate Phase 1 outputs against constitution

5. **⏳ Phase 2: Implementation**
   - [ ] Run `/speckit.tasks` to generate tasks.md
   - [ ] Begin implementation following task priorities
   - [ ] Create feature branch commits
   - [ ] Write tests alongside implementation

**Command to Run Next**:
```
Begin Phase 0 research by documenting existing architecture and creating research.md
```

**Estimated Timeline**:
- Phase 0 (Research): 1-2 days
- Phase 1 (Design): 2-3 days
- Phase 2 (Implementation): 2-3 weeks (depends on data availability)
- Testing & QA: 1 week
- Beta release: 1 week
- **Total**: 4-6 weeks from data availability

**Blockers**:
- ⚠️ **CRITICAL**: South African indicator dataset not yet available
- ⚠️ **HIGH**: Official branding assets (coat of arms) not yet available
- ⚠️ **MEDIUM**: Government green color specification not confirmed

---

**Plan Status**: ✅ Complete and ready for Phase 0 research  
**Constitution Compliance**: ✅ All principles satisfied  
**Next Command**: Begin research phase documentation
