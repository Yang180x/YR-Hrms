"""wx_mini 模块单元测试（用户名规则 / 凭据闸门 / 白名单种子）。"""

from __future__ import annotations

import json
from pathlib import Path

import pytest

from app.core.exceptions import CustomException
from app.plugin.module_system.auth.wx_mini_service import (
    _check_wx_error,
    _require_mini_credentials,
    _username_for_wx_mini,
)

SEED_PARAM = (
    Path(__file__).resolve().parents[1]
    / "app/plugin/module_system/seeds/data/sys_param.json"
)


class TestUsernameForWxMini:
    """``_username_for_wx_mini`` 用户名生成规则。"""

    def test_prefix_and_truncation(self) -> None:
        """wxmini_ 前缀 + openid 截断，总长 ≤32。"""
        openid = "o" + "A1b2" * 10  # 41 字符
        username = _username_for_wx_mini(openid)
        assert username.startswith("wxmini_")
        assert len(username) <= 32

    def test_sanitizes_illegal_chars(self) -> None:
        """非字母数字字符应被替换为下划线。"""
        username = _username_for_wx_mini("open$id*unsafe!xyz")
        assert username.startswith("wxmini_")
        assert "*" not in username
        assert "!" not in username

    def test_starts_with_letter(self) -> None:
        """必须以字母开头（注册约束）。"""
        # openid 首位为数字时前缀 wxmini_ 已保证；极限场景走防御分支
        username = _username_for_wx_mini("")
        assert username[0].isalpha()


class TestMiniCredentials:
    """``_require_mini_credentials`` 配置闸门。"""

    def test_raises_when_not_configured(self, monkeypatch: pytest.MonkeyPatch) -> None:
        """AppID/AppSecret 为空时抛 CustomException（不会发起外网请求）。"""
        from app.config.setting import settings

        monkeypatch.setattr(settings, "WX_MINI_APP_ID", "")
        monkeypatch.setattr(settings, "WX_MINI_APP_SECRET", "")
        with pytest.raises(CustomException, match="未配置"):
            _require_mini_credentials()


class TestWxErrorMapping:
    """``_check_wx_error``：微信侧业务错误必须是 400，不能伪装成服务端 500。"""

    def test_no_error_passes(self) -> None:
        """errcode 缺失或为 0 时不抛异常。"""
        _check_wx_error({"openid": "o1", "session_key": "k"}, "code2Session")
        _check_wx_error({"errcode": 0, "errmsg": "ok"}, "code2Session")

    def test_invalid_code_maps_to_400_with_hint(self) -> None:
        """40029（invalid code）→ 400，且提示开发者工具测试号 / AppID 不一致排查方向。"""
        with pytest.raises(CustomException) as exc:
            _check_wx_error({"errcode": 40029, "errmsg": "invalid code, rid: abc"}, "code2Session")
        assert exc.value.status_code == 400
        assert "40029" in exc.value.msg
        assert "touristappid" in exc.value.msg

    def test_other_business_error_maps_to_400(self) -> None:
        """其它微信业务错误（如频率限制）同样按 400 返回。"""
        with pytest.raises(CustomException) as exc:
            _check_wx_error(
                {"errcode": 45011, "errmsg": "api minute-quota reach limit"}, "获取手机号"
            )
        assert exc.value.status_code == 400
        assert "45011" in exc.value.msg


class TestWhitelistSeed:
    """wx 登录端点必须列入演示模式白名单种子（与 /login 同权）。"""

    def test_wx_login_paths_in_seed(self) -> None:
        """white_api_list_path 应包含 wx-login 与 wx-phone-login。"""
        data = json.loads(SEED_PARAM.read_text(encoding="utf-8"))
        entry = next(item for item in data if item["config_key"] == "white_api_list_path")
        paths = json.loads(entry["config_value"])
        assert "/api/v1/system/auth/wx-login" in paths
        assert "/api/v1/system/auth/wx-phone-login" in paths
