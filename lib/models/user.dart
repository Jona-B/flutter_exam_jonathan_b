class User {
  int? userID; // Champ ID
  String? userName; // Champ Nom d'utilisateur
  String? userPassword; // Champ Mot de passe

  User({this.userID, this.userName, this.userPassword});

  factory User.generateID() {
    return User(userID: DateTime.now().millisecondsSinceEpoch, userName: '', userPassword: '');
  }
}
