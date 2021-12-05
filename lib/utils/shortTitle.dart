class ShortTitle {
  static String shortTitle(String title, int limit, String defaultTitle) {
    if (title.isNotEmpty) {
      if (title.length >= limit) {
        final newTitle = [];
        title.split(" ").fold(0, (int acc, cur) {
          if (limit >= (cur.length + acc)) {
            newTitle.add(cur);
          }
          return (acc + cur.length);
        });
        return "${newTitle.join(" ")} ...";
      }

      return title;
    }
    return defaultTitle;
  }

  static String shortAudioTitle(String title, int limit, String defaultTitle, bool dot) {
    if (title.isNotEmpty) {
      if (title.length >= limit) {
        final newTitle = [];
        title.split(" ").fold(0, (int acc, cur) {
          if (limit >= (cur.length + acc)) {
            newTitle.add(cur);
          }
          return (acc + cur.length);
        });
        return dot == true ? "${newTitle.join(" ")} ..." : "${newTitle.join(" ")}";
      }

      return title;
    } else if (title.isEmpty) {
      return "${title.substring(0, 17)} ...";
    }
    return defaultTitle;
  }
}
