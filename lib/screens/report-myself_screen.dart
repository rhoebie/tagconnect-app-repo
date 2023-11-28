import 'package:TagConnect/constants/color_constant.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyselfWidget extends StatefulWidget {
  const MyselfWidget({super.key});

  @override
  State<MyselfWidget> createState() => _MyselfWidgetState();
}

class _MyselfWidgetState extends State<MyselfWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      body: Center(
        child: AvatarGlow(
          glowColor: tcRed,
          endRadius: 130,
          duration: Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          curve: Curves.easeOutQuad,
          child: Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: tcRed,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () async {},
              child: Icon(
                Icons.touch_app,
                color: tcWhite,
                size: 70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
