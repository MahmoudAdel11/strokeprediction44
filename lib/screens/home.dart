import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:strokeprediction/screens/chat-bot-screen.dart';
import 'package:strokeprediction/screens/labb.dart';
import 'package:strokeprediction/screens/map_screen.dart';
import 'package:strokeprediction/screens/maptest.dart';
import 'package:strokeprediction/screens/reminder_screen.dart';
import 'package:strokeprediction/services/api_service.dart';
import 'package:strokeprediction/screens/welcome-screen.dart';



class HomePage extends StatelessWidget {

  void _logout(BuildContext context) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Welcome to Your Health Assistant',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.blueAccent),
                    tooltip: 'Logout',
                    onPressed: () {
                      ApiService.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      );
                    },
                  ),
                ],
              ),


              SizedBox(height: 10),
              Text(
                'How can we help you today?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildAnimatedButton(
                      context,
                      'Upload Lab Test',
                      'assets/images/Animation4.json',
                      Colors.lightBlueAccent,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StrokePredictionForm(),
                          ),
                        );
                      },
                    ),

                    _buildAnimatedButton(
                      context,
                      'Find Nearest Hospital',
                      'assets/images/Animation15.json',
                      Colors.lightBlueAccent,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapTest(),
                          ),
                        );
                      },
                    ),
                    _buildAnimatedButton(
                      context,
                      'Talk to Your Chatbot',
                      'assets/images/Animation1.json',
                      Colors.lightBlueAccent,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(),
                          ),
                        );
                      },
                    ),
                    _buildAnimatedButton(
                      context,
                      'Your Reminder',
                      'assets/images/Animation3.json',
                      Colors.lightBlueAccent,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReminderScreen(),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(BuildContext context, String title, String animationPath, Color shadowColor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [shadowColor.withOpacity(0.8), shadowColor.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              animationPath,
              height: 80,
              repeat: true,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}




