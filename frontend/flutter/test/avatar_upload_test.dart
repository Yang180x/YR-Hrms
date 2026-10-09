import 'package:fastapiadmin_mobile/provider/permission/avatar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AvatarNotifier - 头像状态管理', () {
    test('初始状态正确', () {
      final container = ProviderContainer();
      addTearDown(() => container.dispose());

      final state = container.read(avatarImageProvider);
      expect(state.imageFile, isNull);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('clear 重置状态', () {
      final container = ProviderContainer();
      addTearDown(() => container.dispose());

      final notifier = container.read(avatarImageProvider.notifier);
      notifier.clear();

      final state = container.read(avatarImageProvider);
      expect(state.imageFile, isNull);
      expect(state.isLoading, false);
      expect(state.errorMessage, isNull);
    });

    test('copyWith 正确更新字段', () {
      const state = AvatarState();
      final updated = state.copyWith(isLoading: true);
      expect(updated.isLoading, true);
      expect(updated.imageFile, isNull);
      expect(updated.errorMessage, isNull);
    });
  });
}
