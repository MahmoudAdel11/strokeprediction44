
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:strokeprediction/onboarding/onboarding-model.dart';
import 'package:strokeprediction/onboarding/onboarging-builder.dart';
import 'package:strokeprediction/welcome-screen.dart';


class  onboarding extends StatefulWidget {
  onboarding({super.key});
  @override
  State<onboarding> createState() => _onboardingState();
}
class _onboardingState extends State<onboarding> {
  var pageController = PageController();
  bool islast = false;
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
          appBar: AppBar(
            backgroundColor:Colors.blue.shade100 ,
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()));
      
                // setState(() {
                //   islast=true;
                //
                //   Navigator.of(context)
                //       .push(MaterialPageRoute(builder: (context){ return Register();
                //   }));
                // });
      
              }
              , child:  Text("SKIP",
                  style: TextStyle
                    (fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[500]),
              ))
            ],
          ),
          body: PageView.builder(
            controller:pageController,
              onPageChanged: (index){
                setState(() {
                  islast = index == onboardingData.length - 1;
                });
      
      ////////////////////////////////////////////////////////////////////////
              if(index==onboardingData.length -1){
                setState(() {
                  islast = true ;
                });
              }
              else{
                setState(() {
                  islast = false ;
                });
              }
              },
              itemCount: onboardingData.length
              ,itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  onboardingBuilder(
                   onboardingModel:onboardingData[index],
                   pageController: pageController,
                   currentIndex: index,
                   lastIndex: onboardingData.length - 1),
                  SizedBox(height: 10,),

                  SmoothPageIndicator(
                    controller: pageController,
                    count: onboardingData.length,
                    axisDirection:Axis.horizontal ,
                    effect: const SlideEffect(
                      spacing: 4.0,
                      radius: 4.0,
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      paintStyle: PaintingStyle.stroke,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue),
                  ),
      
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Visibility(
      
                        visible: islast,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: (){
                            // Shared.putBOOL(key: SharedKeys.isLastOnBoarding, value: islast);
                            Navigator.of(context).push(MaterialPageRoute(builder :(context){ return const WelcomeScreen();
                            }));
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (context){ return Register();
                            // }));
                          },
                          child: const Text(
                            "NEXT",style:TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
      
          })
      ),
    );
  }
}
