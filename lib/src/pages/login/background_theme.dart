import 'package:flutter/material.dart';

class BackGroundTheme {
  const BackGroundTheme();

  // _ meaning private variable
  static const _gradientStart = const Color(0xFFFFFFFF);
  static const _gradientEnd = const Color(0xFF40E0D0);


  // => meaning return function
  get gradientStart => _gradientStart;
  get gradientEnd => _gradientEnd;

  static const gradient = LinearGradient(
    colors: [
      _gradientStart,
      _gradientEnd,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
// ไม่ใช่ตัวแปร final (static const) ไม่สามารถประกาศใน class BackGroundTheme()
// ที่ประกาศ constructor เป็น const
// LinearGradient gradients = LinearGradient(
//   colors: [
//     _gradientStart,
//     _gradientEnd,
//   ],
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   stops: [0.0, 1.0],
// );

  BoxDecoration _boxDecoration() {
    final gradientStart = BackGroundTheme().gradientStart;
    final gradientEnd = BackGroundTheme().gradientEnd;

    final boxShadowItem = (Color color) => BoxShadow(
      color: color,
      offset: Offset(1.0, 6.0),
      blurRadius: 20.0,
    );

    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      boxShadow: <BoxShadow>[
        boxShadowItem(gradientStart),
        boxShadowItem(gradientEnd),
      ],
      gradient: LinearGradient(
        colors: [
          gradientEnd,
          gradientStart,
        ],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1.0, 1.0),
        stops: [0.0, 1.0],
      ),
    );
  }
}