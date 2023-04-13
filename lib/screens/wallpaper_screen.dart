import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pexels/widgets/custom_snackbar.dart';
import 'package:pexels/widgets/loading_indicator.dart';

import '../constants/constants.dart';
import '../cubit/wallpaper_cubit.dart';
import '../model/wallpaper_model.dart';
import '../widgets/image_card.dart';
import '../widgets/not_found.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: black,
      ),
      backgroundColor: creamWhite,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Wall Print',
              style: TextStyle(fontSize: 40, fontFamily: handlee),
            ),
            Neumorphic(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: InputBorder.none,
                  hintText: 'Search Wallpaper',
                  hintStyle: const TextStyle(color: grey),
                  suffixIcon: ElevatedButton(
                    child: const Icon(Icons.search),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.read<WallpaperCubit>().getWallpapers(
                            _searchController.text,
                          );
                    },
                  ),
                ),
                onSubmitted: (value) =>
                    context.read<WallpaperCubit>().getWallpapers(value),
              ),
            ),
            Expanded(
              child: BlocConsumer<WallpaperCubit, WallpaperState>(
                listener: (context, state) {
                  if (state is WallpaperError) {
                   showCustomSnackbar(context, 'Error happened');
                  }
                },
                builder: (context, state) {
                  if (state is WallpaperLoading) {
                    return const Center(child: LoadingIndicator());
                  } else if (state is WallpaperError) {
                    return const NotFoundIllustration();
                  }
                  
                  List<WallpaperModel>? wallpapers = [];
                  if (state is WallpaperLoaded) {
                    if(state.wallpapers.isEmpty){
                      return const NotFoundIllustration();
                    }
                    wallpapers = state.wallpapers;

                  } else {
                    wallpapers = context.read<WallpaperCubit>().wallpapers;
                  }
      
                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    itemBuilder: (_, index) =>
                        ImageCard(wallpaper: wallpapers![index]),
                    itemCount: wallpapers.length,
                    padding: const EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
