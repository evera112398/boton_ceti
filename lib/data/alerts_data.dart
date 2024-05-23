class AlertData {
  final String alertTitle;
  final String alertText;
  final String resourcePath;
  final int alertId;

  AlertData({
    required this.alertTitle,
    required this.alertText,
    required this.resourcePath,
    required this.alertId,
  });

  Map<String, dynamic> toJson() {
    return {
      "alertTitle": alertTitle,
      "alertText": alertText,
      "resourcePath": resourcePath,
      "alertId": alertId
    };
  }
}
