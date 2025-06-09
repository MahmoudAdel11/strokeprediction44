class MedicineReminder {
  final int? id;
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
      id: json['id'],
      name: json['name'],
      time: json['time'],
      isDaily: json['isDaily'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'time': time,
      'isDaily': isDaily,
    };
  }
}
