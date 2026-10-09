/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改角色状态 批量修改角色状态 PATCH /system/role/available/setting */
export function systemRoleAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/role/available/setting',
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

/** 创建角色 创建角色 POST /system/role/create */
export function systemRoleCreateUsingPost({
  body,
  options,
}: {
  body: API.RoleCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaRoleOutSchema_>('/system/role/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 删除角色 删除角色 DELETE /system/role/delete */
export function systemRoleOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemRoleOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/role/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 查询角色详情 查询角色详情 GET /system/role/detail/${param0} */
export function systemRoleDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemRoleDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaRoleOutSchema_>(
    `/system/role/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出角色 导出角色 POST /system/role/export */
export function systemRoleOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemRoleOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/role/export', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 查询角色 查询角色 GET /system/role/list */
export function systemRoleListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemRoleListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListRoleOutSchema_>('/system/role/list', {
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

/** 角色授权 角色授权 PATCH /system/role/permission/setting */
export function systemRolePermissionSettingUsingPatch({
  body,
  options,
}: {
  body: API.RolePermissionSettingSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/role/permission/setting',
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

/** 修改角色 修改角色 PUT /system/role/update/${param0} */
export function systemRoleUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemRoleUpdateIdUsingPutParams;
  body: API.RoleUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaRoleOutSchema_>(
    `/system/role/update/${param0}`,
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
