import 'package:flutter/material.dart';
import 'package:flutter_app/src/config/app_route.dart';
import 'package:flutter_app/src/constants/app_setting.dart';
import 'package:flutter_app/src/constants/asset.dart';
import 'package:flutter_app/src/pages/login/background_theme.dart';
import 'package:flutter_app/src/pages/login/btn_theme.dart';
import 'package:flutter_app/src/view_model/sso_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold เป็น ตัวเลือกสำหรับการออกแบบในแต่ละหน้าจอ
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: BackGroundTheme.gradient,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 48),
                Image.asset(
                  Asset.logoImage,
                  width: 200,
                ),
                Stack(alignment: Alignment.bottomCenter, children: [
                  Card(
                    margin: EdgeInsets.only(
                        left: 22, top: 22, right: 22, bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 22, top: 22, right: 22, bottom: 62),
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _usernameController,
                            decoration: InputDecoration(
                                hintText: "example@gmail.com",
                                labelText: 'username',
                                icon: Icon(Icons.person),
                                border: InputBorder.none),
                          ),
                          Divider(
                            height: 28,
                            indent: 22,
                            endIndent: 22,
                          ),
                          TextField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'password',
                              icon: Icon(Icons.lock),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BtnTheme().btnBoxDecoration,
                    width: 280,
                    height: 52,
                    child: TextButton(
                        onPressed: () async {
                          final username = _usernameController.text;
                          final password = _passwordController.text;

                          if (username == 'singh@gmail.com' &&
                              password == '00000000') {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            var token = 'singh1234567890';

                            prefs.setString(AppSetting.tokenSetting, token);
                            prefs.setString(
                                AppSetting.usernameString, username);

                            Navigator.pushReplacementNamed(
                                context, AppRoute.homeRoute);
                            print('Login Success!!');
                          } else {
                            print('user or password incorrect!!!');
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  )
                ]),
                _buildTextButton('Forget Password', onPressed: () {}),
                SsoButton(),
                _buildTextButton('Register', onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTextButton(String text, {VoidCallback onPressed}) {
    return Container(
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(color: Colors.white70),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SsoButton extends StatelessWidget {
  const SsoButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: SSOViewModel()
            .item
            .map((item) => FloatingActionButton(
          heroTag: item.backgroundColor.toString(),
          onPressed: item.onPressed,
          child: FaIcon(item.icon),
          backgroundColor: item.backgroundColor,
        ))
            .toList(),
      ),
    );
  }
}