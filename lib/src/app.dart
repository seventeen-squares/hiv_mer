import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home/home_screen.dart';
import 'key_facts/key_facts_screen.dart';
import 'search/search_screen.dart';
import 'indicators/indicator_detail_screen.dart';
import 'indicators/indicators_screen.dart';
import 'indicators/indicator_groups_screen.dart';
import 'indicators/favorites_screen.dart';
import 'data_elements/data_elements_screen.dart';
import 'data_elements/data_element_detail_screen.dart';
import 'navigation/main_navigation.dart';
import 'onboarding/role_selection_screen.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'utils/constants.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.hasCompletedOnboarding,
  });

  final SettingsController settingsController;
  final bool hasCompletedOnboarding;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'SF Pro Display',
            primarySwatch: saGovernmentGreenSwatch,
            primaryColor: saGovernmentGreen,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            appBarTheme: AppBarTheme(
              backgroundColor: saGovernmentGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: saGovernmentGreen,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
            cardTheme: CardTheme(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.bold,
              ),
              displayMedium: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.bold,
              ),
              displaySmall: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
              headlineSmall: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
              titleLarge: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
              titleSmall: TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
              bodyLarge: TextStyle(color: Color(0xFF374151)),
              bodyMedium: TextStyle(color: Color(0xFF6B7280)),
              bodySmall: TextStyle(color: Color(0xFF9CA3AF)),
              labelLarge: TextStyle(
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
              labelMedium: TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
              labelSmall: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            useMaterial3: true,
            primaryColor: const Color.fromARGB(255, 38, 85, 143),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            cardColor: const Color(0xFF1E293B),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardTheme(
              elevation: 0,
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Colors.grey.shade800,
                  width: 1,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF60A5FA),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF60A5FA)),
              ),
              filled: true,
              fillColor: const Color(0xFF334155),
            ),
            textTheme: const TextTheme(
              displayLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              displayMedium:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              displaySmall:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              headlineLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              headlineMedium:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              headlineSmall:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              titleLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              titleMedium:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              titleSmall: TextStyle(
                  color: Color(0xFFE2E8F0), fontWeight: FontWeight.w500),
              bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
              bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
              bodySmall: TextStyle(color: Color(0xFF94A3B8)),
              labelLarge:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              labelMedium: TextStyle(
                  color: Color(0xFFE2E8F0), fontWeight: FontWeight.w500),
              labelSmall: TextStyle(
                  color: Color(0xFFCBD5E1), fontWeight: FontWeight.w500),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E293B),
              selectedItemColor: Color(0xFF60A5FA),
              unselectedItemColor: Color(0xFF94A3B8),
            ),
          ),
          // Force light theme mode for consistency
          themeMode: ThemeMode.light,

          // Set initial route based on onboarding status
          initialRoute: hasCompletedOnboarding
              ? MainNavigation.routeName
              : RoleSelectionScreen.routeName,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case RoleSelectionScreen.routeName:
                    return const RoleSelectionScreen();
                  case MainNavigation.routeName:
                    return MainNavigation(
                        settingsController: settingsController);
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case KeyFactsScreen.routeName:
                    return const KeyFactsScreen();
                  case SearchScreen.routeName:
                    return const SearchScreen();
                  case IndicatorsScreen.routeName:
                    return const IndicatorsScreen();
                  case IndicatorGroupsScreen.routeName:
                    return const IndicatorGroupsScreen();
                  case IndicatorDetailScreen.routeName:
                    return const IndicatorDetailScreen();
                  case FavoritesScreen.routeName:
                    return const FavoritesScreen();
                  case DataElementsScreen.routeName:
                    return const DataElementsScreen();
                  case DataElementDetailScreen.routeName:
                    return const DataElementDetailScreen();
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case HomeScreen.routeName:
                    return const HomeScreen();
                  case SampleItemListView.routeName:
                  default:
                    return hasCompletedOnboarding
                        ? MainNavigation(settingsController: settingsController)
                        : const RoleSelectionScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}
