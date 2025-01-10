/// Utility class for string manipulations used in localization
class StringUtils {
  /// Normalizes a key by replacing spaces with underscores and converting to lowercase
  static String normalizeKey(String key) =>
      key.replaceAll(" ", "_").toLowerCase();

  /// Replace placeholders in localized string with parameters
  static String replacePlaceholders(
    String text,
    List<String> params,
    List<String>? localeParams,
    Map<String, String> localizedStrings,
  ) {
    for (int i = 0; i < params.length; i++) {
      final placeholder = "#" * (i + 1);
      final param = params[i];
      final localizedParam =
          localeParams != null ? localizedStrings[normalizeKey(param)] : param;

      if (localizedParam != null) {
        text = text.replaceFirst(placeholder, localizedParam);
      }
    }
    return text.replaceAll("#", "");
  }
}
