class UserModel {
  String userID;
  String userFullName;
  String userEmail;
  String userPassword;
  String userRole;
  String userStatus;
  String userImage;

  UserModel(
      {this.userID,
      this.userFullName,
      this.userEmail,
      this.userPassword,
      this.userRole,
      this.userStatus,
      this.userImage});

  String get getUserID {
    return userID;
  }

  String get getUserFullName {
    return userFullName;
  }

  String get getUserEmail {
    return userEmail;
  }

  String get getUserPassword {
    return userPassword;
  }

  String get getUserStatus {
    return userStatus;
  }

  String get getUserImage {
    return userImage;
  }

  String get getUserRole {
    return userRole;
  }
}
