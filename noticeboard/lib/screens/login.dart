import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:noticeboard/enum/login_enum.dart';
import 'package:noticeboard/global/password_field.dart';
import '../bloc/login_bloc.dart';
import '../styles/login_constants.dart';
import '../global/global_functions.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginBloc = LoginBloc();

  @override
  void dispose() {
    _loginBloc.disposeStreams();
    super.dispose();
  }

  @override
  void initState() {
    _loginBloc.context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        child: StreamBuilder<LoginState>(
            initialData: LoginState.initLogin,
            stream: _loginBloc.progressStream,
            builder: (context, snapshot) {
              if (snapshot.data == LoginState.initLogin)
                return SingleChildScrollView(
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
                            sizedBox(20.0),
                            FormBuilder(
                                key: _loginBloc.formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 250.0,
                                      child: themeFormTextField(
                                          'username', 'Username', context, false),
                                    ),
                                    Container(
                                        width: 250,
                                        child: PasswordField(
                                          fieldName: 'password',
                                          fieldHint: 'Password',
                                          context: context,
                                        )),
                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                globalBlue),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      onPressed: () => _loginBloc.login(),
                                      child: Text('Login'),
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                )),
                            sizedBox(_height * 0.02),
                            buildContactImgContainer(_width),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: lotsOfLove(context, _width),
                        ),
                      )
                    ]),
                  ),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
