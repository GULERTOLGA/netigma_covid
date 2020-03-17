class ClientUser {
  final String userName;
  final String password;
  final String sessionid;
  final String firstName;
  final String lastName;
  final String email;
  final bool isNetAdmin;
  final String uid;

  ClientUser({this.uid,this.firstName, this.lastName, this.email, this.isNetAdmin, this.userName, this.password, this.sessionid});

  factory ClientUser.fromJson(Map<String, dynamic> json) {
    return new ClientUser(
      userName: json["userName"],
      password: json["password"],
      sessionid: json["sessionid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      uid: json["uid"],
      isNetAdmin: json["isNetAdmin"],
    );
  }

  Map toJsonMap() {
    Map map = {'userName':userName, 'password':password,'sessionid':sessionid };
    return map;
  }
}
