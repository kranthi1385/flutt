class Culture {
  int? cultureID;
  String? name;
  String? description;

  Culture({this.cultureID, this.name, this.description});

  Culture.fromJson(Map<String, dynamic> json) {
    cultureID = json['CultureID'];
    name = json['Name'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CultureID'] = cultureID;
    data['Name'] = name;
    data['Description'] = description;
    return data;
  }
}
