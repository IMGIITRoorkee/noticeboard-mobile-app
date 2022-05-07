import 'dart:math';

class NotificationToken {
  String? token;
  String? clientIdentifier;

  NotificationToken(String? token) {
    this.token = token;
    this.clientIdentifier = genClientIdentifier();
  }

  String genClientIdentifier() {
    return getRandomString(50);
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  dynamic retrievePayload() {
    return {"client_identifier": this.token, "token": this.token};
  }
}
