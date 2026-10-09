/// 头像上传状态管理
library;

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// 头像上传状态
class AvatarState {
  final File? imageFile;
  final bool isLoading;
  final String? errorMessage;

  const AvatarState({
    this.imageFile,
    this.isLoading = false,
    this.errorMessage,
  });

  AvatarState copyWith({
    File? imageFile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AvatarState(
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// 头像上传 Notifier
class AvatarNotifier extends Notifier<AvatarState> {
  final ImagePicker _picker = ImagePicker();

  @override
  AvatarState build() => const AvatarState();

  /// 从相册选择头像
  Future<void> pickFromGallery() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (file != null) {
        state = state.copyWith(imageFile: File(file.path), isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '选择图片失败：$e');
    }
  }

  /// 拍照选择头像
  Future<void> takePhoto() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (file != null) {
        state = state.copyWith(imageFile: File(file.path), isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '拍照失败：$e');
    }
  }

  /// 清除选择
  void clear() {
    state = const AvatarState();
  }
}

final avatarImageProvider = NotifierProvider<AvatarNotifier, AvatarState>(
  AvatarNotifier.new,
);
