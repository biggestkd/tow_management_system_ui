class Vehicle {
  final String? year;
  final String? make;
  final String? model;
  final String? state;
  final String? plateNumber;

  const Vehicle({
    this.year,
    this.make,
    this.model,
    this.state,
    this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      year: json['year']?.toString(),
      make: json['make']?.toString(),
      model: json['model']?.toString(),
      state: json['state']?.toString(),
      plateNumber: json['plateNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (year != null) 'year': year,
    if (make != null) 'make': make,
    if (model != null) 'model': model,
    if (state != null) 'state': state,
    if (plateNumber != null) 'plateNumber': plateNumber,
  };

  String get displayString {
    final parts = [year, make, model].where((p) => p != null && p!.trim().isNotEmpty).map((p) => p!.trim()).toList();
    return parts.isEmpty ? '—' : parts.join(' ');
  }
}


