// lib/theme/app_theme.dart

import 'package:field_trip1/models/trip.dart';
import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (Amethyst)
  static const Color amethyst600 = Color(0xFF6F3CD6);
  static const Color amethyst100 = Color(0xFFECE3FF);
  
  // Surface Colors
  static const Color surface = Color(0xFFF8F4FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color stroke = Color(0xFFE3E0E8);
  
  // Text Colors
  static const Color textMain = Color(0xFF1E1B26);
  static const Color textSecond = Color(0xFF6A6774);
  
  // Trip Type Colors
  static const Color standardBlue = Color(0xFF4CA7FF);
  static const Color challengeCrimson = Color(0xFFD73E4E);
  static const Color barcrawlBronze = Color(0xFFB06A15); // Darkened for contrast
  static const Color fitnessAmber = Color(0xFFE39D00); // Darkened for contrast
  
  // Status Colors
  static const Color success = Color(0xFF299E45);
  static const Color warning = Color(0xFFF9BA03);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF2F7DED);
  
  // Social Status
  static const Color onlineGreen = Color(0xFF137A3F);
  static const Color onlineBackground = Color(0xFFC4F2CF);
  
  // ADDED: Compatibility aliases for new screens
  static const Color textPrimary = textMain;           
  static const Color textSecondary = textSecond;      
  static const Color primaryText = textMain;          
  static const Color border = stroke;                 
  static const Color amethyst400 = Color(0xFF9B5DE5); 
  static const Color amethyst300 = Color(0xFFB794F6); 
  static const Color challengeOrange = challengeCrimson; 
  static const Color challengeOrangeLight = Color(0xFFFFF3E0); 
  static const Color successLight = Color(0xFFE8F5E8);   
}

class AppDimensions {
  // Border Radius
  static const double radiusS = 8.0;   // ADDED: Small radius
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 20.0;
  static const double spaceXXL = 24.0;
  
  // Navigation
  static const double bottomNavHeight = 64.0;
  static const double appBarHeight = 56.0;
  
  // Components
  static const double buttonHeightM = 48.0;
  static const double avatarSize = 64.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
}

class AppTextStyles {
  static const TextStyle heroTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    height: 1.4,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );
  
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecond,
  );
  
  static const TextStyle chipText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle statValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textSecond,
  );
  
  // ADDED: Compatibility text styles for new screens
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textMain,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecond,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
  );
  
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: _createMaterialColor(AppColors.amethyst600),
      primaryColor: AppColors.amethyst600,
      scaffoldBackgroundColor: AppColors.surface,
      cardColor: AppColors.card,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amethyst600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: const Size(0, AppDimensions.buttonHeightM),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.amethyst600,
          side: const BorderSide(color: AppColors.amethyst600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: const Size(0, AppDimensions.buttonHeightM),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.amethyst600,
        unselectedItemColor: AppColors.textSecond,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Input Decoration Theme
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
      ),
    );
  }
  
  // Helper method to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (double strength in strengths) {
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

// UPDATED: Trip Type Helper with both old and new methods
class TripTypeHelper {
  final String displayName;
  final Color color;
  final IconData icon;

  const TripTypeHelper({
    required this.displayName,
    required this.color,
    required this.icon,
  });

  // NEW: Method needed by Explorer and Live Tracking screens
  static TripTypeHelper fromType(dynamic type) {
    String typeString;
    if (type.runtimeType.toString().contains('TripType')) {
      // It's an enum, convert to string
      typeString = type.toString().split('.').last;
    } else {
      // It's already a string
      typeString = type.toString();
    }
    
    switch (typeString.toLowerCase()) {
      case 'standard':
        return const TripTypeHelper(
          displayName: 'Standard',
          color: AppColors.standardBlue,
          icon: Icons.explore,
        );
      case 'challenge':
        return const TripTypeHelper(
          displayName: 'Challenge',
          color: AppColors.challengeCrimson,
          icon: Icons.flag,
        );
      case 'barcrawl':
        return const TripTypeHelper(
          displayName: 'Bar Crawl',
          color: AppColors.barcrawlBronze,
          icon: Icons.local_bar,
        );
      case 'fitness':
        return const TripTypeHelper(
          displayName: 'Fitness',
          color: AppColors.fitnessAmber,
          icon: Icons.fitness_center,
        );
      default:
        return const TripTypeHelper(
          displayName: 'Standard',
          color: AppColors.standardBlue,
          icon: Icons.explore,
        );
    }
  }
  
  // EXISTING: Keep your original methods
  static Color getColor(String tripType) {
    switch (tripType.toLowerCase()) {
      case 'standard':
        return AppColors.standardBlue;
      case 'challenge':
        return AppColors.challengeCrimson;
      case 'barcrawl':
        return AppColors.barcrawlBronze;
      case 'fitness':
        return AppColors.fitnessAmber;
      default:
        return AppColors.standardBlue;
    }
  }
  
  static IconData getIcon(String tripType) {
    switch (tripType.toLowerCase()) {
      case 'standard':
        return Icons.explore;
      case 'challenge':
        return Icons.flag;
      case 'barcrawl':
        return Icons.local_bar;
      case 'fitness':
        return Icons.fitness_center;
      default:
        return Icons.explore;
    }
  }
}