import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pexels/cubit/wallpaper_cubit.dart';

import 'constants/constants.dart';
import 'screens/wallpaper_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WallpaperCubit()..getWallpapers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallpapers App',
        theme: appTheme,
        home: const WallpaperScreen(),
      ),
    );
  }
}
