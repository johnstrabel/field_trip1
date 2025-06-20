// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import '../models/trip.dart' as model;

class AppColors {
  // Brand Colors
  static const Color amethyst600 = Color(0xFF7C3AED);
  static const Color amethyst100 = Color(0xFFF5F3FF);  // Added missing shade

  static const Color surface = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecond = Color(0xFF64748B);
  static const Color stroke = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // NEW: Core Type Badge Colors (replacing old system)
  static const Color exploreBlue = Color(0xFF1EA7FF);
  static const Color crawlBronze = Color(0xFFC38121);
  static const Color activeAmber = Color(0xFFF4B400);
  static const Color gameCrimson = Color(0xFFD7263D);

  // OLD: Keep for backward compatibility during migration
  static const Color standardBlue = Color(0xFF1EA7FF);
  static const Color barcrawlBronze = Color(0xFFC38121);
  static const Color fitnessAmber = Color(0xFFF4B400);
  static const Color challengeCrimson = Color(0xFFD7263D);

  // ADDED: Missing colors for profile and other screens
  static const Color onlineGreen = Color(0xFF10B981);
  static const Color onlineBackground = Color(0xFFECFDF5);
  static const Color info = Color(0xFF3B82F6);
}

class AppDimensions {
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  static const double radiusS = 6.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // ADDED: Missing dimension for profile avatar
  static const double avatarSize = 64.0;

  // ADDED: Icon sizes
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
}

class AppTextStyles {
  static const TextStyle heroTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heroSubtitle = TextStyle(  // Added missing
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecond,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecond,
  );

  // ADDED: for stats and filter chips
  static const TextStyle statValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecond,
  );

  static const TextStyle textMain = body;   // general text
  static const TextStyle chipText = caption; // for filter chips
}

class AppTheme {
  // MAIN THEME GETTER - This is what main.dart expects
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: _createMaterialColor(AppColors.amethyst600),
      primaryColor: AppColors.amethyst600,
      scaffoldBackgroundColor: AppColors.surface,
      cardColor: AppColors.card,
      
      // Updated text theme
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heroTitle,
        headlineMedium: AppTextStyles.sectionTitle,
        titleLarge: AppTextStyles.cardTitle,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.cardSubtitle,
        bodySmall: AppTextStyles.caption,
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.sectionTitle,
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amethyst600,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: const Size(0, AppDimensions.buttonHeightM),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.amethyst600,
          side: const BorderSide(color: AppColors.amethyst600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: const Size(0, AppDimensions.buttonHeightM),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.amethyst600,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.amethyst600,
        unselectedItemColor: AppColors.textSecond,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.stroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color:	AppColors.stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.amethyst600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM, vertical: AppDimensions.spaceM),
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.amethyst600,
        disabledColor: AppColors.stroke,
        labelStyle: AppTextStyles.chipText,
        secondaryLabelStyle: AppTextStyles.chipText.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM, vertical: AppDimensions.spaceS),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(color: AppColors.stroke, thickness: 1, space: 1),
      
      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static MaterialColor _createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) strengths.add(0.1 * i);
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

// UPDATED: TripTypeHelper class with support for both old and new systems
class TripTypeHelper {
  final String displayName;
  final Color color;
  final IconData icon;

  const TripTypeHelper({required this.displayName, required this.color, required this.icon});

  static TripTypeHelper fromCoreType(model.CoreType coreType) {
    switch (coreType) {
      case model.CoreType.explore:
        return const TripTypeHelper(displayName: 'Explore', color:	AppColors.exploreBlue, icon: Icons.explore);
      case model.CoreType.crawl:
        return const TripTypeHelper(displayName: 'Crawl', color: AppColors.crawlBronze, icon: Icons.local_bar);
      case model.CoreType.active:
        return const TripTypeHelper(displayName: 'Active', color: AppColors.activeAmber, icon: Icons.fitness_center);
      case model.CoreType.game:
        return const TripTypeHelper(displayName: 'Game', color: AppColors.gameCrimson, icon: Icons.games);
    }
  }

  static TripTypeHelper fromTripType(model.TripType tripType) {
    switch (tripType) {
      case model.TripType.standard:
        return fromCoreType(model.CoreType.explore);
      case model.TripType.barcrawl:
        return fromCoreType(model.CoreType.crawl);
      case model.TripType.fitness:
        return fromCoreType(model.CoreType.active);
      case model.TripType.challenge:
        return fromCoreType(model.CoreType.game);
    }
  }

  static TripTypeHelper fromTrip(model.Trip trip) {
    return fromCoreType(trip.currentType);
  }

  static TripTypeHelper fromBadge(model.Badge badge) {
    return fromCoreType(badge.currentType);
  }

  static TripTypeHelper fromType(dynamic type) {
    final String typeString;
    if (type is model.TripType) typeString = type.toString().split('.').last;
    else if (type is model.CoreType) typeString = type.toString().split('.').last;
    else typeString = type.toString();

    switch (typeString.toLowerCase()) {
      case 'standard':
      case 'explore': return fromCoreType(model.CoreType.explore);
      case 'barcrawl':
      case 'crawl':   return fromCoreType(model.CoreType.crawl);
      case 'fitness':
      case 'active':  return fromCoreType(model.CoreType.active);
      case 'challenge':
      case 'game':    return fromCoreType(model.CoreType.game);
      default:        return fromCoreType(model.CoreType.explore);
    }
  }

  static Color getColor(String tripType) => fromType(tripType).color;
  static IconData getIcon(String tripType) => fromType(tripType).icon;

  static List<model.CoreType> getAllCoreTypes() => model.CoreType.values;
  static List<String> getCoreTypeDisplayNames() => ['All', 'Explore', 'Crawl', 'Active', 'Game'];
  static Color getCoreTypeColorWithOpacity(model.CoreType coreType, double o) => fromCoreType(coreType).color.withOpacity(o);
}
