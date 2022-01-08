import 'dart:math';

import 'package:Shop_App/screens/auth_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                  width: size.width,
                  height: size.height * .5,
                  color: Theme.of(context).primaryColor),
            ),
            SingleChildScrollView(
              child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    SizedBox(
                      height: size.height * .3,
                      child: SvgPicture.asset('assets/icons/logo.svg'),
                    ),
                    const SizedBox(height: 30),
                    Flexible(
                      flex: size.width > 600 ? 2 : 1,
                      child: AuthCard(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    //_heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        //height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'E-Mail',
                      focusColor: Theme.of(context).primaryColor),
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                AnimatedContainer(
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  child: FadeTransition(
                    opacity: _opacity,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
