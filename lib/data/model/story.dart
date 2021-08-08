class Story {
  int? id;
  String? url;
  String? type;

  Story({
    this.id,
    this.url,
    this.type,
  });

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
