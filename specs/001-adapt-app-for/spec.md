# Feature Specification: NIDS App - South African National Indicators

**Feature Branch**: `001-adapt-app-for`  
**Created**: 2025-10-07  
**Status**: Draft  
**Input**: User description: "Adapt app for South African national health indicators with user role selection and tracking"  
**App Name**: NIDS (National Indicator Data Set)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse South African National Health Indicators (Priority: P1)

Healthcare workers need to quickly reference South African national health indicators organized by indicator groups (TB monthly, Women's Health, ART, HIV/TB, EPI, etc.) to support accurate reporting and program monitoring.

**Why this priority**: This is the core value proposition of the app - providing offline access to national indicators. Without this, the app has no purpose.

**Independent Test**: Can be fully tested by launching the app and navigating through indicator groups to view indicator details. Delivers immediate value as a reference tool.

**Acceptance Scenarios**:

1. **Given** a healthcare worker opens the app, **When** they navigate to the home screen, **Then** they see indicator groups organized by categories (Routine Facility Health Services - Monthly, Routine ART Quarterly Indicators, TB Quarterly Indicators, etc.)
2. **Given** a user taps on "Routine Facility Health Services - Monthly", **When** the group opens, **Then** they see all indicators in that group (TB monthly, Women's Health, CCMDD, ART Monthly, HIV, HIV/TB, Eye Care, Child and Nutrition, EPI, etc.)
3. **Given** a user selects a specific indicator (e.g., "ART baseline cohort"), **When** the indicator detail screen loads, **Then** they see the complete indicator information: Indicator ID, Name, Shortname, Numerator, Numerator Formula, Denominator, Denominator Formula, Definition, Use and Context, Factor/Type, and Frequency
4. **Given** a user views an indicator, **When** they scroll through the details, **Then** all formula and calculation fields are clearly displayed and readable

---

### User Story 2 - Select and Store User Role on First Launch (Priority: P2)

Users need to identify their professional role (nurse, doctor, data clerk, program manager, etc.) on first launch to enable potential future personalization and analytics about which roles use the app most frequently.

**Why this priority**: While not critical for core functionality, capturing user role early enables future features and helps understand the app's user base. It's a one-time setup that doesn't impede immediate use.

**Independent Test**: Can be fully tested by performing a fresh install and verifying the role selection flow before accessing main features. Delivers value by personalizing the user experience.

**Acceptance Scenarios**:

1. **Given** a user installs and launches the app for the first time, **When** the app starts, **Then** they see a welcome screen with role selection options
2. **Given** a user is on the role selection screen, **When** they view the available roles, **Then** they see options including: Nurse, Doctor, Data Clerk, Program Manager, Pharmacist, Community Health Worker, Other
3. **Given** a user selects their role and confirms, **When** the selection is saved, **Then** the app proceeds to the main home screen and never shows the role selection again
4. **Given** a user selects "Other", **When** they confirm, **Then** they are optionally prompted to specify their role in a text field
5. **Given** a user has already set their role, **When** they launch the app subsequently, **Then** they go directly to the home screen without seeing role selection

---

### User Story 3 - Update User Role in Settings (Priority: P3)

Users need the ability to change their previously selected role if their job responsibilities change or if they initially selected the wrong option.

**Why this priority**: This is a nice-to-have feature for edge cases where users need to update their role. Most users will set it once and never change it.

**Independent Test**: Can be fully tested by navigating to settings, changing the role, and verifying the change persists. Delivers value for users whose roles evolve.

**Acceptance Scenarios**:

1. **Given** a user has previously selected a role, **When** they navigate to Settings, **Then** they see a "User Role" option showing their current role
2. **Given** a user taps "User Role" in settings, **When** the role selection screen appears, **Then** they see all available roles with their current role highlighted
3. **Given** a user changes their role and confirms, **When** they return to settings, **Then** the new role is displayed
4. **Given** a user changes their role, **When** they use the app, **Then** the new role is stored locally on the device and persists across app restarts

---

### User Story 4 - Search South African Indicators (Priority: P2)

Users need to quickly find specific indicators by name, shortname, indicator ID, or keyword without browsing through all groups.

**Why this priority**: With potentially hundreds of indicators across multiple groups (based on the summary showing 203 retained, 37 new, 21 amended indicators), search is essential for efficient use.

**Independent Test**: Can be fully tested by entering various search queries and verifying correct results appear. Delivers immediate value for time-sensitive lookups.

**Acceptance Scenarios**:

1. **Given** a user opens the search screen, **When** they type "ART", **Then** they see all indicators containing "ART" in the name, shortname, or indicator ID
2. **Given** a user searches for an indicator ID, **When** they enter the exact ID, **Then** the matching indicator appears at the top of results
3. **Given** a user searches for a term, **When** they tap a result, **Then** they navigate to the full indicator detail screen
4. **Given** no indicators match a search query, **When** the search completes, **Then** a friendly "No indicators found" message appears with search suggestions

---

### User Story 5 - NIDS Branded Home Screen with Quick Access Features (Priority: P1)

Users need a branded home screen that clearly identifies the app as the official National Indicator Data Set (NIDS) tool, displays the South African Department of Health identity, and provides quick access to key features through an intuitive card-based layout.

**Why this priority**: The home screen is the first touchpoint and must establish trust through official government branding while providing efficient navigation to all features. This is critical for adoption and credibility.

**Independent Test**: Can be fully tested by launching the app and verifying all branding elements, color scheme, and navigation cards are present and functional. Delivers immediate professional appearance.

**Acceptance Scenarios**:

1. **Given** a user launches the NIDS app, **When** the home screen loads, **Then** they see the South African coat of arms at the top center with "health" text and "Department: Health REPUBLIC OF SOUTH AFRICA" branding
2. **Given** a user views the home screen, **When** they look at the header area, **Then** they see "National Indicator Data Set (NIDS)" as the app title with version number (e.g., "v.2025.06")
3. **Given** a user is on the home screen, **When** they view the color scheme, **Then** the primary color is South African government green (header, navigation bar, accent elements)
4. **Given** a user views the home screen, **When** they look below the header, **Then** they see a prominent search bar with placeholder text "Search" and search icon
5. **Given** a user is on the home screen, **When** they scroll through the main content area, **Then** they see navigation cards in a 2-column grid including: Help/Support, Resource Center, Notifications, Favorites, Feedback, and About
6. **Given** a user views the home screen, **When** they look at the bottom section, **Then** they see two large summary cards: "Total Indicators" showing count (e.g., 250) and "Total Data Element" showing count (e.g., 500)
7. **Given** a user is on the home screen, **When** they look at the bottom navigation bar, **Then** they see 5 tabs with green background: Home, Indicator, Data Elements, Search, and More
8. **Given** a user views the home screen, **When** they see the "Recent Updates" section, **Then** it displays latest app updates, bug fixes, and feature enhancements with a "See all" link

---

### Edge Cases

- What happens when a user skips role selection on first launch? System should require selection before proceeding to ensure data is captured.
- How does the app handle indicators with empty or missing formula fields? Display "Not applicable" or similar placeholder text.
- What if an indicator group has no indicators? Hide empty groups or show "No indicators in this group" message.
- How does search handle partial matches vs exact matches? Prioritize exact matches, then partial matches in name/shortname/ID order.
- What happens if user data becomes corrupted? App should fall back to showing role selection again.
- How are indicator and data element totals kept current? Totals should be calculated dynamically from the bundled data.

## Requirements *(mandatory)*

### Functional Requirements

**Data Structure & Content**

- **FR-001**: System MUST replace PEPFAR MER indicators with South African national health indicator data
- **FR-002**: System MUST support indicator data structure containing: Reno/ID, Group ID, Indicator ID, Sort Order, Indicator Name, Shortname, Numerator, Numerator Formula, Denominator, Denominator Formula, Definition, Use and Context, Factor/Type, and Frequency
- **FR-003**: System MUST organize indicators into groups matching South African national structure (e.g., "Routine Facility Health Services - Monthly", "Routine ART Quarterly Indicators", "TB Quarterly Indicators", "Routine Non Facility Health Services - Monthly", "Periodic campaigns", "Selected sites")
- **FR-004**: System MUST display indicator counts per group (as shown in summary: TB monthly - 2 retained, Women's Health - 3 retained, etc.)
- **FR-005**: System MUST sort indicators within groups according to the "Sort Order" field

**User Role Management**

- **FR-006**: System MUST present role selection screen on first launch before main app features are accessible
- **FR-007**: System MUST offer predefined role options: Nurse, Doctor, Data Clerk, Program Manager, Pharmacist, Community Health Worker, Other
- **FR-008**: System MUST allow users to optionally specify custom role text when "Other" is selected
- **FR-009**: System MUST store selected user role locally on device only (no cloud sync or external transmission)
- **FR-010**: System MUST persist user role across app restarts and updates
- **FR-011**: System MUST provide settings option to view and change previously selected role
- **FR-012**: System MUST not require role selection on subsequent launches after initial setup

**Branding & Visual Identity**

- **FR-013**: App name MUST be "NIDS" (National Indicator Data Set) displayed prominently on home screen
- **FR-014**: Home screen header MUST display South African coat of arms (national logo) with "health" text and "Department: Health REPUBLIC OF SOUTH AFRICA" official branding
- **FR-015**: Primary color scheme MUST use South African government green as the dominant color for headers, navigation bars, and accent elements
- **FR-016**: Home screen MUST display app version number in format "v.YYYY.MM" below the app title
- **FR-017**: Bottom navigation bar MUST use green background with white icons and text

**User Interface**

- **FR-018**: Home screen MUST include a "Recent Updates" section displaying latest app updates, bug fixes, and feature enhancements with "See all" link
- **FR-019**: Home screen MUST display a prominent search bar below the header with placeholder text "Search" and search icon
- **FR-020**: Home screen MUST show navigation cards in 2-column grid layout including: Help/Support, Resource Center, Notifications, Favorites, Feedback, and About (each with appropriate icon)
- **FR-021**: Home screen MUST display two summary cards showing "Total Indicators" count and "Total Data Element" count with distinct background colors (warm brown/beige for indicators, orange for data elements)
- **FR-022**: Bottom navigation MUST include 5 tabs: Home, Indicator, Data Elements, Search, and More (with "More" showing three-dot icon)
- **FR-023**: Indicator group view MUST list all indicators within that group with name and shortname visible
- **FR-024**: Indicator detail screen MUST display all indicator fields in a readable, organized layout
- **FR-025**: System MUST highlight new, amended, and retained indicators with visual indicators (based on summary data showing "Retained with NEW", "Amended", "Retained without NEW")
- **FR-026**: Settings screen MUST include "User Role" as a configurable option

**Search & Navigation**

- **FR-027**: System MUST provide search functionality accessible from home screen search bar and dedicated Search tab in bottom navigation
- **FR-028**: Search MUST support queries against Indicator Name, Shortname, Indicator ID, and Definition text
- **FR-029**: Search results MUST display within 500ms for any query
- **FR-030**: System MUST maintain offline functionality for all indicator browsing and search features
- **FR-031**: Tapping search bar on home screen MUST navigate to full search interface or activate inline search

### Key Entities

- **Indicator**: Represents a single South African national health indicator with attributes: Reno/ID, Group ID, Indicator ID, Sort Order, Name, Shortname, Numerator (text), Numerator Formula, Denominator (text), Denominator Formula, Definition (long text), Use and Context (guidance text), Factor/Type (classification), Frequency (reporting period)

- **Indicator Group**: Represents a category of indicators with attributes: Group ID, Group Name (e.g., "Routine Facility Health Services - Monthly"), Display Order. Contains multiple indicators. Based on the summary, groups include:
  - Routine Facility Health Services - Monthly (contains: TB monthly, Women's Health, CCMDD, ART Monthly, HIV, HIV/TB, Eye Care, Child and Nutrition, EPI, Communicable Diseases, Mental Health, Oral Health, Rehabilitation, NCD, Management PHC, Quality, Inpatient Management, Maternal and Neonatal, STI, Viral Hepatitis)
  - Routine ART Quarterly Indicators (contains: ART baseline cohort, ART Outcome cohort)
  - TB Quarterly Indicators (contains: DR-TB quarterly cohort, DS-TB quarterly cohort)
  - EMS
  - Routine Non Facility Health Services - Monthly (contains: Environmental & Port Health, School Health, WBPHCOT)
  - Periodic campaigns (contains: EPI campaign, HPV Campaign)
  - Selected sites (contains: STI sentinel surveillance)

- **User Profile**: Stores user information including: Selected Role (enum or text), Role Selection Date, Custom Role Text (if "Other" selected). Stored locally only, never transmitted.

- **Indicator Summary Statistics**: Metadata about indicators including: Total count by status (Retained with NEW, Amended, Retained without NEW, NEW indicators), Total Data Elements count. Based on summary: 203 retained with NEW, 37 new, 21 amended indicators; 420 retained data elements, 68 new, 31 amended.

- **Home Screen Layout**: Structured layout containing: Official Branding Header (coat of arms, department name, app title NIDS, version), Recent Updates Section (with news/updates list and "See all" link), Search Bar (prominent placement), Navigation Cards Grid (2x3 layout: Help/Support, Resource Center, Notifications, Favorites, Feedback, About), Summary Cards (Total Indicators count, Total Data Element count), Bottom Navigation (Home, Indicator, Data Elements, Search, More tabs with green theme)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can locate and view any South African national indicator details within 30 seconds from app launch
- **SC-002**: 100% of indicators load and display correctly offline without internet connectivity
- **SC-003**: User role selection completes in under 60 seconds on first launch
- **SC-004**: Search returns relevant results for 95% of common indicator name queries within 500ms
- **SC-005**: Users can successfully change their role in settings and have it persist across app restarts
- **SC-006**: App displays all indicator groups with correct indicator counts matching the national summary (e.g., Routine Facility Health Services showing 203 retained indicators across sub-groups)
- **SC-007**: 90% of users complete role selection without confusion or errors on first attempt
- **SC-008**: All indicator formulas and definitions display correctly formatted and readable on mobile screens
- **SC-009**: App launches directly to home screen in under 2 seconds for returning users (bypassing role selection)
- **SC-010**: 100% of users immediately recognize the app as an official South African Department of Health tool based on branding elements (coat of arms, government green color, official department text)
- **SC-011**: Users can access any of the 6 main navigation features (Help/Support, Resource Center, Notifications, Favorites, Feedback, About) from home screen within 3 taps
- **SC-012**: Home screen search bar receives 80% of search traffic (users prefer home screen search over dedicated Search tab)
- **SC-013**: Recent Updates section displays current information and "See all" link is functional for viewing complete update history

## Assumptions

- South African national indicator data will be provided in a structured format (CSV, Excel, or JSON) that can be imported into the app's data layer
- Indicator data updates will follow the same process as PEPFAR MER (bundled with app updates, not runtime downloads)
- User role data is for future analytics/personalization only and doesn't affect current app functionality
- No personally identifiable information is collected beyond the professional role
- The indicator structure shown in the screenshot (indicator groups, retained/new/amended status) represents the complete South African system
- Indicator frequency field uses standard values (Monthly, Quarterly, etc.)
- The app will support the same platforms as the original PEPFAR app (iOS and Android)
- High-resolution South African coat of arms graphic asset will be provided for use in the app header
- The exact hex code for "South African government green" will be confirmed during design phase (using reference from provided screenshot)
- Version numbering will follow "v.YYYY.MM" format (e.g., v.2025.06) updated with each release
- "Recent Updates" content will be maintained as part of app release notes and bundled with updates
- Navigation card icons (Help/Support, Resource Center, etc.) will be designed to match the overall NIDS visual style

## Dependencies

- Availability of complete and accurate South African national health indicator dataset
- Confirmation of indicator data schema and any field variations from PEPFAR MER structure
- Design approval for indicator group organization and indicator detail layout
- Privacy assessment for user role data storage (confirming local-only storage is acceptable)
- South African Department of Health official branding guidelines and digital assets (coat of arms, color palette, typography)
- High-resolution coat of arms graphic file suitable for mobile display (vector format preferred)
- Official confirmation of government green color specification (hex/RGB values)
- Content for "Recent Updates" section for initial release
- Icon design or selection for navigation cards (Help/Support, Resource Center, Notifications, Favorites, Feedback, About)

## Out of Scope

- Integration with South African health information systems or reporting platforms
- Real-time indicator data updates or dynamic content loading
- User authentication or multi-user support
- Analytics dashboard showing indicator usage patterns by role (future enhancement)
- Indicator comparison features (beyond what exists in current PEPFAR app)
- Export or sharing of indicator definitions
- Customization of which indicator groups are visible per role (all users see all groups)
