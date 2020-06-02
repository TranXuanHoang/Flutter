class User {
  final String email;
  final String username;
  final String password;

  User({
    this.email = '',
    this.username = '',
    this.password = '',
  });

  @override
  String toString() {
    return '$email | $username | $password';
  }
}
