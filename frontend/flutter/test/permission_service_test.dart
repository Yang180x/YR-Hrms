import 'package:fastapiadmin_mobile/common/permission/index.dart';
import 'package:flutter_permission_wizard/flutter_permission_wizard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PermissionRequest 预设配置', () {
    test('cameraPermissionRequest 返回正确配置', () {
      final config = cameraPermissionRequest();
      expect(config.permission, equals(Permission.camera));
      expect(config.rationale?.title, '需要相机权限');
      expect(config.rationale?.allowButtonText, '去授权');
      expect(config.rationale?.denyButtonText, '暂不');
      expect(config.deniedConfig?.title, '相机权限已关闭');
      expect(config.deniedConfig?.openSettingsText, '打开设置');
    });

    test('photoPermissionRequest 返回正确配置', () {
      final config = photoPermissionRequest();
      expect(config.permission, equals(Permission.photos));
      expect(config.rationale?.title, '需要相册权限');
      expect(config.deniedConfig?.title, '相册权限已关闭');
    });

    test('microphonePermissionRequest 返回正确配置', () {
      final config = microphonePermissionRequest();
      expect(config.permission, equals(Permission.microphone));
      expect(config.rationale?.title, '需要麦克风权限');
    });

    test('自定义文案覆盖默认值', () {
      final config = cameraPermissionRequest(
        customTitle: '自定义标题',
        customDescription: '自定义描述',
      );
      expect(config.rationale?.title, '自定义标题');
      expect(config.rationale?.description, '自定义描述');
    });
  });

  group('PermissionWizardResult 类型检查', () {
    test('GrantedResult 是 PermissionWizardResult', () {
      const result = GrantedResult();
      expect(result, isA<PermissionWizardResult>());
    });

    test('DeniedResult 是 PermissionWizardResult', () {
      const result = DeniedResult(isPermanent: false);
      expect(result, isA<PermissionWizardResult>());
    });

    test('CancelledResult 是 PermissionWizardResult', () {
      const result = CancelledResult(reason: 'cancelled_by_host');
      expect(result, isA<PermissionWizardResult>());
    });

    test('LimitedResult 是 PermissionWizardResult', () {
      const result = LimitedResult();
      expect(result, isA<PermissionWizardResult>());
    });

    test('RestrictedResult 是 PermissionWizardResult', () {
      const result = RestrictedResult();
      expect(result, isA<PermissionWizardResult>());
    });
  });

  group('WizardTheme 可构建', () {
    test('WizardTheme 可使用默认构造函数', () {
      const theme = WizardTheme();
      expect(theme, isA<WizardTheme>());
    });
  });
}
