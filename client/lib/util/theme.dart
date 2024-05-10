import 'package:flutter/material.dart';

class EdeeColors {
  static const Color blue = Color.fromRGBO(87, 131, 209, 1);
  static const Color edeeYellow = Color.fromRGBO(255, 216, 119, 1);
  static const backgroundColor = Color.fromRGBO(14, 21, 33, 1);
  static const Color edeeOrange = Color.fromRGBO(251, 176, 59, 1);
  static const Color edeeBlack = Color.fromRGBO(26, 26, 26, 1);
  static const Color edeePurple10Percent = Color.fromRGBO(97, 52, 131, 0.1);
  static const Color white = Colors.white;
}

extension TextStyleHelpers on TextStyle {
  TextStyle weight(FontWeight w) {
    return copyWith(fontWeight: w);
  }

  TextStyle color(Color c) {
    return copyWith(color: c);
  }
}

class TextStyles {
  static const TextStyle heading4Small = TextStyle(
    fontSize: 12,
    color: Colors.white,
  );
  static const TextStyle heading3Medium = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
  static const TextStyle heading2Large = TextStyle(
    fontSize: 24,
    color: Colors.white,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 8,
    color: Colors.white,
    fontFamily: 'Alberta Sans',
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontFamily: 'Alberta Sans',
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontFamily: 'Alberta Sans',
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontFamily: 'Alberta Sans',
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontFamily: 'Alberta Sans',
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Alberta Sans',
  );
}

class CustomTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: EdeeColors.blue,
    scaffoldBackgroundColor: EdeeColors.backgroundColor,
    cardColor: EdeeColors.edeeYellow,
    hintColor: EdeeColors.white,
    fontFamily: 'Kreadon',
    textTheme: const TextTheme(
      titleLarge: TextStyles.heading2Large,
      titleMedium: TextStyles.heading3Medium,
      titleSmall: TextStyles.heading4Small,
      bodyMedium: TextStyles.bodyMedium,
      bodySmall: TextStyles.bodySmall,
      bodyLarge: TextStyles.bodyLarge,
      labelLarge: TextStyles.labelLarge,
      labelMedium: TextStyles.labelMedium,
      labelSmall: TextStyles.labelSmall,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: EdeeColors.edeeBlack),
      ),
      labelStyle: TextStyle(color: EdeeColors.blue),
      hintStyle: TextStyle(color: Colors.black38),
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyles.heading3Medium,
      toolbarTextStyle: TextStyles.heading3Medium,
      iconTheme: IconThemeData(
        color: EdeeColors.white,
      ),
      elevation: BorderSide.strokeAlignCenter,
    ),
  );
}
