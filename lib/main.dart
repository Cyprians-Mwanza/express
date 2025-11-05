import 'dart:ui';
import 'package:express/data/repositories/auth_repository.dart';
import 'package:express/logic/auth/auth_cubit.dart';
import 'package:express/presentation/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
  // Future.delayed(const Duration(seconds: 5), () {
  //   FirebaseCrashlytics.instance.crash();
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit(AuthRepository()))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kuza App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashPage(),
      ),
    );
  }
}
