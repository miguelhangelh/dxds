class Country {
  int? id;
  String? name;
  String? emoji;
  String? emojiU;
  List<Region>? state;

  Country({
    this.id,
    this.name,
    this.emoji,
    this.emojiU,
    this.state,
  });

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    if (json['state'] != null) {
      state = [];
      json['state'].forEach((v) {
        state!.add(Region.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['emoji'] = emoji;
    data['emojiU'] = emojiU;
    if (state != null) {
      data['state'] = state!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Region {
  int? id;
  String? name;
  int? countryId;
  List<City>? city;

  Region({this.id, this.name, this.countryId, this.city});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    if (json['city'] != null) {
      city = [];
      json['city'].forEach((v) {
        city!.add(City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    if (city != null) {
      data['city'] = city!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  int? id;
  String? name;
  int? stateId;

  City({this.id, this.name, this.stateId});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state_id'] = stateId;
    return data;
  }
}
