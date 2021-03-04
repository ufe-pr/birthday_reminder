class Birthday {
  final String celebrant;
  final DateTime birthday;
  final int id;

  Birthday({this.celebrant, this.birthday, this.id});

  Birthday.fromJson(Map<String, dynamic> json)
      : celebrant = json['celebrant'],
        birthday = DateTime.tryParse(json['birthday'] ?? ''),
        id = json['id'];

  Map<String, dynamic> toJson() {
    var json = {
      'celebrant': celebrant,
      'birthday': birthday.toIso8601String(),
      'id': id,
    };
    json.removeWhere((key, value) => value == null);
    return json;
  }

  Birthday copyWith({String celebrant, DateTime birthday}) => Birthday(
        celebrant: celebrant,
        birthday: birthday,
        id: this.id,
      );
}
