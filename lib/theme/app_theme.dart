// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import '../models/trip.dart' as model;

class AppColors {
  // Brand Colors
  static const Color amethyst600 = Color(0xFF7C3AED);
  static const Color amethyst100 = Color(0xFFF5F3FF);

  static const Color surface = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecond = Color(0xFF64748B);
  static const Color stroke = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // NEW: 3-Type System Colors (your existing ones)
  static const Color exploreBlue = Color(0xFF1EA7FF);    // Explore - Traditional sightseeing
  static const Color crawlCrimson = Color(0xFFD7263D);   // Crawl - Nightlife adventures
  static const Color sportAmber = Color(0xFFF4B400);     // Sport - Fitness, games, competitions

  // ADDED: Missing color aliases that the error messages referenced
  static const Color exploreTeal = exploreBlue;          // Alias for consistency
  static const Color sportGold = sportAmber;             // Alias for consistency

  // OLD: Keep for backward compatibility during migration
  static const Color standardBlue = Color(0xFF1EA7FF);
  static const Color barcrawlBronze = Color(0xFFD7263D);  // Updated to match crawlCrimson
  static const Color fitnessAmber = Color(0xFFF4B400);
  static const Color challengeCrimson = Color(0xFFD7263D);
  static const Color activeAmber = Color(0xFFF4B400);    // Maps to sport
  static const Color gameCrimson = Color(0xFFD7263D);    // Maps to sport

  // Profile and UI colors
  static const Color onlineGreen = Color(0xFF10B981);
  static const Color onlineBackground = Color(0xFFECFDF5);
  static const Color info = Color(0xFF3B82F6);

  // ADDED: Standard Material Design colors for compatibility
  static const Color primary = amethyst600;
  static const Color secondary = sportAmber;
  static const Color background = surface;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onSurface = textPrimary;
  static const Color onBackground = textPrimary;
  static const Color onError = Color(0xFFFFFFFF);
  static const Color divider = stroke;
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

  static const double avatarSize = 64.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
}

class AppTextStyles {
  static const TextStyle heroTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // ADDED: Missing text style that was referenced in errors
  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
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
  
  // ADDED: Missing text style that was referenced in errors
  static const TextStyle bodySecond = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecond,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecond,
  );

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

  // Keep existing aliases
  static const TextStyle textMain = body;
  static const TextStyle chipText = caption;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: _createMaterialColor(AppColors.amethyst600),
      primaryColor: AppColors.amethyst600,
      scaffoldBackgroundColor: AppColors.surface,
      cardColor: AppColors.card,
      
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heroTitle,
        headlineMedium: AppTextStyles.sectionTitle,
        titleLarge: AppTextStyles.cardTitle,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.cardSubtitle,
        bodySmall: AppTextStyles.caption,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.sectionTitle,
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.1), // FIXED: Updated deprecated withOpacity
      ),
      
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
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.amethyst600,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.amethyst600,
        unselectedItemColor: AppColors.textSecond,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.stroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.stroke),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM, 
          vertical: AppDimensions.spaceM
        ),
      ),
      
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.amethyst600,
        disabledColor: AppColors.stroke,
        labelStyle: AppTextStyles.chipText,
        secondaryLabelStyle: AppTextStyles.chipText.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM, 
          vertical: AppDimensions.spaceS
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM)
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: AppColors.stroke, 
        thickness: 1, 
        space: 1
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM)
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static MaterialColor _createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = (color.r * 255.0).round() & 0xff; // FIXED: Updated deprecated .red
    final int g = (color.g * 255.0).round() & 0xff; // FIXED: Updated deprecated .green
    final int b = (color.b * 255.0).round() & 0xff; // FIXED: Updated deprecated .blue

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch); // FIXED: Updated deprecated .value
  }
}

// UPDATED: TripTypeHelper for 3-type system (Explore, Crawl, Sport)
class TripTypeHelper {
  final String displayName;
  final Color color;
  final IconData icon;

  const TripTypeHelper({
    required this.displayName, 
    required this.color, 
    required this.icon
  });

  // NEW: Updated for 3-type system - ONLY these 3 types exist in CoreType enum
  static TripTypeHelper fromCoreType(model.CoreType coreType) {
    switch (coreType) {
      case model.CoreType.explore:
        return const TripTypeHelper(
          displayName: 'Explore', 
          color: AppColors.exploreBlue, 
          icon: Icons.explore
        );
      case model.CoreType.crawl:
        return const TripTypeHelper(
          displayName: 'Crawl', 
          color: AppColors.crawlCrimson, 
          icon: Icons.local_bar
        );
      case model.CoreType.sport:
        return const TripTypeHelper(
          displayName: 'Sport', 
          color: AppColors.sportAmber, 
          icon: Icons.sports
        );
    }
  }

  // Migration support for old types
  static TripTypeHelper fromTripType(model.TripType tripType) {
    switch (tripType) {
      case model.TripType.standard:
        return fromCoreType(model.CoreType.explore);
      case model.TripType.barcrawl:
        return fromCoreType(model.CoreType.crawl);
      case model.TripType.fitness:
      case model.TripType.challenge: // Both map to sport
        return fromCoreType(model.CoreType.sport);
    }
  }

  static TripTypeHelper fromTrip(model.Trip trip) {
    return fromCoreType(trip.currentType);
  }

  static TripTypeHelper fromBadge(model.Badge badge) {
    return fromCoreType(badge.currentType);
  }

  // Helper for dynamic type resolution - FIXED to map old types to new 3-type system
  static TripTypeHelper fromType(dynamic type) {
    final String typeString;
    if (type is model.TripType) {
      typeString = type.toString().split('.').last;
    } else if (type is model.CoreType) {
      typeString = type.toString().split('.').last;
    } else {
      typeString = type.toString();
    }

    switch (typeString.toLowerCase()) {
      case 'standard':
      case 'explore': 
        return fromCoreType(model.CoreType.explore);
      case 'barcrawl':
      case 'crawl':   
        return fromCoreType(model.CoreType.crawl);
      case 'fitness':
      case 'challenge':
      case 'active':    // OLD: Map to sport
      case 'game':      // OLD: Map to sport
      case 'sport':     // NEW: Direct mapping
        return fromCoreType(model.CoreType.sport);
      default:        
        return fromCoreType(model.CoreType.explore);
    }
  }

  // Utility methods
  static Color getColor(String tripType) => fromType(tripType).color;
  static IconData getIcon(String tripType) => fromType(tripType).icon;

  // NEW: 3-type system helpers
  static List<model.CoreType> getAllCoreTypes() => model.CoreType.values;
  static List<String> getCoreTypeDisplayNames() => ['All', 'Explore', 'Crawl', 'Sport'];
  
  static Color getCoreTypeColorWithOpacity(model.CoreType coreType, double opacity) => 
      fromCoreType(coreType).color.withValues(alpha: opacity); // FIXED: Updated deprecated withOpacity

  // Migration helper
  static model.CoreType migrateTripTypeToCore(model.TripType oldType) {
    switch (oldType) {
      case model.TripType.standard:
        return model.CoreType.explore;
      case model.TripType.barcrawl:
        return model.CoreType.crawl;
      case model.TripType.fitness:
      case model.TripType.challenge:
        return model.CoreType.sport;
    }
  }
}