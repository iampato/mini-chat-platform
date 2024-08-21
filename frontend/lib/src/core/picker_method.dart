// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:frontend/src/core/theme.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

Future<AssetEntity?> pickFromCamera(BuildContext c) {
  return CameraPicker.pickFromCamera(
    c,
    pickerConfig: const CameraPickerConfig(
      enableRecording: false,
      textDelegate: EnglishCameraPickerTextDelegate(),
    ),
  );
}

class PickMethod {
  const PickMethod({
    required this.method,
    this.onLongPress,
  });

  factory PickMethod.image(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.image,
          ),
        );
      },
    );
  }

  factory PickMethod.video(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.video,
          ),
        );
      },
    );
  }

  factory PickMethod.audio(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            pickerTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: majiColor,
            ),
            selectedAssets: assets,
            requestType: RequestType.audio,
            textDelegate: const EnglishAssetPickerTextDelegate(),
          ),
        );
      },
    );
  }

  factory PickMethod.camera({
    required int maxAssetsCount,
    required Function(BuildContext, AssetEntity) handleResult,
  }) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        const AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.common,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              if (path?.isAll != true) {
                return null;
              }
              return Semantics(
                label: textDelegate.sActionUseCameraHint,
                button: true,
                onTapHint: textDelegate.sActionUseCameraHint,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    Feedback.forTap(context);
                    final AssetEntity? result = await pickFromCamera(context);
                    if (result != null) {
                      handleResult(context, result);
                    }
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // factory PickMethod.cameraAndStay({required int maxAssetsCount}) {
  //   return PickMethod(
  //     method: (BuildContext context, List<AssetEntity> assets) {
  //       const AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
  //       return AssetPicker.pickAssets(
  //         context,
  //         pickerConfig: AssetPickerConfig(
  //           maxAssets: maxAssetsCount,
  //           selectedAssets: assets,
  //           requestType: RequestType.common,
  //           specialItemPosition: SpecialItemPosition.prepend,
  //           specialItemBuilder: (
  //             BuildContext context,
  //             AssetPathEntity? path,
  //             int length,
  //           ) {
  //             if (path?.isAll != true) {
  //               return null;
  //             }
  //             return Semantics(
  //               label: textDelegate.sActionUseCameraHint,
  //               button: true,
  //               onTapHint: textDelegate.sActionUseCameraHint,
  //               child: GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: () async {
  //                   final AssetEntity? result = await pickFromCamera(context);
  //                   if (result == null) {
  //                     return;
  //                   }
  //                   final AssetPicker<AssetEntity, AssetPathEntity> picker =
  //                       context.findAncestorWidgetOfExactType()!;
  //                   final DefaultAssetPickerBuilderDelegate builder =
  //                       picker.builder as DefaultAssetPickerBuilderDelegate;
  //                   final DefaultAssetPickerProvider p = builder.provider;
  //                   p.currentPath =
  //                       await p.currentPath!.obtainForNewProperties();
  //                   await p.switchPath(p.currentPath!);
  //                   p.selectAsset(result);
  //                 },
  //                 child: const Center(
  //                   child: Icon(Icons.camera_enhance, size: 42.0),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  factory PickMethod.common(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.common,
          ),
        );
      },
    );
  }

  factory PickMethod.threeItemsGrid(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            gridCount: 3,
            pageSize: 120,
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.all,
          ),
        );
      },
    );
  }

  factory PickMethod.customFilterOptions(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.video,
            filterOptions: FilterOptionGroup()
              ..setOption(
                AssetType.video,
                const FilterOption(
                  durationConstraint: DurationConstraint(
                    max: Duration(minutes: 1),
                  ),
                ),
              ),
          ),
        );
      },
    );
  }

  factory PickMethod.prependItem(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.common,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              return const Center(
                child: Text('Custom Widget', textAlign: TextAlign.center),
              );
            },
          ),
        );
      },
    );
  }

  factory PickMethod.noPreview(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.common,
            specialPickerType: SpecialPickerType.noPreview,
          ),
        );
      },
    );
  }

  factory PickMethod.keepScrollOffset({
    required DefaultAssetPickerBuilderDelegate Function() delegate,
    required Function(PermissionState state) onPermission,
    GestureLongPressCallback? onLongPress,
  }) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) async {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps != PermissionState.authorized && ps != PermissionState.limited) {
          throw StateError('Permission state error with $ps.');
        }
        onPermission(ps);
        return AssetPicker.pickAssetsWithDelegate(
          context,
          delegate: delegate(),
        );
      },
      onLongPress: onLongPress,
    );
  }

  factory PickMethod.changeLanguages(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            textDelegate: const EnglishAssetPickerTextDelegate(),
          ),
        );
      },
    );
  }

  factory PickMethod.preventGIFPicked(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            selectPredicate: (BuildContext c, AssetEntity a, bool isSelected) {
              debugPrint('Asset title: ${a.title}');
              return a.title?.endsWith('.gif') != true;
            },
          ),
        );
      },
    );
  }

  factory PickMethod.customizableTheme(int maxAssetsCount) {
    return PickMethod(
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            pickerTheme: AssetPicker.themeData(
              Colors.lightBlueAccent,
              light: true,
            ),
          ),
        );
      },
    );
  }

  /// The core function that defines how to use the picker.
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;

  final GestureLongPressCallback? onLongPress;
}
