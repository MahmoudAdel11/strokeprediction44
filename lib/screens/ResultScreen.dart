import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strokeprediction/screens/home.dart';
class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? predictionResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString('stroke_result');
    print("000000\n--------\n $result");
    setState(() {
      predictionResult = result;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    bool isHighRisk = predictionResult == '1';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isHighRisk
                ? [Colors.red.shade200, Colors.red.shade50]
                : [Colors.green.shade200, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isHighRisk
                    ? Icons.warning_amber_rounded
                    : Icons.verified_user_rounded,
                size: 120,
                color: isHighRisk ? Colors.red : Colors.green,
              ),
              SizedBox(height: 30),
              Text(
                isHighRisk
                    ? "⚠️ High Risk of Stroke Detected!"
                    : "✅ You’re Safe – No Stroke Risk",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isHighRisk ? Colors.red.shade800 : Colors.green.shade800,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  isHighRisk
                      ? "We advise you to consult a healthcare professional as soon as possible."
                      : "Maintain a healthy lifestyle to keep your risk low!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor:
                  isHighRisk ? Colors.redAccent : Colors.green,
                ),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text(
                  "Back",
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
