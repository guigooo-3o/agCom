class City {
  final String cidade;

  City({this.cidade});

  City.fromData(Map<String, dynamic> data)
      :
        cidade= data['cidade'];

  Map<String, dynamic> toMap(){
    return {
      'cidade' : cidade,
    };
  }

  static City fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return City(
        cidade: map ['cidade'],
    );
  }
}