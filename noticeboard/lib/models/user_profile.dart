class UserProfile {
  final String fullName;
  final String degreeName;
  final String currentYear;
  final String branchName;
  final String picUrl;

  static String toStringYear(int year) {
    switch (year) {
      case 1:
        return "1st Year";
      case 2:
        return "2nd Year";
      case 3:
        return "3rd Year";
      case 4:
        return "4th Year";
      case 5:
        return "5th Year";
      case 6:
        return "6th Year";
    }
    return year.toString() + " Year";
  }

  UserProfile(
      {this.fullName,
      this.degreeName,
      this.currentYear,
      this.branchName,
      this.picUrl});

  factory UserProfile.fromJSON(dynamic json) {
    return UserProfile(
        picUrl: json['displayPicture'],
        fullName: json['fullName'],
        degreeName: json['roles'][0]['data']['branch']['degree']['name'],
        currentYear: toStringYear(json['roles'][0]['data']['currentYear']),
        branchName: json['roles'][0]['data']['branch']['name']);
  }
}
