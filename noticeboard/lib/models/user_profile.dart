class UserProfile {
  final String fullName;
  final String degreeName;
  final String currentYear;
  final String branchName;
  final String picUrl;

  static String toStringYear(int year) {
    return year.toString() + ' Year';
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
