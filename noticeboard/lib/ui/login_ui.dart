import 'package:flutter/material.dart';
import 'package:noticeboard/enum/login_enum.dart';
import '../bloc/login_bloc.dart';
import '../styles/login_constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginBloc = LoginBloc();

  @override
  void dispose() {
    loginBloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              containsBranding(context, _width, _height),
              SizedBox(
                height: 20.0,
              ),
              buildUsernameContainer(_width),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                  initialData: true,
                  stream: loginBloc.showPasswordStream,
                  builder: (context, snapshot) {
                    return buildPasswordContainer(_width, snapshot);
                  }),
              SizedBox(
                height: _height * 0.04,
              ),
              StreamBuilder(
                initialData: false,
                stream: loginBloc.allowedStream,
                builder: (context, snapshot) {
                  if (snapshot.data)
                    return buildLoginEnabledBtn(_width);
                  else
                    return buildLoginDisabledBtn(_width);
                },
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              buildContactImgContainer(_width)
            ],
          ),
        ),
      ),
    );
  }

  Widget containsBranding(BuildContext context, double _width, double _height) {
    return Container(
      width: _width * 0.75,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.feedback,
              size: _width * 0.15,
              color: Colors.blueAccent[200],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Channel i',
              style: TextStyle(
                  color: Colors.blueAccent[200], fontSize: _width * 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Container buildContactImgContainer(double _width) {
    return Container(
      width: _width * 0.60,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text("Having trouble signing in?")),
            Text(
              " Contact IMG",
              overflow: TextOverflow.fade,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Container buildUsernameContainer(double _width) {
    return Container(
      width: _width * 0.75,
      child: TextField(
        decoration: usernameDecoration,
        onChanged: (value) => loginBloc.emailSink.add(value),
      ),
    );
  }

  Container buildPasswordContainer(double _width, AsyncSnapshot snapshot) {
    return Container(
      width: _width * 0.75,
      child: TextField(
        obscureText: snapshot.data,
        decoration: buildpasswordDecoration(snapshot.data),
        onChanged: (value) => loginBloc.passwordSink.add(value),
      ),
    );
  }

  ButtonTheme buildLoginEnabledBtn(double width) {
    return ButtonTheme(
        height: 40.0,
        minWidth: width * 0.60,
        child: RaisedButton(
          color: Colors.blue[300],
          child: Text(
            "Log In",
            style: TextStyle(fontSize: 17.0),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          onPressed: () {},
        ));
  }

  ButtonTheme buildLoginDisabledBtn(double width) {
    return ButtonTheme(
        height: 40.0,
        minWidth: width * 0.60,
        child: RaisedButton(
          color: Colors.blue[100],
          child: Text(
            "Log In",
            style: TextStyle(fontSize: 17.0),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
          onPressed: () {},
        ));
  }

  InputDecoration buildpasswordDecoration(bool toHide) {
    return InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: IconButton(
          onPressed: () {
            loginBloc.eventSink.add(LoginEvents.togglePasswordView);
          },
          icon: !toHide ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        ));
  }
}
