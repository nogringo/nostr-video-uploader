class ParsedText {
  final List<String> links;
  final List<String> hashtags;

  ParsedText({required this.links, required this.hashtags});
}

ParsedText extractLinksAndHashtags(String text) {
  final RegExp hashtagRegExp = RegExp(r"#(\w+)");

  final RegExp linkRegExp = RegExp(
    r'(?:(?:https?|ftp)://)' // protocol (http, https, ftp)
    r'(?:\S+(?::\S*)?@)?' // optional username:password@
    r'(?:' // IP address or domain name
    r'(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])' // 1‑255
    r'(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}'
    r'(?:\.(?:[0-9]\d?|1\d\d|2[0-4]\d|25[0-5]))'
    r'|' // …or…
    r'(?:(?:[a-z\u00a1-\uffff0-9]-*)*' // sub‑domains
    r'[a-z\u00a1-\uffff0-9]+)'
    r'(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*'
    r'[a-z\u00a1-\uffff0-9]+)*' // second‑level domains
    r'\.(?:[a-z\u00a1-\uffff]{2,}))' // top‑level domain
    r')'
    r'(?::\d{2,5})?' // optional port
    r'(?:/[^\s]*)?', // optional path/query
    caseSensitive: false,
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
