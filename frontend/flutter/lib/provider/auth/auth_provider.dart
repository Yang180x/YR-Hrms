import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../env/constants.dart';
import '../../services/index.dart';

/// 认证状态
enum AuthStatus { unknown, authenticated, unauthenticated }

/// 认证状态 Notifier
class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    // 从 TokenStorage 内存读取（零 IO），token 在启动预热时已读入内存
    final token = TokenStorage.instance.getAccessToken() ?? '';
    if (token.isEmpty) {
      // 延迟清除 profile，避免 build 期间跨 provider 访问
      Future.microtask(() {
        ref.read(authProfileProvider.notifier).clear();
      });
      return AuthStatus.unauthenticated;
    }

    // Future.microtask 推迟到两个 provider 都完成 build 后再加载 profile
    Future.microtask(() {
      _restoreCachedProfile();
      _refreshProfile();
    });

    return AuthStatus.authenticated;
  }

  void _restoreCachedProfile() {
    final profileJson = KVStorage.getString(STORAGE_USER_PROFILE_KEY);
    if (profileJson == null || profileJson.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(profileJson);
      if (decoded is Map<String, dynamic>) {
        ref
            .read(authProfileProvider.notifier)
            .setProfile(UserProfile.fromJson(decoded));
      }
    } catch (e) {
      debugPrint('[Auth] 恢复缓存用户信息失败: $e');
      KVStorage.remove(STORAGE_USER_PROFILE_KEY);
    }
  }

  Future<void> _refreshProfile() async {
    try {
      final profile = await UserApi.profile();
      ref.read(authProfileProvider.notifier).setProfile(profile);
    } catch (e) {
      // token 可能已过期，清除并跳登录
      debugPrint('[Auth] 自动加载用户信息失败: $e');
      await logout();
    }
  }

  Future<void> login(Map<String, dynamic> tokenData) async {
    final accessToken = tokenData['access_token'] as String;
    final refreshToken = tokenData['refresh_token'] as String;
    // 写内存 + 落盘，等待完成后再切换为已登录态
    await TokenStorage.instance.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    state = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    // 清除 token（内存 + 落盘）
    TokenStorage.instance.clear();
    KVStorage.remove(STORAGE_USER_PROFILE_KEY);
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);

/// 用户信息 Provider
class AuthProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  void setProfile(UserProfile profile) {
    state = profile;
    KVStorage.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile.toJson()));
  }

  void clear() {
    state = null;
    KVStorage.remove(STORAGE_USER_PROFILE_KEY);
  }
}

final authProfileProvider = NotifierProvider<AuthProfileNotifier, UserProfile?>(
  AuthProfileNotifier.new,
);
