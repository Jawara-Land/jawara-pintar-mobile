class OnboardingModel {
  final String title;
  final String description;
  final String? backgroundImage;
  final String? buttonLabel;

  OnboardingModel({
    required this.title,
    required this.description,
    this.backgroundImage,
    this.buttonLabel,
  });
}
