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
  void initState() {
    loginBloc.context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          child: Stack(children: [
            Align(
              alignment: Alignment.center,
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
                  buildContactImgContainer(_width),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: lotsOfLove(context, _width, _height),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Container buildUsernameContainer(double _width) {
    return Container(
      width: _width * 0.75,
      child: TextField(
        decoration: usernameDecoration,
        onChanged: (value) => loginBloc.usernameSink.add(value),
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
            style: TextStyle(fontSize: 17.0, color: Colors.white),
          ),
          onPressed: () {
            loginBloc.eventSink.add(LoginEvents.loginEvent);
          },
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
