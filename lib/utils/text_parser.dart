class ParsedText {
  final List<String> links;
  final List<String> hashtags;

  ParsedText({required this.links, required this.hashtags});
}

ParsedText extractLinksAndHashtags(String text) {
  final RegExp hashtagRegExp = RegExp(r"#(\w+)");

  final RegExp linkRegExp = RegExp(
    r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$',
  );

  final List<String> hashtags = hashtagRegExp
      .allMatches(text)
      .map((match) => match.group(1)!)
      .where((hashtag) => hashtag.isNotEmpty)
      .toList();

  final List<String> links = linkRegExp
      .allMatches(text)
      .map((match) => match.group(0)!)
      .toList();

  // Remove duplicates
  final uniqueHashtags = hashtags.toSet().toList();
  final uniqueLinks = links.toSet().toList();

  return ParsedText(links: uniqueLinks, hashtags: uniqueHashtags);
}
