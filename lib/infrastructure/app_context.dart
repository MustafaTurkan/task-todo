class AppContext {
  AppUser _user;
  AppUser get user {
    return _user;
  }

  void registerAppUser(
    String userId,
  ) {
    _user = AppUser(userId);
  }
}

class AppUser {
  AppUser(this.userId);
  final String userId;
}
