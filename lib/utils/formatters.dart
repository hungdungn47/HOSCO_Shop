/// Concatenates a list of strings into a single comma-separated string with URL encoding
/// but preserves spaces for use in query parameters
/// @param stringList - List of strings to concatenate
/// @returns A single string with all items URL encoded (except spaces) and joined by commas
String concatenateAndEncodeStrings(List<String> stringList) {
  if (stringList.isEmpty) {
    return '';
  }

  // URL encode each string in the list before joining, but preserve spaces
  final encodedStrings = stringList.map((str) {
    // First encode the string
    String encoded = Uri.encodeComponent(str);
    // Then replace encoded spaces (%20) with actual spaces
    return encoded.replaceAll('%20', ' ');
  }).toList();
  print(encodedStrings.join(','));
  return stringList.join(',');
}
