import 'style_recommendation.dart';

class UserPreferences {
  final Gender gender;
  final List<StyleCategory> preferredStyles;
  final List<String> preferredColors;
  final String preferredLanguage;

  UserPreferences({
    required this.gender,
    required this.preferredStyles,
    required this.preferredColors,
    required this.preferredLanguage,
  });

  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      gender: Gender.male,
      preferredStyles: [StyleCategory.casual],
      preferredColors: ['blue', 'black', 'white'],
      preferredLanguage: 'ko',
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      gender: Gender.values.firstWhere(
        (e) => e.toString() == 'Gender.${json['gender']}',
      ),
      preferredStyles: (json['preferredStyles'] as List)
          .map(
            (e) => StyleCategory.values.firstWhere(
              (style) => style.toString() == 'StyleCategory.$e',
            ),
          )
          .toList(),
      preferredColors: List<String>.from(json['preferredColors']),
      preferredLanguage: json['preferredLanguage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender.toString().split('.').last,
      'preferredStyles': preferredStyles
          .map((e) => e.toString().split('.').last)
          .toList(),
      'preferredColors': preferredColors,
      'preferredLanguage': preferredLanguage,
    };
  }

  UserPreferences copyWith({
    Gender? gender,
    List<StyleCategory>? preferredStyles,
    List<String>? preferredColors,
    String? preferredLanguage,
  }) {
    return UserPreferences(
      gender: gender ?? this.gender,
      preferredStyles: preferredStyles ?? this.preferredStyles,
      preferredColors: preferredColors ?? this.preferredColors,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
