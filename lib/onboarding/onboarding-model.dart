class OnboardingModel{
  String imagePath;
  String description;


  OnboardingModel({
    required this.imagePath,
    required this.description,
  });
}

final List<OnboardingModel> onboardingData = [
  OnboardingModel(
    imagePath: 'assets/images/onb1.png',
    description: "Discover the primary risk factors for stroke, including high blood pressure, diabetes, and smoking, and how lifestyle changes can reduce your risk.",
  ),OnboardingModel(
    imagePath: 'assets/images/onb2.png',
    description: "Find out the steps you can take to help prevent a stroke, from adopting a balanced diet to regular exercise and managing stress levels.",
  ),OnboardingModel(
    imagePath: 'assets/images/onb3.png',
    description:"Explore recovery strategies and support options for those affected by stroke, focusing on rehabilitation, community resources, and mental health.",
  )
];
// List<OnboardingModel>data =[
//   OnboardingModel(imagePath:"assets/images/doc.png", description:"welcome to iDevice"),
//   OnboardingModel(imagePath:"assets/images/doc.png", description:"Let's help find your device"),
//   OnboardingModel(imagePath:"assets/images/doc.png", description:"Free shipping for the first one")
//
// ];