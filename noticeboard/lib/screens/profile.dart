import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../styles/profile_constants.dart';
import '../bloc/profile_bloc.dart';
import '../enum/profile_enum.dart';

class Profile extends StatefulWidget {
  final UserProfile userProfile;
  Profile({@required this.userProfile});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    _profileBloc.context = context;
    super.initState();
  }

  @override
  void dispose() {
    _profileBloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: _height * 0.11),
          width: _width * 0.84,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.grey[400],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.userProfile.fullName,
                style: blackSuperBoldMediumSize,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                widget.userProfile.degreeName,
                style: lightGreySmallSize,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                widget.userProfile.currentYear,
                style: lightGreySmallSize,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                widget.userProfile.branchName,
                style: lightGreySmallSize,
              ),
              SizedBox(
                height: 40.0,
              ),
              buildMenuItem(
                  Icon(
                    Icons.collections_bookmark,
                    color: Colors.grey[600],
                  ),
                  'Bookmarks',
                  ProfileEvents.logoutEvent),
              SizedBox(
                height: 17.0,
              ),
              Container(
                color: Colors.grey[400],
                width: _width,
                height: 2.0,
              ),
              SizedBox(
                height: 17.0,
              ),
              buildMenuItem(
                  Icon(
                    Icons.feedback,
                    color: Colors.grey[600],
                  ),
                  'Feedback',
                  ProfileEvents.logoutEvent),
              SizedBox(
                height: 12.0,
              ),
              buildMenuItem(
                  Icon(
                    Icons.settings,
                    color: Colors.grey[600],
                  ),
                  'Notification settings',
                  ProfileEvents.logoutEvent),
              SizedBox(
                height: 15.0,
              ),
              buildMenuItem(
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.grey[600],
                  ),
                  'Logout',
                  ProfileEvents.logoutEvent)
            ],
          ),
        ),
      ),
    ));
  }

  GestureDetector buildMenuItem(Icon icon, String text, ProfileEvents event) {
    return GestureDetector(
      onTap: () {
        _profileBloc.eventSink.add(event);
      },
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 15.0,
          ),
          Text(
            text,
            style: boldMediumGreyMediumSize,
          )
        ],
      ),
    );
  }
}
