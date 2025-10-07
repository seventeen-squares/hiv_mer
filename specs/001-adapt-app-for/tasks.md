# Tasks: NIDS App - South African National Indicators

**Input**: Design documents from `/specs/001-adapt-app-for/`  
**Prerequisites**: plan.md ✅, spec.md ✅

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

**Note**: Tests are not included as they were not explicitly requested in the feature specification. Focus is on implementation tasks only.

## Format: `[ID] [P?] [Story] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- Include exact file paths in descriptions

## Path Conventions
- Mobile Flutter project: `lib/src/` for source code
- Assets: `assets/data/` for JSON data, `assets/images/` for graphics
- Tests: `test/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [X] T001 Add `shared_preferences` dependency to `pubspec.yaml` for user role storage
- [X] T002 [P] Create `lib/src/utils/constants.dart` for app constants (roles enum, colors, version format)
- [X] T003 [P] Create assets directory structure: `assets/data/` and update `assets/images/` for SA branding
- [X] T004 [P] Add SA coat of arms image files to `assets/images/sa_coat_of_arms.png` (1x, 2x, 3x variants)
- [X] T005 Update `pubspec.yaml` to include new asset paths for data files and SA images

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data models and services that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T006 [P] Create `lib/src/models/sa_indicator.dart` with SAIndicator model (renoId, groupId, indicatorId, sortOrder, name, shortname, numerator, numeratorFormula, denominator, denominatorFormula, definition, useContext, factorType, frequency, status fields, fromJson/toJson methods)
- [X] T007 [P] Create `lib/src/models/indicator_group.dart` with IndicatorGroup model (id, name, displayOrder, subGroups, indicatorCount fields, fromJson/toJson methods)
- [X] T008 [P] Create `lib/src/models/user_profile.dart` with UserProfile model (role enum, customRoleText, selectionDate fields, fromJson/toJson methods) and UserRole enum (nurse, doctor, dataClerk, programManager, pharmacist, communityHealthWorker, other)
- [X] T009 Create `lib/src/services/sa_indicator_service.dart` with methods: loadIndicators(), getAllGroups(), getIndicatorsByGroup(groupId), searchIndicators(query), getIndicatorById(id), getStatistics() - implement JSON loading from assets/data/sa_indicators.json and assets/data/indicator_groups.json
- [X] T010 Create `lib/src/services/user_profile_service.dart` with methods: hasCompletedOnboarding(), saveProfile(profile), getProfile(), updateProfile(profile), clearProfile() - implement SharedPreferences storage
- [X] T011 Create sample `assets/data/sa_indicators.json` file with mock SA indicator data (5-10 sample indicators following SA schema for development)
- [X] T012 Create `assets/data/indicator_groups.json` file with SA indicator groups (Routine Facility Health Services, Routine ART Quarterly, TB Quarterly, EMS, Non-Facility Services, Periodic Campaigns, Selected Sites)
- [X] T013 Update `lib/src/utils/constants.dart` with SA government green color constant (hex value from branding), NIDS version format constant, role labels map

**Checkpoint**: Foundation ready - all models and services exist, user story implementation can now begin in parallel

---

## Phase 3: User Story 5 - NIDS Branded Home Screen (Priority: P1) 🎯 MVP Component

**Goal**: Create official NIDS branded home screen with SA coat of arms, government green theme, search bar, navigation cards, and summary statistics to establish credibility and provide intuitive navigation

**Independent Test**: Launch app and verify all branding elements (coat of arms, green color scheme, Department of Health text), navigation cards are tappable, summary cards show correct counts, search bar navigates to search screen, bottom navigation has 5 green tabs

### Implementation for User Story 5

- [X] T014 [P] [US5] Create `lib/src/home/widgets/nids_header.dart` widget displaying SA coat of arms, "health" text, "Department: Health REPUBLIC OF SOUTH AFRICA" branding, app title "National Indicator Data Set (NIDS)", and version number (v.YYYY.MM format)
- [X] T015 [P] [US5] Create `lib/src/home/widgets/home_search_bar.dart` widget with green theme, "Search" placeholder, search icon, navigates to search screen on tap
- [X] T016 [P] [US5] Create `lib/src/home/widgets/navigation_card.dart` reusable widget for grid navigation cards (icon, title, onTap callback, green accent colors)
- [X] T017 [P] [US5] Create `lib/src/home/widgets/summary_card.dart` reusable widget for indicator/data element count cards (title, count, background color - warm brown for indicators, orange for data elements)
- [X] T018 [P] [US5] Create `lib/src/home/widgets/recent_updates_section.dart` widget displaying latest updates list with "See all" link
- [X] T019 [US5] Update `lib/src/home/home_screen.dart` to use new NIDS widgets: add NIDSHeader at top, HomeSearchBar below header, navigation cards grid (2 columns: Help/Support, Resource Center, Notifications, Favorites, Feedback, About), summary cards for Total Indicators and Total Data Elements (fetch counts from SAIndicatorService.getStatistics()), Recent Updates section
- [X] T020 [US5] Update `lib/src/app.dart` theme configuration: set primary color to SA government green, update bottom navigation bar theme (green background, white icons/text), ensure Material Design 3 enabled, verify dark mode contrast with new green theme
- [X] T021 [US5] Update `lib/main.dart` to initialize SAIndicatorService on app startup and handle loading state before showing home screen
- [X] T022 [P] [US5] Create `assets/data/recent_updates.json` file with sample update entries (version, date, description, type: feature/bugfix/enhancement)

**Checkpoint**: Home screen displays with full NIDS branding, navigation cards functional, summary statistics showing, app establishes official government identity

---

## Phase 4: User Story 1 - Browse SA Indicators (Priority: P1) 🎯 MVP Component

**Goal**: Enable healthcare workers to browse South African national health indicators organized by groups and view complete indicator details offline

**Independent Test**: From home screen, tap "Indicator" tab in bottom navigation, select an indicator group, browse indicators in that group sorted by sortOrder, tap an indicator to view full details (all fields: Reno/ID, Group ID, Indicator ID, Sort Order, Name, Shortname, Numerator, Numerator Formula, Denominator, Denominator Formula, Definition, Use and Context, Factor/Type, Frequency)

### Implementation for User Story 1

- [X] T023 [US1] Update `lib/src/indicators/indicator_list_screen.dart` to display SA indicator groups from SAIndicatorService.getAllGroups() sorted by displayOrder, show indicator count per group, handle tap to navigate to group detail showing indicators from getIndicatorsByGroup()
- [X] T024 [US1] Update `lib/src/indicators/indicator_detail_screen.dart` to display SAIndicator model fields: show Reno/ID, Group ID, Indicator ID, Sort Order, Name, Shortname, Numerator with optional Numerator Formula, Denominator with optional Denominator Formula (display "Not applicable" if null), Definition, Use and Context, Factor/Type, Frequency - use card-based layout with proper sections and theme-aware colors from AppColors utility
- [X] T025 [P] [US1] Add indicator status badge widget to indicator list items showing visual indicator for NEW, AMENDED, RETAINED_WITH_NEW, RETAINED_WITHOUT_NEW status (based on SAIndicator.status field)
- [X] T026 [US1] Update bottom navigation in `lib/src/app.dart` to include "Indicator" tab that navigates to indicator_list_screen, ensure green theme applied
- [X] T027 [US1] Handle empty indicator groups: if getIndicatorsByGroup() returns empty list, display "No indicators in this group" message with helpful icon
- [X] T028 [US1] Add loading indicator during indicator data load in indicator_list_screen and indicator_detail_screen

**Checkpoint**: Users can browse all indicator groups, view indicators sorted correctly, see complete indicator details with all SA schema fields, status badges display correctly

---

## Phase 5: User Story 2 - Role Selection on First Launch (Priority: P2)

**Goal**: Capture user's professional role (nurse, doctor, data clerk, etc.) on first launch to enable future personalization and understand user base

**Independent Test**: Uninstall and reinstall app (or clear app data), launch app, verify role selection screen appears before home screen, select a role, confirm selection saves, verify subsequent launches skip role selection and go directly to home screen

### Implementation for User Story 2

- [X] T029 [P] [US2] Create `lib/src/onboarding/widgets/role_option_card.dart` widget for individual role selection button (displays role name with icon, selected state styling with green highlight, onTap callback)
- [X] T030 [US2] Create `lib/src/onboarding/role_selection_screen.dart` with welcome message, list of role options (Nurse, Doctor, Data Clerk, Program Manager, Pharmacist, Community Health Worker, Other) using RoleOptionCard widgets, "Other" selection shows optional text field for custom role, confirm button that calls UserProfileService.saveProfile() and navigates to home screen
- [X] T031 [US2] Update `lib/main.dart` to check UserProfileService.hasCompletedOnboarding() on app startup - if false, navigate to role_selection_screen; if true, navigate directly to home screen
- [X] T032 [US2] Add validation to role selection screen: confirm button disabled until a role is selected, if "Other" selected without custom text, show validation message or allow empty
- [X] T033 [US2] Add error handling for UserProfileService.saveProfile() failure: show error dialog and allow user to retry role selection

**Checkpoint**: First-time users see role selection before accessing app, role is saved locally, returning users skip role selection, all role options functional including "Other" with custom text

---

## Phase 6: User Story 4 - Search Indicators (Priority: P2)

**Goal**: Enable users to quickly find specific indicators by searching name, shortname, indicator ID, or definition keywords without browsing through groups

**Independent Test**: Tap search bar on home screen or "Search" tab in bottom navigation, enter search query (e.g., "ART"), verify results appear in < 500ms showing relevant indicators, tap result to navigate to indicator detail screen, verify exact ID matches appear at top, verify "No indicators found" message for non-matching queries

### Implementation for User Story 4

- [X] T034 [US4] Update `lib/src/search/search_screen.dart` to use SAIndicatorService.searchIndicators(query) method, display results in list with indicator name and shortname visible, implement search debouncing (300ms delay after typing stops), prioritize exact matches in indicator ID at top of results, then partial matches in name/shortname/definition order
- [X] T035 [US4] Add search result item widget to search screen showing indicator name, shortname, indicator ID, and group name for context, use existing theme-aware colors from AppColors utility
- [X] T036 [US4] Implement "No indicators found" empty state in search screen with friendly message and search suggestions (e.g., "Try searching by indicator name, ID, or keywords")
- [X] T037 [US4] Connect home screen search bar (HomeSearchBar widget from US5) to navigate to search_screen with focus on search input
- [X] T038 [US4] Add loading indicator during search in search_screen to show search is in progress
- [X] T039 [US4] Optimize SAIndicatorService.searchIndicators() method to meet < 500ms performance requirement: implement efficient string matching, consider caching search results for repeated queries

**Checkpoint**: Search functional from home screen and Search tab, results appear quickly (< 500ms), prioritization correct (exact ID matches first), tapping results navigates to details, empty state handles no matches gracefully

---

## Phase 7: User Story 3 - Update Role in Settings (Priority: P3)

**Goal**: Allow users to change their previously selected role if job responsibilities change or if they selected wrong option initially

**Independent Test**: Navigate to Settings screen, tap "User Role" option showing current role, role selection screen appears with current role highlighted, select new role and confirm, return to Settings and verify new role displayed, restart app and verify role persists

### Implementation for User Story 3

- [X] T040 [US3] Update `lib/src/settings/settings_screen.dart` to add "User Role" list item showing current role from UserProfileService.getProfile(), handle null case (shouldn't happen if onboarding complete), tap navigates to role selection screen
- [X] T041 [US3] Update `lib/src/onboarding/role_selection_screen.dart` to accept optional currentRole parameter, if provided, highlight/pre-select current role in the list, update screen title from "Welcome" to "Update Role" when editing
- [X] T042 [US3] Update role selection screen to call UserProfileService.updateProfile() when editing existing role (instead of saveProfile() for first-time), show success message and navigate back to Settings after update
- [X] T043 [US3] Add navigation from settings role list item to role_selection_screen passing current role, handle back navigation to return to Settings
- [X] T044 [US3] Add confirmation dialog when role is updated successfully: "Role updated to [new role]" with OK button

**Checkpoint**: Settings displays current role, tapping opens role selection with current role highlighted, changing role saves and persists, Settings reflects new role after update

---

## Phase 8: Data Integration & Content

**Purpose**: Replace mock/sample data with actual South African indicator dataset

- [X] T045 [Data] Obtain complete South African national health indicator dataset (237 indicators) in CSV format from Department of Health NIDS 2025 master spreadsheet
- [X] T046 [Data] Validate SA indicator dataset completeness: verify all indicators have required fields (Reno/ID, Group ID, Indicator ID, Sort Order, Name, Shortname, Numerator, Definition, Use and Context, Factor/Type, Frequency), check for missing data
- [X] T047 [Data] Transform SA indicator dataset to match JSON schema defined in sa_indicator.dart model: convert to JSON array, map all fields correctly, assign status values (RETAINED_WITHOUT_NEW), handle duplicate/invalid UIDs
- [X] T048 [Data] Replace sample `assets/data/sa_indicators.json` with complete dataset (237 indicators across 26 groups)
- [X] T049 [Data] Verify indicator_groups.json counts match actual indicator dataset: update indicatorCount field for each group based on actual data
- [X] T050 [Data] Validate data integrity: verify all required fields present, check for duplicate IDs, validate group counts, confirm frequency and factor distributions
- [X] T051 [Data] Test app performance with full dataset (237 indicators): JSON files optimized (211KB indicators, 3.4KB groups), well within memory and size targets
- [X] T052 [Data] Update recent_updates.json with actual release notes for first NIDS version (v.2025.10 with 237 indicators across 26 groups)

**Checkpoint**: App running with complete, verified SA indicator dataset; performance meets constitutional requirements with full data

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and final QA

- [ ] T053 [P] [Polish] Add error handling throughout app for JSON parsing failures in SAIndicatorService: show user-friendly error dialog if data files are corrupted or missing
- [ ] T054 [P] [Polish] Add loading states and progress indicators for all async operations: indicator loading, profile saving/loading, search operations
- [ ] T055 [P] [Polish] Verify dark mode WCAG AA contrast ratios across all new screens: home screen with green theme, role selection, indicator list/detail, search results
- [ ] T056 [P] [Polish] Add accessibility labels to all interactive widgets: navigation cards, role selection cards, search bar, summary cards, indicator list items
- [ ] T057 [P] [Polish] Optimize asset bundle size: compress SA coat of arms images, minify JSON data files if needed, verify total APK/IPA size < 50MB
- [ ] T058 [P] [Polish] Add smooth transitions between screens: fade/slide animations for navigation, maintain 60fps target
- [ ] T059 [P] [Polish] Implement "Data Elements" tab in bottom navigation (placeholder screen for future enhancement showing data elements count from summary)
- [ ] T060 [P] [Polish] Implement "More" tab in bottom navigation with additional options: About, Feedback, Help/Support sections
- [ ] T061 [Polish] Test on physical devices (Android 8.0 minimum, iOS 13.0 minimum): verify performance on 3+ year old devices, test offline functionality
- [ ] T062 [Polish] Update app metadata: change app name to "NIDS" in `pubspec.yaml`, update Android and iOS app display names, update app description
- [ ] T063 [Polish] Add app version display validation: verify home screen shows correct version in v.YYYY.MM format matching release date
- [ ] T064 [Polish] Run full regression testing: verify all user stories still work after polish changes, test edge cases from spec.md
- [ ] T065 [Polish] Code cleanup: remove old PEPFAR-specific code (mer_models.dart, mer_data_service.dart once fully migrated), remove unused imports
- [ ] T066 [Polish] Documentation: update README.md with NIDS app description, add developer quickstart guide

**Checkpoint**: App polished, accessible, performant, all edge cases handled, ready for beta testing

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 5 (Phase 3 - P1)**: Depends on Foundational - Home screen branding
- **User Story 1 (Phase 4 - P1)**: Depends on Foundational - Indicator browsing
- **User Story 2 (Phase 5 - P2)**: Depends on Foundational - Role selection
- **User Story 4 (Phase 6 - P2)**: Depends on Foundational - Search
- **User Story 3 (Phase 7 - P3)**: Depends on US2 (role selection must exist before updating) and Foundational
- **Data Integration (Phase 8)**: Can proceed in parallel with user stories using mock data initially, BLOCKED by external data availability
- **Polish (Phase 9)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 5 (P1)**: Independent - no dependencies on other stories (just needs Foundation)
- **User Story 1 (P1)**: Independent - no dependencies on other stories (just needs Foundation)
- **User Story 2 (P2)**: Independent - no dependencies on other stories (just needs Foundation)
- **User Story 4 (P2)**: Independent - no dependencies on other stories (just needs Foundation, may integrate with US5 home search bar)
- **User Story 3 (P3)**: Depends on User Story 2 (must have role selection before updating role)

### Within Each User Story

**Phase 2 (Foundational)**:
- T006, T007, T008 (models) can run in parallel [P]
- T009 (SAIndicatorService) depends on T006, T007 complete
- T010 (UserProfileService) depends on T008 complete
- T011, T012 (data files) can run in parallel [P] after T009
- T013 (constants) can run in parallel with other tasks [P]

**Phase 3 (US5 - Home Screen)**:
- T014, T015, T016, T017, T018 (widgets) can all run in parallel [P]
- T019 (home_screen.dart update) depends on T014-T018 complete
- T020 (theme update) can run in parallel with widgets [P]
- T021 (main.dart update) should wait until T019 complete
- T022 (recent_updates.json) can run in parallel [P]

**Phase 4 (US1 - Browse Indicators)**:
- T023, T024 (screen updates) can run in parallel if different developers
- T025 (status badge) can run in parallel [P]
- T026, T027, T028 are sequential additions to same files

**Phase 5 (US2 - Role Selection)**:
- T029 (widget) can run in parallel [P]
- T030 (screen) depends on T029
- T031-T033 are sequential updates to existing files

**Phase 6 (US4 - Search)**:
- T034-T039 are mostly sequential updates to same files
- T038 (loading indicator) can run in parallel with T039 (optimization) if different files [P]

**Phase 7 (US3 - Update Role)**:
- T040-T044 are sequential updates to existing files

**Phase 8 (Data Integration)**:
- T045-T052 are sequential (must obtain data first, then transform, then validate)

**Phase 9 (Polish)**:
- All polish tasks marked [P] can run in parallel
- T064 (regression testing) should be last
- T065, T066 (cleanup, docs) after testing

### Parallel Opportunities

**Within Foundational Phase**:
```bash
# All models can be created simultaneously:
T006: Create sa_indicator.dart model
T007: Create indicator_group.dart model
T008: Create user_profile.dart model
T013: Update constants.dart
```

**Within Home Screen Phase**:
```bash
# All home screen widgets can be created simultaneously:
T014: Create nids_header.dart
T015: Create home_search_bar.dart
T016: Create navigation_card.dart
T017: Create summary_card.dart
T018: Create recent_updates_section.dart
T020: Update app theme
T022: Create recent_updates.json
```

**Within Polish Phase**:
```bash
# All polish tasks except T064-T066 can run simultaneously:
T053: Add error handling
T054: Add loading states
T055: Verify dark mode contrast
T056: Add accessibility labels
T057: Optimize bundle size
T058: Add transitions
T059: Implement Data Elements tab
T060: Implement More tab
T061: Test on devices
```

---

## Implementation Strategy

### MVP First (User Stories 5 + 1 Only)

**Minimal Viable Product - Core Value Delivery**:

1. Complete Phase 1: Setup (T001-T005)
2. Complete Phase 2: Foundational (T006-T013) - CRITICAL - blocks all stories
3. Complete Phase 3: User Story 5 - Home Screen (T014-T022)
4. Complete Phase 4: User Story 1 - Browse Indicators (T023-T028)
5. **STOP and VALIDATE**: 
   - Launch app → See NIDS branded home screen with SA coat of arms
   - Tap "Indicator" tab → Browse indicator groups → View indicator details
   - Test offline (disable network) → Verify all features work
   - Measure performance: cold start < 3s, screen transitions < 300ms
6. **Deploy/Demo**: App delivers core value (official branding + indicator reference)

**MVP delivers**: Professional NIDS branded interface + complete offline indicator browsing capability

### Incremental Delivery (Add Features Progressively)

**After MVP (US5 + US1)**:

1. Add Phase 5: User Story 2 - Role Selection (T029-T033)
   - Test independently: Fresh install → Role selection → Save → Restart → Direct to home
   - Deploy/Demo: Now captures user role for future analytics

2. Add Phase 6: User Story 4 - Search (T034-T039)
   - Test independently: Search bar → Query → Results < 500ms → Tap → Detail
   - Deploy/Demo: Now supports fast indicator lookup without browsing

3. Add Phase 7: User Story 3 - Update Role (T040-T044)
   - Test independently: Settings → Change role → Persist
   - Deploy/Demo: Now supports role management

4. Complete Phase 8: Data Integration (T045-T052) - **When data available**
   - Replace mock data with complete 250 indicator dataset
   - Validate performance at scale
   - Deploy/Demo: Production-ready with full dataset

5. Complete Phase 9: Polish (T053-T066)
   - Final QA, accessibility, performance tuning
   - Deploy/Demo: Production release

**Each increment adds value without breaking previous functionality**

### Parallel Team Strategy

**With 3 developers after Foundation complete**:

1. All complete Setup + Foundational together (T001-T013)
2. Once Foundational done, split work:
   - **Developer A**: User Story 5 (Home Screen) - T014-T022
   - **Developer B**: User Story 1 (Browse Indicators) - T023-T028  
   - **Developer C**: User Story 2 (Role Selection) - T029-T033
3. All three stories complete in parallel, integrate and test
4. Continue with remaining stories and polish

**With 2 developers**:
1. Both complete Setup + Foundational (T001-T013)
2. Split MVP:
   - Developer A: US5 (Home Screen)
   - Developer B: US1 (Browse Indicators)
3. Reconvene for integration testing
4. Continue with US2, US4, US3 in priority order

---

## Task Summary

**Total Tasks**: 66 tasks

**Tasks by User Story**:
- Setup (Phase 1): 5 tasks (T001-T005)
- Foundational (Phase 2): 8 tasks (T006-T013) - BLOCKS all stories
- User Story 5 - Home Screen (P1): 9 tasks (T014-T022)
- User Story 1 - Browse Indicators (P1): 6 tasks (T023-T028)
- User Story 2 - Role Selection (P2): 5 tasks (T029-T033)
- User Story 4 - Search (P2): 6 tasks (T034-T039)
- User Story 3 - Update Role (P3): 5 tasks (T040-T044)
- Data Integration: 8 tasks (T045-T052) - BLOCKED by external data
- Polish & Cross-Cutting: 14 tasks (T053-T066)

**MVP Scope** (Recommended first release):
- Phases 1-4: 28 tasks (T001-T028)
- Delivers: NIDS branded home screen + full indicator browsing capability
- Estimated effort: 2-3 weeks with full dataset, 1-2 weeks with mock data

**Parallel Opportunities Identified**: 18 tasks marked [P] can run in parallel within their phases

**Critical Path**: 
1. Setup → 2. Foundational (BLOCKER) → 3. User Stories (parallel possible) → 4. Polish

**External Blockers**:
- Phase 8 (T045-T052): Waiting for complete SA indicator dataset from Department of Health
- T004: Waiting for official SA coat of arms graphic asset
- T013, T020: Waiting for confirmed SA government green hex color code

---

## Notes

- [P] tasks = different files, no dependencies within phase
- [Story] label maps task to specific user story for traceability (US1-US5)
- Each user story is independently testable and deliverable
- Foundation phase (Phase 2) MUST complete before any user story work begins
- User Stories 5 and 1 form the MVP (core value: branding + indicator browsing)
- User Stories 2, 4, 3 can be added incrementally after MVP
- Data Integration (Phase 8) is BLOCKED but can use mock data during development
- Stop at any checkpoint to validate story independently
- Commit after each task or logical group for easy rollback
- Performance validation required after Data Integration with full 250 indicator dataset
