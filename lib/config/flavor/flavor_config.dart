enum FlavorType { premium, free }

class FlavorValues {
  final String statusSubscription;

  const FlavorValues({this.statusSubscription = "Free App"});
}

class FlavorConfig {
  final FlavorType flavor;
  final FlavorValues values;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavor = FlavorType.free,
    this.values = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}
