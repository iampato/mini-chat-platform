class AppConfig {
  final String apiUrl;

  AppConfig({
    required this.apiUrl,
  });

  factory AppConfig.getStableConfig() {
    return AppConfig(
      apiUrl: "https://...",
    );
  }

  factory AppConfig.getInternalConfig() {
    return AppConfig(
      apiUrl: "https://...",
    );
  }

  factory AppConfig.getConfig(String packageName) {
    if (packageName == 'app....internal') {
      return AppConfig.getInternalConfig();
    } else {
      return AppConfig.getStableConfig();
    }
  }
}
