import 'dart:convert';
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/constants.dart';
import '../constants/wallpaper_location.dart';
import '../model/wallpaper_model.dart';

part 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  WallpaperCubit() : super(WallpaperLoading());
  String _lastQuery = 'abstract art';
  List<WallpaperModel> wallpapers = [];

  Future<void> getWallpapers([String? query]) async {
    query == null || query.isEmpty ? query = _lastQuery : _lastQuery = query;
    try {
      emit(WallpaperLoading());
      wallpapers = await _getWallpapers(query);
      emit(
        WallpaperLoaded(
          wallpapers: wallpapers,
        ),
      );
    } catch (e) {
      emit(
        WallpaperError(
          message: e.toString(),
        ),
      );
    }
  }

    Future<void> setWallpaper(String wallpaperFile, WallpaperLocation location) async {
    try {
      if (location == WallpaperLocation.both) {
        await _setWallpaper(wallpaperFile, WallpaperLocation.home);
        await _setWallpaper(wallpaperFile, WallpaperLocation.lock);
      } else {
        await _setWallpaper(wallpaperFile, location);
      }
      emit(WallpaperAppliedSuccessfully());
    } catch (_) {
      emit(WallpaperAppliedFailed());
    } finally {
      _removeTemporaryFiles();
    }
  }

  Future<File?> downloadWallpaper(String url) async {
    try {
      Directory dir = await getTemporaryDirectory();
      var response = await get(Uri.parse(url));
      var filePath = '${dir.path}/${DateTime.now().toIso8601String()}.jpg';
      File file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      return file;
    } catch (e) {
      return null;
    }
  }

  void _removeTemporaryFiles() async {
    final Directory tempDir = await getTemporaryDirectory();
    tempDir.existsSync() ? tempDir.deleteSync(recursive: true) : null;
  }

  Future<void> _setWallpaper(String file, WallpaperLocation location) async {
    await AsyncWallpaper.setWallpaperFromFile(
      filePath: file,
      wallpaperLocation: location.value,
      goToHome: false,
    );
  }

  Future<List<WallpaperModel>> _getWallpapers(String query) async {
    query = query.replaceAll(' ', '+');
    final Response response = await get(
      Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=60'),
      headers: {'Authorization': apiKey},
    );
    if (response.statusCode == 200) {
      final List<WallpaperModel> wallpapers = [];
      final Map<String, dynamic> data = jsonDecode(response.body);
      //print(response.body);
      data['photos'].forEach((element) {
        wallpapers.add(WallpaperModel.fromJson(element['src']));
      });
      return wallpapers;
    } else {
      throw Exception();
    }
  }
}
