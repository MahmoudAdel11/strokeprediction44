import 'package:flutter/material.dart';
import 'package:strokeprediction/screens/ResultScreen.dart';
import 'package:strokeprediction/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrokePredictionForm extends StatefulWidget {
  @override
  _StrokePredictionFormState createState() => _StrokePredictionFormState();
}

class _StrokePredictionFormState extends State<StrokePredictionForm> {
  final _formKey = GlobalKey<FormState>();
  int? age;
  bool? hypertension;
  bool? heartDisease;
  bool? everMarried;
  bool? male;
  String? workType;
  String? residenceType;
  double? avgGlucoseLevel;
  double? bmi;
  String? smokingStatus;
  //

  //
  Widget buildInputField({
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget buildDropdownField<T>({
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Stroke Risk Prediction",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700)),
                  SizedBox(height: 20),
                  buildDropdownField<bool>(
                    hint: "Gender",
                    icon: Icons.person,
                    items: [
                      DropdownMenuItem(value: true, child: Text("Male")),
                      DropdownMenuItem(value: false, child: Text("Female")),
                    ],
                    onChanged: (value) => male = value,
                    validator: (value) =>
                    value == null ? 'Please select gender' : null,
                  ),
                  buildInputField(
                    hint: "Enter your age",
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter age';
                      if (int.tryParse(value) == null) return 'Invalid number';
                      return null;
                    },
                    onSaved: (value) => age = int.parse(value!),
                  ),
                  buildDropdownField<bool>(
                    hint: "Hypertension",
                    icon: Icons.monitor_heart,
                    items: [
                      DropdownMenuItem(value: true, child: Text("Yes, have Hypertension")),
                      DropdownMenuItem(value: false, child: Text("No, have not Hypertension")),
                    ],
                    onChanged: (value) => hypertension = value,
                    validator: (value) =>
                    value == null ? 'Please select an option' : null,
                  ),
                  buildDropdownField<bool>(
                    hint: "Heart Disease",
                    icon: Icons.favorite_border,
                    items: [
                      DropdownMenuItem(value: true, child: Text("Yes,have Heart Disease")),
                      DropdownMenuItem(value: false, child: Text("No,have not Heart Disease")),
                    ],
                    onChanged: (value) => heartDisease = value,
                    validator: (value) =>
                    value == null ? 'Please select an option' : null,
                  ),
                  buildDropdownField<bool>(
                    hint: "Ever Married",
                    icon: Icons.question_mark,
                    items: [
                      DropdownMenuItem(value: true, child: Text("Yes, Married")),
                      DropdownMenuItem(value: false, child: Text("No,not Married yet")),
                    ],
                    onChanged: (value) => everMarried = value,
                    validator: (value) =>
                    value == null ? 'Please select an option' : null,
                  ),
                  buildDropdownField<String>(
                    hint: "Work Type",
                    icon: Icons.work_outline,
                    items: [
                      DropdownMenuItem(value: "Private", child: Text("Private")),
                      DropdownMenuItem(value: "Self-employed", child: Text("Self-employed")),
                      DropdownMenuItem(value: "children", child: Text("Children")),
                      DropdownMenuItem(value: "Govt_job", child: Text("Govt Job")),
                      DropdownMenuItem(value: "Never_worked", child: Text("Never Worked")),
                    ],
                    onChanged: (value) => workType = value,
                    validator: (value) =>
                    value == null ? 'Please select work type' : null,
                  ),
                  buildDropdownField<String>(
                    hint: "Residence Type",
                    icon: Icons.home,
                    items: [
                      DropdownMenuItem(value: "Urban", child: Text("Urban")),
                      DropdownMenuItem(value: "Rural", child: Text("Rural")),
                    ],
                    onChanged: (value) => residenceType = value,
                    validator: (value) =>
                    value == null ? 'Please select residence type' : null,
                  ),

                  buildInputField(
                    hint: "Average Glucose Level",
                    icon: Icons.water_damage_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter glucose level';
                      if (double.tryParse(value) == null)
                        return 'Invalid number';
                      return null;
                    },
                    onSaved: (value) => avgGlucoseLevel = double.parse(value!),
                  ),
                  buildInputField(
                    hint: "BMI",
                    icon: Icons.accessibility_new,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter BMI';
                      if (double.tryParse(value) == null) return 'Invalid BMI';
                      return null;
                    },
                    onSaved: (value) => bmi = double.parse(value!),
                  ),
                  buildDropdownField<String>(
                    hint: "Smoking Status",
                    icon: Icons.smoking_rooms,
                    items: [
                      DropdownMenuItem(value: "never smoked", child: Text("Never Smoked")),
                      DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
                      DropdownMenuItem(value: "formerly smoked", child: Text("Formerly Smoked")),
                      DropdownMenuItem(value: "smokes", child: Text("Smokes")),
                    ],
                    onChanged: (value) => smokingStatus = value,
                    validator: (value) =>
                    value == null ? 'Please select smoking status' : null,
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Predicting stroke risk...")),
            );

            try {
              await ApiService.predictStroke(
                context: context,
                age: age!,
                hypertension: hypertension!,
                heartDisease: heartDisease!,
                everMarried: everMarried!,
                male: male!,
                workType: workType!,
                residenceType: residenceType!,
                avgGlucoseLevel: avgGlucoseLevel!,
                bmi: bmi!,
                smokingStatus: smokingStatus!,
              );

              final prefs = await SharedPreferences.getInstance();
              final result = prefs.getString('stroke_result') ?? 'Unknown';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Prediction failed. Please try again.")),
              );
            }
          }
        },


        child: Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.check, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
