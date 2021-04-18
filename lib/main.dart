import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login.dart';
import 'package:shop_app/modules/onboarding/onboarding_screen.dart';
import 'package:shop_app/shared/component/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/network/local/cached_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import 'bloc_observer.dart';
import 'shared/cubit/states.dart';
import 'shared/style/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'IsDark');

  Widget startWidget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');

  if (onBoarding != null) {
    if (token != null) {
      startWidget = HomeLayout();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    startWidget = OnBoardingScreen();
  }

  print(onBoarding);
  runApp(MyApp(
    isDark: isDark,
    startWidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  const MyApp({Key key, this.isDark, this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
