import 'package:assignment/utils/internetConnection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'features/auth/userAuth/login/liginView.dart';
import 'features/home/presenation/manager/allProductCubit.dart';
import 'features/home/presenation/view/homeView.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();
  final storage = FlutterSecureStorage();
  String? currentToken = await storage.read(key: 'token') ?? '0';

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white , statusBarIconBrightness: Brightness.dark));

  runApp( MyApp(int.parse(currentToken)));
}

class MyApp extends StatelessWidget {
  MyApp(this.token);
  final int token ;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>GetProductCubit(GetProductService()) ,

      child: MultiBlocProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>ConnectivityProvider()),
        ],
        child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          // title: 'assignment',
          home: token == 2 ? HomeView() :  LoginView(),
        ),
      ),
    );
  }
}
