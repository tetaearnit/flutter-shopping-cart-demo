import 'package:flutter/material.dart';
import 'package:flutter_app/src/config/app_route.dart';
import 'package:flutter_app/src/constants/app_setting.dart';
import 'package:flutter_app/src/pages/home/home_page.dart';
import 'package:flutter_app/src/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRoute().route,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(title: 'Flutter Demo Home Page'),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(), // cal async function
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
            );
          }

          final token = snapshot.data.getString(AppSetting.tokenSetting) ?? '';
          if (token.isNotEmpty) {
            return HomePage();
          }
          return LoginPage();
        },
      ),
    );
  }
}