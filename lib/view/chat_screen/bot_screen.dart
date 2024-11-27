// Bot Screen
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_meet/theme/app_theme.dart';

import '../../component/myText.dart';

class BotScreen extends StatelessWidget {
  const BotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.appColors.background,
      appBar: AppBar(
        title: MyText(
          label: 'Bot Screen',
          fontSize: 20,

          alignment: true,
        ),
        backgroundColor: context.theme.appColors.primary,
      ),
      body: Center(
        child: MyText(
          label: 'This is the Bot Screen',
          fontSize: 18,

          alignment: true,
        ),
      ),
    );
  }
}
