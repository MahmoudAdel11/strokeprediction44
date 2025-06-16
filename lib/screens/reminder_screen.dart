import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strokeprediction/models/Reminder_Model.dart';
import 'package:strokeprediction/services/reminder_service.dart';
import 'package:strokeprediction/services/notification_service.dart';


class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  String medicineName = '';
  TimeOfDay? selectedTime;
  bool isDaily = true;
  List<MedicineReminder> reminders = [];
  MedicineReminder? editingReminder;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() async {
    final fetched = await ReminderService().fetchReminders(context);
    setState(() => reminders = fetched);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _startEdit(MedicineReminder reminder) {
    setState(() {
      editingReminder = reminder;
      medicineName = reminder.name;
      isDaily = reminder.isDaily;
      final timeParts = reminder.time.split(":");
      selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    });
  }

  void _cancelEdit() {
    setState(() {
      editingReminder = null;
      medicineName = '';
      selectedTime = null;
      isDaily = true;
    });
  }

  void _deleteReminder(int id) async {
    final success = await ReminderService().deleteReminder(id,context);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder deleted.")),
      );
      _loadReminders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete reminder.")),
      );
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || selectedTime == null) return;

    final formattedTime =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

    final reminder = MedicineReminder(
      name: medicineName,
      time: formattedTime,
      isDaily: isDaily,
    );

    bool success;
    if (editingReminder != null) {
      success = await ReminderService().updateReminder(editingReminder!.id!, reminder,context);
    } else {
      success = await ReminderService().addReminder(reminder,context);
    }

    if (success) {
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day,
          selectedTime!.hour, selectedTime!.minute);

      if (dateTime.isAfter(now)) {
        await NotificationService.scheduleNotification(
          now.millisecondsSinceEpoch ~/ 1000,
          'Medicine Reminder',
          'Time to take $medicineName',
          dateTime,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(editingReminder != null ? "Reminder updated." : "Reminder added.")),
      );

      _cancelEdit();
      _loadReminders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to ${editingReminder != null ? "update" : "add"} reminder.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("Medicine Reminders", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent.shade100
        ,
      ),
      body:

      Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent.shade100, Colors.blueGrey.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child:Column(
                  children: [ Form(
                    key: _formKey,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          TextFormField(
                            initialValue: medicineName,
                            decoration: InputDecoration(
                              labelText: 'Medicine Name',
                              prefixIcon: Icon(Icons.medication),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) => val == null || val.isEmpty ? "Required" : null,
                            onChanged: (val) => setState(() => medicineName = val),
                          ),
                          SizedBox(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              selectedTime != null
                                  ? "Selected Time: ${selectedTime!.format(context)}"
                                  : "No time selected",
                            ),
                            trailing: ElevatedButton.icon(
                              onPressed: _pickTime,
                              icon: Icon(Icons.schedule,color: Colors.black,),
                              label: Text("Pick Time",style:TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                            ),
                          ),
                          SwitchListTile(
                            thumbColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) return Colors.blue;       // When ON
                              return Colors.grey;                                                    // When OFF
                            }),
                            trackColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) return Colors.blueGrey[200]; // Track when ON
                              return Colors.grey.shade300;                                           // Track when OFF
                            }),

                            title: Text("Repeat Daily",style:TextStyle(color: Colors.black),),

                            value: isDaily,
                            onChanged: (val) => setState(() => isDaily = val),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _submit,
                                icon: Icon(editingReminder != null ? Icons.save : Icons.add,color: Colors.black,),
                                label: Text(editingReminder != null ? "Update" : "Add",style:TextStyle(color: Colors.black),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              if (editingReminder != null)
                                TextButton.icon(
                                  onPressed: _cancelEdit,
                                  icon: Icon(Icons.cancel,color: Colors.black),
                                  label: Text("Cancel",style:TextStyle(color: Colors.black),),
                                ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),
                    SizedBox(height: 20),
                    Divider(),
                    Text("Your Reminders", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    reminders.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("No reminders yet.", style: GoogleFonts.poppins(color: Colors.grey)),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final r = reminders[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(Icons.alarm, color: Colors.lightBlueAccent),
                            title: Text("${r.name}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                            subtitle: Text("Time: ${r.time} • ${r.isDaily ? "Daily" : "Once"}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () => _startEdit(r),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteReminder(r.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
            ),
          ]
      ),
    );
  }
}
