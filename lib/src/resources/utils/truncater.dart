String truncate(String string, {int limit = 10}) {
  final truncatedTitle =
      string.length > limit ? '${string.substring(0, limit)}...' : string;
  return truncatedTitle;
}
