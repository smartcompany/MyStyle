enum StyleCategory { casual, formal, sporty, trendy }

enum Gender { male, female }

enum WeatherType { sunny, cloudy, rainy, snowy, windy }

class StyleRecommendation {
  final String id;
  final String title;
  final String description;
  final List<String> clothingItems;
  final List<String> colors;
  final StyleCategory category;
  final WeatherType weatherType;
  final double temperature;
  final String imageUrl;
  final int confidence;

  StyleRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.clothingItems,
    required this.colors,
    required this.category,
    required this.weatherType,
    required this.temperature,
    required this.imageUrl,
    required this.confidence,
  });

  factory StyleRecommendation.fromJson(Map<String, dynamic> json) {
    return StyleRecommendation(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      clothingItems: List<String>.from(json['clothingItems']),
      colors: List<String>.from(json['colors']),
      category: StyleCategory.values.firstWhere(
        (e) => e.toString() == 'StyleCategory.${json['category']}',
      ),
      weatherType: WeatherType.values.firstWhere(
        (e) => e.toString() == 'WeatherType.${json['weatherType']}',
      ),
      temperature: (json['temperature'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      confidence: json['confidence'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'clothingItems': clothingItems,
      'colors': colors,
      'category': category.toString().split('.').last,
      'weatherType': weatherType.toString().split('.').last,
      'temperature': temperature,
      'imageUrl': imageUrl,
      'confidence': confidence,
    };
  }
}

class ActivityRecommendation {
  final String id;
  final String title;
  final String description;
  final WeatherType weatherType;
  final double temperature;
  final String category;
  final List<String> tags;

  ActivityRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.weatherType,
    required this.temperature,
    required this.category,
    required this.tags,
  });

  factory ActivityRecommendation.fromJson(Map<String, dynamic> json) {
    return ActivityRecommendation(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      weatherType: WeatherType.values.firstWhere(
        (e) => e.toString() == 'WeatherType.${json['weatherType']}',
      ),
      temperature: (json['temperature'] as num).toDouble(),
      category: json['category'] as String,
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'weatherType': weatherType.toString().split('.').last,
      'temperature': temperature,
      'category': category,
      'tags': tags,
    };
  }
}
