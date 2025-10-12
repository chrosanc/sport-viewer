import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamed_mobile/app/theme/theme_data.dart';
import 'package:streamed_mobile/presentation/home/home_viewmodel.dart';
import 'package:streamed_mobile/presentation/splash/splash.dart';
import 'package:streamed_mobile/presentation/splash/splash_viewmodel.dart';
import 'package:streamed_mobile/presentation/stream/stream_viewmodel.dart';
void main()  {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ 
        ChangeNotifierProvider(create: (_) => SplashViewmodel()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
        ChangeNotifierProvider(create:  (_) => StreamViewmodel()),
      ],
      child: MaterialApp(
        theme: darkTheme,
        home: const Splash(),
      ),
    );
  }
}
