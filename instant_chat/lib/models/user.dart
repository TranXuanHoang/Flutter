class User {
  final String profileImagePath;
  final String email;
  final String username;
  final String password;

  User({
    this.profileImagePath,
    this.email = '',
    this.username = '',
    this.password = '',
  });

  User copyWith({
    String newProfileImagePath,
    String newEmail,
    String newUsername,
    String newPassword,
  }) {
    String profileImagePath = newProfileImagePath ?? this.profileImagePath;
    String email = newEmail ?? this.email;
    String username = newUsername ?? this.username;
    String password = newPassword ?? this.password;
    return User(
      profileImagePath: profileImagePath,
      email: email,
      username: username,
      password: password,
    );
  }

  @override
  String toString() {
    return 'email: $email | username: $username | password: $password | profileImagePath: $profileImagePath';
  }
}
