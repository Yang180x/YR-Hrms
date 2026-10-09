/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 免登录 使用免登录Token快速登录 POST /system/auth/auto-login */
export function systemAuthAutoLoginUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemAuthAutoLoginUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.JWTOutSchema>('/system/auth/auto-login', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 获取免登录Token 根据用户ID生成免登录Token POST /system/auth/auto-login/token */
export function systemAuthAutoLoginTokenUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemAuthAutoLoginTokenUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.AutoLoginTokenSchema>('/system/auth/auto-login/token', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 获取免登录用户列表 获取可用于免登录快速登录的用户列表 GET /system/auth/auto-login/users */
export function systemAuthAutoLoginUsersUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.AutoLoginUserSchema[]>('/system/auth/auto-login/users', {
    method: 'GET',
    ...(options || {}),
  });
}

/** 获取验证码 获取登录验证码 GET /system/auth/captcha/get */
export function systemAuthCaptchaGetUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.CaptchaOutSchema>('/system/auth/captcha/get', {
    method: 'GET',
    ...(options || {}),
  });
}

/** 登录 登录 POST /system/auth/login */
export function systemAuthLoginUsingPost({
  body,
  options,
}: {
  body: API.BodyLoginForAccessTokenControllerSystemAuthLoginPost;
  options?: CustomRequestOptions_;
}) {
  return request<API.JWTOutSchema>('/system/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    data: body,
    ...(options || {}),
  });
}

/** 退出登录 退出登录 POST /system/auth/logout */
export function systemAuthLogoutUsingPost({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<unknown>('/system/auth/logout', {
    method: 'POST',
    ...(options || {}),
  });
}

/** 第三方OAuth跳转 浏览器重定向到微信/GitHub/Gitee/QQ 授权页；redirect_uri 为授权完成后回到前端的登录页地址（如 http://localhost:5173/login）。 GET /system/auth/oauth/${param0}/login */
export function systemAuthOauthProviderLoginUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemAuthOauthProviderLoginUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { provider: param0, ...queryParams } = params;

  return request<unknown>(`/system/auth/oauth/${param0}/login`, {
    method: 'GET',
    params: {
      ...queryParams,
    },
    ...(options || {}),
  });
}

/** 获取SM2公钥 获取SM2公钥（用于前端加密密码），仅在启用国密加密时有效 GET /system/auth/sm-public-key */
export function systemAuthSmPublicKeyUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<unknown>('/system/auth/sm-public-key', {
    method: 'GET',
    ...(options || {}),
  });
}

/** 刷新token 刷新token POST /system/auth/token/refresh */
export function systemAuthTokenRefreshUsingPost({
  body,
  options,
}: {
  body: API.RefreshTokenPayloadSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.JWTOutSchema>('/system/auth/token/refresh', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 微信小程序登录 微信小程序登录（code2Session） POST /system/auth/wx-login */
export function systemAuthWxLoginUsingPost({
  body,
  options,
}: {
  body: API.WxLoginSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.JWTOutSchema>('/system/auth/wx-login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 微信小程序手机号登录 微信小程序手机号快速登录（getPhoneNumber 2023+ 新 API） POST /system/auth/wx-phone-login */
export function systemAuthWxPhoneLoginUsingPost({
  body,
  options,
}: {
  body: API.WxPhoneLoginSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.JWTOutSchema>('/system/auth/wx-phone-login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 生成小程序码 调用微信 getwxacodeunlimit 生成小程序码（需登录） POST /system/auth/wx-qrcode/generate */
export function systemAuthWxQrcodeGenerateUsingPost({
  body,
  options,
}: {
  body: API.WxQrCodeSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.WxQrCodeOutSchema>('/system/auth/wx-qrcode/generate', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}
