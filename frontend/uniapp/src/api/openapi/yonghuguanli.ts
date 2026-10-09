/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改用户状态 批量修改用户状态 PATCH /system/user/available/setting */
export function systemUserAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/user/available/setting',
    {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
      },
      data: body,
      ...(options || {}),
    }
  );
}

/** 创建用户 创建用户 POST /system/user/create */
export function systemUserCreateUsingPost({
  body,
  options,
}: {
  body: API.UserCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>('/system/user/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 上传当前用户头像 上传当前用户头像参数:- file (UploadFile): 上传的文件- request (Request): 请求对象返回:- JSONResponse: 上传头像JSON响应 POST /system/user/current/avatar/upload */
export function systemUserCurrentAvatarUploadUsingPost({
  body,
  options,
}: {
  body: API.BodyUserAvatarUploadControllerSystemUserCurrentAvatarUploadPost;
  options?: CustomRequestOptions_;
}) {
  const formData = new FormData();

  Object.keys(body).forEach((ele) => {
    const item = (body as { [key: string]: any })[ele];

    if (item !== undefined && item !== null) {
      if (typeof item === 'object' && !(item instanceof globalThis.File)) {
        if (item instanceof Array) {
          item.forEach((f) => formData.append(ele, f || ''));
        } else {
          formData.append(ele, JSON.stringify(item));
        }
      } else {
        formData.append(ele, item);
      }
    }
  });

  return request<API.ResponseSchemaUserOutSchema_>(
    '/system/user/current/avatar/upload',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      data: formData,
      ...(options || {}),
    }
  );
}

/** 查询当前用户信息 查询当前用户信息 GET /system/user/current/info */
export function systemUserCurrentInfoUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>(
    '/system/user/current/info',
    {
      method: 'GET',
      ...(options || {}),
    }
  );
}

/** 更新当前用户基本信息 更新当前用户基本信息 PUT /system/user/current/info/update */
export function systemUserCurrentInfoUpdateUsingPut({
  body,
  options,
}: {
  body: API.CurrentUserUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>(
    '/system/user/current/info/update',
    {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      data: body,
      ...(options || {}),
    }
  );
}

/** 修改当前用户密码 修改当前用户密码 PUT /system/user/current/password/change */
export function systemUserCurrentPasswordChangeUsingPut({
  body,
  options,
}: {
  body: API.UserChangePasswordSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>(
    '/system/user/current/password/change',
    {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      data: body,
      ...(options || {}),
    }
  );
}

/** 删除用户 删除用户 DELETE /system/user/delete */
export function systemUserOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemUserOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/user/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 查询用户详情 查询用户详情 GET /system/user/detail/${param0} */
export function systemUserDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemUserDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaUserOutSchema_>(
    `/system/user/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出用户 导出用户 POST /system/user/export */
export function systemUserOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemUserOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/user/export', {
    method: 'POST',
    params: {
      // page_no has a default value: 1
      page_no: '1',
      // page_size has a default value: 10
      page_size: '10',

      ...params,
    },
    ...(options || {}),
  });
}

/** 忘记密码 忘记密码 POST /system/user/forget/password */
export function systemUserForgetPasswordUsingPost({
  body,
  options,
}: {
  body: API.UserForgetPasswordSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>(
    '/system/user/forget/password',
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      data: body,
      ...(options || {}),
    }
  );
}

/** 导入用户 导入用户 POST /system/user/import/data */
export function systemUserOpenApiImportDataUsingPost({
  body,
  options,
}: {
  body: API.BodyImportObjListControllerSystemUserImportDataPost;
  options?: CustomRequestOptions_;
}) {
  const formData = new FormData();

  Object.keys(body).forEach((ele) => {
    const item = (body as { [key: string]: any })[ele];

    if (item !== undefined && item !== null) {
      if (typeof item === 'object' && !(item instanceof globalThis.File)) {
        if (item instanceof Array) {
          item.forEach((f) => formData.append(ele, f || ''));
        } else {
          formData.append(ele, JSON.stringify(item));
        }
      } else {
        formData.append(ele, item);
      }
    }
  });

  return request<API.ResponseSchemaNoneType_>('/system/user/import/data', {
    method: 'POST',
    headers: {
      'Content-Type': 'multipart/form-data',
    },
    data: formData,
    ...(options || {}),
  });
}

/** 获取用户导入模板 获取用户导入模板 POST /system/user/import/template */
export function systemUserOpenApiImportTemplateUsingPost({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/user/import/template', {
    method: 'POST',
    ...(options || {}),
  });
}

/** 查询用户 查询用户 GET /system/user/list */
export function systemUserListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemUserListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListUserOutSchema_>('/system/user/list', {
    method: 'GET',
    params: {
      // page_no has a default value: 1
      page_no: '1',
      // page_size has a default value: 10
      page_size: '10',

      ...params,
    },
    ...(options || {}),
  });
}

/** 注册用户 注册用户 POST /system/user/register */
export function systemUserRegisterUsingPost({
  body,
  options,
}: {
  body: API.UserRegisterSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>('/system/user/register', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 重置密码 重置密码 PUT /system/user/reset/password */
export function systemUserResetPasswordUsingPut({
  body,
  options,
}: {
  body: API.ResetPasswordSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaUserOutSchema_>(
    '/system/user/reset/password',
    {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      data: body,
      ...(options || {}),
    }
  );
}

/** 修改用户 修改用户 PUT /system/user/update/${param0} */
export function systemUserUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemUserUpdateIdUsingPutParams;
  body: API.UserUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaUserOutSchema_>(
    `/system/user/update/${param0}`,
    {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      params: { ...queryParams },
      data: body,
      ...(options || {}),
    }
  );
}
