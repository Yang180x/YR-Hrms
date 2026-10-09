import '../../env/constants.dart';
import 'kv_storage.dart';

/// Token 安全存储（内存缓存 + 落盘）
///
/// 核心设计：token 在启动时一次性读入内存（[loadFromDisk]），此后所有读取
/// 均返回内存值（零 IO），写入时同步更新内存并异步落盘。
/// 作为登录态/请求注入的唯一 token 数据源，由 `authProvider` 与拦截器共享。
class TokenStorage {
  static final TokenStorage instance = TokenStorage._();

  TokenStorage._();

  String? _accessToken;
  String? _refreshToken;
  bool _loaded = false;

  /// 启动时一次性从磁盘加载到内存；重复调用无副作用
  void loadFromDisk() {
    if (_loaded) return;
    _loaded = true;
    final access = KVStorage.getString(STORAGE_ACCESS_TOKEN_KEY);
    final refresh = KVStorage.getString(STORAGE_REFRESH_TOKEN_KEY);
    _accessToken = (access != null && access.isNotEmpty) ? access : null;
    _refreshToken = (refresh != null && refresh.isNotEmpty) ? refresh : null;
  }

  /// 保存 access_token（更新内存 + 落盘）
  void saveAccessToken(String token) {
    _accessToken = token;
    KVStorage.setString(STORAGE_ACCESS_TOKEN_KEY, token);
  }

  /// 获取 access_token（内存读取，零 IO）
  String? getAccessToken() => _accessToken;

  /// 保存 refresh_token（更新内存 + 落盘）
  void saveRefreshToken(String token) {
    _refreshToken = token;
    KVStorage.setString(STORAGE_REFRESH_TOKEN_KEY, token);
  }

  /// 获取 refresh_token（内存读取，零 IO）
  String? getRefreshToken() => _refreshToken;

  /// 同时保存 access_token 和 refresh_token
  ///
  /// 先更新内存，再批量写入 [KVStorage.setStrings] 等待落盘完成，
  /// 确保两个 token 都持久化后再返回（避免只写入一个的中间态）
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await KVStorage.setStrings({
      STORAGE_ACCESS_TOKEN_KEY: accessToken,
      STORAGE_REFRESH_TOKEN_KEY: refreshToken,
    });
  }

  /// 清除所有 Token（内存 + 落盘）
  void clear() {
    _accessToken = null;
    _refreshToken = null;
    KVStorage.remove(STORAGE_ACCESS_TOKEN_KEY);
    KVStorage.remove(STORAGE_REFRESH_TOKEN_KEY);
  }
}
