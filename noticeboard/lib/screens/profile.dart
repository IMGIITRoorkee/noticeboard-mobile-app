import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class Profile extends StatefulWidget {
  final UserProfile userProfile;
  Profile({@required this.userProfile});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.userProfile.fullName),
      ),
    );
  }
}
