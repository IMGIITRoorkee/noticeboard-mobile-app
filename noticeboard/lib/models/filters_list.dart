class Banner {
  final String slug;
  final String display;
  final String mainDisplay;
  Banner({this.slug, this.display, this.mainDisplay});

  static String toEndPoint(int id) {
    return 'api/noticeboard/filter/?banner=' + id.toString();
  }

  factory Banner.fromJSON(dynamic json) {
    return Banner(
        display: json['name'],
        slug: toEndPoint(json['id']),
        mainDisplay: json['parentCategory']['name']);
  }
}

class Category {
  final String mainDisplay;
  final String mainSlug;
  final List<Banner> bannerList;
  Category({this.mainDisplay, this.mainSlug, this.bannerList});

  static String toMainEndPoint(String orSlug) {
    return 'api/noticeboard/filter/?main_category=noticeboard__authorities' +
        orSlug;
  }

  factory Category.fromJSON(dynamic json) {
    return Category(
        mainDisplay: json['name'],
        mainSlug: toMainEndPoint(json['slug']),
        bannerList: json['banner']
            .map<Banner>((banner) => Banner.fromJSON(banner))
            .toList());
  }
}

class GlobalSelection {
  final String globalSlug;
  final String globalDisplayName;
  final String display;
  GlobalSelection({this.globalDisplayName, this.globalSlug, this.display});
}
