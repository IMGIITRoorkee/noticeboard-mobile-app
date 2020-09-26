class UserProfile {
  final String fullName;
  final String degreeName;
  final String currentYear;
  final String branchName;

  static String toStringYear(int year) {
    return year.toString() + ' Year';
  }

  UserProfile(
      {this.fullName, this.degreeName, this.currentYear, this.branchName});

  factory UserProfile.fromJSON(dynamic json) {
    return UserProfile(
        fullName: json['fullName'],
        degreeName: json['roles'][0]['data']['branch']['degree']['name'],
        currentYear: toStringYear(json['roles'][0]['data']['currentYear']),
        branchName: json['roles'][0]['data']['branch']['name']);
  }
}
