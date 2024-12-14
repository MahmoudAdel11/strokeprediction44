import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strokeprediction/onboarding/onboarding-model.dart';


class onboardingBuilder extends StatelessWidget {
  OnboardingModel onboardingModel;
  PageController pageController;
  int currentIndex;
  int lastIndex;
   onboardingBuilder({super.key,
     required this.onboardingModel,
     required this.pageController,
     required this.currentIndex,
     required this.lastIndex,
   });

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 720, // Specify height for the first container
              width: 400,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "${onboardingModel.imagePath}",
                    height: 500,
                    width: 400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -10,
              right: -10,
              child:
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.blueAccent.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
        
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${onboardingModel.description}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      radius: 24,
                      child: IconButton(
                        onPressed: () {
                          if (currentIndex < lastIndex) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      );

///////////////////////////////////////////////
    //   Column(
    //     children: [
    //       Container(
    //
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(100),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withOpacity(0.1),
    //               blurRadius: 10,
    //               offset: const Offset(0, 5),
    //             ),
    //           ],
    //         ),
    //         child: ClipRRect(
    //
    //           borderRadius: BorderRadius.circular(100),
    //           child: Image.asset(
    //             "${onboardingModel.imagePath}",
    //             height: 500,
    //             width: 400,
    //
    //           ),
    //         ),
    //       ),
    //
    //       Container(
    //         padding: const EdgeInsets.all(20),
    //         margin: const EdgeInsets.symmetric(horizontal: 10),
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             colors: [Colors.blue.shade300, Colors.blueAccent.shade400],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //           ),
    //           borderRadius: BorderRadius.circular(20),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withOpacity(0.1),
    //               blurRadius: 10,
    //               offset: const Offset(0, 5),
    //             ),
    //           ],
    //         ),
    //         child: Row(
    //           children: [
    //             Expanded(
    //               child: Text(
    //                 "${onboardingModel.description}",
    //                 style: const TextStyle(
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.w600,
    //                   color: Colors.black87,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(width: 10,),
    //             CircleAvatar(
    //               backgroundColor: Colors.blue.shade100,
    //               radius: 24,
    //               ////////////////////////////////////////////////////////////////////
    //               child: IconButton(
    //                 onPressed: () {
    //                   if (currentIndex < lastIndex) {
    //                     pageController.nextPage(
    //                       duration: const Duration(milliseconds: 300),
    //                       curve: Curves.easeInOut,
    //                     );
    //                   }
    //                 },
    //                 icon: const Icon(Icons.arrow_forward, color: Colors.white),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    // );
  }
}

