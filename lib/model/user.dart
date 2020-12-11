class AppUser{
  final String id;
  final String fullName;
  final String email;
//  final String password;
  final String address;
  final String birthdate;
  final String photoUrl;

  AppUser({this.id, this.fullName, this.email, this.address, this.birthdate, this.photoUrl});

  AppUser.fromData(Map<String, dynamic> data)
      : id= data['id'],
        fullName= data['fullName'],
        email= data['email'],
//        password= data['password'],
        address= data['address'],
        birthdate= data['birthdate'],
        photoUrl= data['photoUrl'];

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'fullName' : fullName,
      'email' : email,
//      'password' : password,
      'address' : address,
      'birthdate' : birthdate,
      'photoUrl' : photoUrl,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppUser(
      id: map['id'],
      fullName: map['fullName'],
      email: map['email'],
//      password: map['password'],
      address: map['address'],
      birthdate: map['birthdate'],
      photoUrl: map['photoUrl']
    );
  }
}