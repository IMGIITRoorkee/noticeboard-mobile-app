class RefreshToken {
  final String refreshToken;

  RefreshToken({this.refreshToken});

  factory RefreshToken.fromJSON(dynamic json) {
    return RefreshToken(refreshToken: json['refresh']);
  }
}

class AccessToken {
  final String accessToken;

  AccessToken({this.accessToken});

  factory AccessToken.fromJSON(dynamic json) {
    return AccessToken(accessToken: json['access']);
  }
}
