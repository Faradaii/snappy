class OnboardingData {
  final String title;
  final String image;
  final String desc;

  OnboardingData({
    required this.title,
    required this.image,
    required this.desc,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      title: json['title'],
      image: json['image'],
      desc: json['desc'],
    );
  }
}
