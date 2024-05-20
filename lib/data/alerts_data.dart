class AlertData {
  final String alertTitle;
  final String alertText;
  final String resourcePath;

  AlertData({
    required this.alertTitle,
    required this.alertText,
    required this.resourcePath,
  });

  Map<String, dynamic> toJson() {
    return {
      "alertTitle": alertTitle,
      "alertText": alertText,
      "resourcePath": resourcePath
    };
  }
}
