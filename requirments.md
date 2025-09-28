Perfect 👍 — let’s frame this as a requirements document you can hand to your dev team (or use yourself if you’re coding it). Since you want a clone of the WHO TB Report style app but for PEPFAR MER guidelines, I’ll keep it structured and clear.

⸻

PEPFAR MER Quick Reference App – Requirements Document

1. Overview

The PEPFAR MER Quick Reference App is a cross-platform (Android/iOS) mobile application designed to provide offline access to PEPFAR MER guidelines. The app will serve as a simple reference tool with no logins, no data entry, just easy-to-navigate information on indicators, definitions, and disaggregations.

⸻

2. Objectives
	•	Provide a user-friendly reference app for PEPFAR MER guidelines.
	•	Ensure offline access (all content bundled in the app).
	•	Deliver quick search, compare, and navigation features.
	•	Keep the UI simple, modern, and consistent with the WHO Global TB Report style.

⸻

3. Functional Requirements

3.1 Home Screen
	•	Grid layout with tiles:
	1.	Key Facts – overview of MER guidelines and updates.
	2.	Targets & Progress – global PEPFAR/UNAIDS 95-95-95 targets.
	3.	Indicators by Program Area – HIV/TB, PMTCT, HTS, TX, OVC, KP/PP, etc.
	4.	Regions / Countries – optional, can show differences in reporting by geography (if relevant).
	5.	Compare – compare two or more indicators side by side.
	6.	Quick Search – keyword/code search (e.g., “TX_CURR”).

3.2 Indicator Pages

Each indicator page should display:
	•	Indicator Code (e.g., TX_CURR, HTS_TST)
	•	Full Name
	•	Definition
	•	Numerator / Denominator
	•	Disaggregations (Age/Sex, Key Populations, etc.)
	•	Reporting Frequency
	•	Notes / Clarifications
	•	Source references (e.g., MER v2.6 2024)

3.3 Search Functionality
	•	Global search bar accessible from home or nav bar.
	•	Searchable by: Indicator code, full name, keywords.
	•	Instant filter results (offline).

3.4 Compare Functionality
	•	Select two or more indicators.
	•	Display comparison table: definitions, numerators, denominators, disaggregations.

3.5 Favorites
	•	Users can bookmark indicators.
	•	Access saved indicators from bottom nav bar.

3.6 Offline Access
	•	Entire app works without internet.
	•	Content stored in a JSON or SQLite database bundled inside the app.

⸻

4. Non-Functional Requirements
	•	Cross-platform: Must run on both iOS and Android.
	•	Framework options: React Native, Flutter, or Ionic + Capacitor.
	•	Performance: Lightweight, smooth navigation (<2 sec screen load).
	•	UI/UX: Simple, flat, modern design (WHO TB Report style).
	•	Maintainability: Content updates done via JSON/SQLite file replacement.
	•	Security: No user logins, no sensitive data stored.

⸻

5. Data Structure (Example JSON)

{
  "indicators": [
    {
      "code": "TX_CURR",
      "name": "Current on ART",
      "definition": "Number of adults and children currently receiving ART...",
      "numerator": "Number of adults and children currently on treatment",
      "denominator": "Not applicable",
      "disaggregations": ["Age/Sex", "Key Populations"],
      "frequency": "Quarterly",
      "notes": "Includes all patients with documented evidence of ART...",
      "source": "PEPFAR MER 2.6 (2024)"
    },
    {
      "code": "HTS_TST",
      "name": "HIV Testing",
      "definition": "Number of individuals who received HIV testing services...",
      "numerator": "Individuals tested for HIV",
      "denominator": "Not applicable",
      "disaggregations": ["Age/Sex", "Entry Point"],
      "frequency": "Quarterly",
      "notes": "Exclude recency testing...",
      "source": "PEPFAR MER 2.6 (2024)"
    }
  ]
}


⸻

6. Technical Requirements
	•	Front-End:
	•	Grid dashboard, search, compare, indicator detail pages.
	•	Data Storage:
	•	JSON or SQLite for structured indicator data.
	•	Navigation:
	•	Bottom nav (Home, Favorites, Search, More).
	•	Hamburger menu for extras (About, Version info).
	•	Deployment:
	•	Publish to Google Play Store & Apple App Store.

⸻

7. Future Enhancements (Phase 2)
	•	Push updates for new MER guideline releases.
	•	Interactive glossary or acronyms list.
	•	Country-specific MER adaptations.
	•	Light/Dark mode toggle.
	•	Export/share indicator details as PDF or image.

⸻

✅ This requirement set is enough for a dev team to estimate, design, and start development.

Would you like me to also draft a work breakdown structure (WBS) with estimated effort (e.g., how many days for UI, database, search, etc.) so you can cost it like you did for your other projects?