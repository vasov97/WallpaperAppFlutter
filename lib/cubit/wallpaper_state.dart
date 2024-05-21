part of 'wallpaper_cubit.dart';


abstract class WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState{
  List<WallpaperModel> wallpapers;
  WallpaperLoaded({required this.wallpapers});
}

class WallpaperError extends WallpaperState{
 final String message;

  WallpaperError({required this.message});
}

class WallpaperAppliedSuccessfully extends WallpaperState{}

class WallpaperAppliedFailed extends WallpaperState{}

class WallpaperDownloaded extends WallpaperState{}

class WallpaperDownloadError extends WallpaperState{}
