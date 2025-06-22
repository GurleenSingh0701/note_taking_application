class UserProfile {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final DateTime lastLogin;

  UserProfile({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    required this.lastLogin,
  });
}


