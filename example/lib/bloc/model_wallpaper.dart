class DataWallPaper {
  String? title;
  String? copyright;
  String? fullUrl;
  String? thumbUrl;
  String? imageUrl;
  String? pageUrl;
  String? date;

  DataWallPaper({
    this.title,
    this.copyright,
    this.fullUrl,
    this.thumbUrl,
    this.imageUrl,
    this.pageUrl,
    this.date,
  });

  DataWallPaper.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    copyright = json['copyright'];
    fullUrl = json['fullUrl'];
    thumbUrl = json['thumbUrl'];
    imageUrl = json['imageUrl'];
    pageUrl = json['pageUrl'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['copyright'] = copyright;
    data['fullUrl'] = fullUrl;
    data['thumbUrl'] = thumbUrl;
    data['imageUrl'] = imageUrl;
    data['pageUrl'] = pageUrl;
    data['date'] = date;
    return data;
  }
}
