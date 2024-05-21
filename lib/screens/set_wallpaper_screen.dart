import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pexels/widgets/custom_snackbar.dart';
import 'package:pexels/widgets/loading_indicator.dart';

import '../constants/constants.dart';
import '../constants/wallpaper_location.dart';
import '../cubit/wallpaper_cubit.dart';
import '../model/wallpaper_model.dart';

class SetWallpaperScreen extends StatefulWidget {
  final WallpaperModel wallpaper;
  const SetWallpaperScreen({
    super.key,
    required this.wallpaper,
  });

  @override
  State<SetWallpaperScreen> createState() => _SetWallpaperScreenState();
}

class _SetWallpaperScreenState extends State<SetWallpaperScreen> {
  File? wallpaperFile;

  @override
  void initState() {
    super.initState();
    context.read<WallpaperCubit>().getWallpaper(widget.wallpaper.original).then(
          (value) => setState(() => wallpaperFile = value),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<WallpaperCubit, WallpaperState>(
          listener: (context, state) {
            if (state is WallpaperAppliedSuccessfully) {
              showCustomSnackbar(context, 'Applied successfully!');
            } else if (state is WallpaperAppliedFailed) {
              showCustomSnackbar(context, 'Error setting wallpaper');
            } else if (state is WallpaperDownloaded) {
              showCustomSnackbar(context, 'Wallpaper downloaded!');
            } else if (state is WallpaperDownloadError) {
              showCustomSnackbar(context, 'Error downloading image');
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              wallpaperFile == null
                  ? const LoadingIndicator()
                  : Image.file(wallpaperFile!, fit: BoxFit.cover),
              if (wallpaperFile != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async => await context
                              .read<WallpaperCubit>()
                              .setWallpaper(
                                  wallpaperFile!.path, WallpaperLocation.home),
                          child: const Icon(Icons.home),
                        ),
                        ElevatedButton(
                          onPressed: () async => await context
                              .read<WallpaperCubit>()
                              .setWallpaper(
                                  wallpaperFile!.path, WallpaperLocation.both),
                          child: const Text('Both'),
                        ),
                        ElevatedButton(
                          onPressed: () async => await context
                              .read<WallpaperCubit>()
                              .setWallpaper(
                                  wallpaperFile!.path, WallpaperLocation.lock),
                          child: const Icon(Icons.lock),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            await context
                                .read<WallpaperCubit>()
                                .saveWallpaper(widget.wallpaper.original);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 50,
                left: 0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
