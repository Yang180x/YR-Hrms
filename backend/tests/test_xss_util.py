"""xss_util 净化行为守卫（对应上游 301572d2 的 CSSSanitizer 缺口）。"""

from __future__ import annotations

from app.utils.xss_util import sanitize_html, sanitize_html_with_styles


def test_sanitize_strips_script_tag() -> None:
    """基础回归：脚本标签必须被剥离（strip=True 下标签内文本保留是 bleach 预期行为）。"""
    out = sanitize_html("<b>x</b><script>alert(1)</script>")
    assert "<script" not in out


def test_sanitize_keeps_allowed_style() -> None:
    """白名单内的 style 应保留（ALLOWED_STYLES 含 color）。"""
    out = sanitize_html('<p style="color:red">x</p>')
    assert "color" in out
    assert "red" in out


def test_sanitize_strips_disallowed_style_property() -> None:
    """白名单外的 CSS 属性必须被剥掉（CSSSanitizer 生效判据）。

    position:fixed 可被用于全屏钓鱼盖层，不在 ALLOWED_STYLES 中。
    修复前 bleach 不校验 style 值，该断言会失败（缺口复现）。
    """
    out = sanitize_html('<p style="position:fixed;top:0">x</p>')
    assert "position" not in out
    assert "fixed" not in out


def test_sanitize_html_with_styles_applies_same_css_guard() -> None:
    """sanitize_html_with_styles 与 sanitize_html 同等防护。"""
    out = sanitize_html_with_styles('<p style="position:fixed">x</p>')
    assert "position" not in out
