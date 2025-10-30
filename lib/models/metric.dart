class Metric {
  final String? companyId;
  final String? type;
  final String? value;
  final int? lastUpdated;

  Metric({
    this.companyId,
    this.type,
    this.value,
    this.lastUpdated,
  });

  factory Metric.fromJson(Map<String, dynamic> json) {
    return Metric(
      companyId: json['companyId'],
      type: json['type'],
      value: json['value'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (companyId != null) 'companyId': companyId,
    if (type != null) 'type': type,
    if (value != null) 'value': value,
    if (lastUpdated != null) 'lastUpdated': lastUpdated,
  };
}
