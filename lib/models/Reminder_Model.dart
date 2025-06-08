class MedicineReminder {
  final int? id; // Make it nullable and optional
  final String name;
  final String time;
  final bool isDaily;

  MedicineReminder({
    this.id, // Optional
    required this.name,
    required this.time,
    required this.isDaily,
  });

  factory MedicineReminder.fromJson(Map<String, dynamic> json) {
    return MedicineReminder(
      id: json['id'], // This can be null when adding
      name: json['name'],
      time: json['time'],
      isDaily: json['isDaily'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // Include only if not null (for update)
      'name': name,
      'time': time,
      'isDaily': isDaily,
    };
  }
}
