import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strokeprediction/screens/login-screen.dart';
import 'package:strokeprediction/screens/home.dart';
import 'package:strokeprediction/services/api_service.dart';



class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}
class _SingUpScreenState extends State<SingUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value!)){
                    return "Enter valid mail";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),


              SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });

                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
                      .hasMatch(value)) {
                    return 'Must contain a capital letter special character';
                  }
                  return null;
                },
              ),


              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                      });
                    },
                  ),

                  Text("I agree to the healthcare ",style: TextStyle(fontSize: 10),),
                  GestureDetector(
                    onTap: () {
                      // Handle Terms of Service tap
                    },
                    child: Text(
                      "Terms of Service",
                      style: TextStyle(color: Colors.blue,fontSize: 10),
                    ),
                  ),
                  Text(" and ",style: TextStyle(fontSize: 10),),
                  GestureDetector(
                    onTap: () {
                      // Handle Privacy Policy tap
                    },
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.blue,fontSize: 10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 200,),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You must agree to the terms to sign up.')),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      bool success = await ApiService.register(email, password);

                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed or account already exists.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),


              SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
          ),
        ),
      ),
    );
  }
}