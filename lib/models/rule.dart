class Rule {
  final String unit;
  final String condition;

  Rule({
    required this.unit,
    required this.condition,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      unit: json['unit'] ?? '',
      condition: json['condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'unit': unit,
    'condition': condition,
  };
}

