import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamed_mobile/app/theme/text_theme.dart';
import 'package:streamed_mobile/presentation/splash/splash_viewmodel.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewmodel>(
      builder: (context, viewmodel, child) {
        viewmodel.initilaizeSplash(context);
        return Center(
          child: Container(
            child: Text(
              'Streamed',
              style: AppTextTheme.darkTextTheme.displayLarge,
            ),
          ),
        );
      },
    );
  }
}
