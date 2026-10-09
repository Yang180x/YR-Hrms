/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改菜单状态 批量修改菜单状态 PATCH /system/menu/available/setting */
export function systemMenuAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/menu/available/setting',
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

/** 创建菜单 创建菜单 POST /system/menu/create */
export function systemMenuCreateUsingPost({
  body,
  options,
}: {
  body: API.MenuCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaMenuOutSchema_>('/system/menu/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 删除菜单 删除菜单 DELETE /system/menu/delete */
export function systemMenuOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemMenuOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/menu/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 查询菜单详情 查询菜单详情 GET /system/menu/detail/${param0} */
export function systemMenuDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemMenuDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaMenuOutSchema_>(
    `/system/menu/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 查询菜单树 查询菜单树 GET /system/menu/tree */
export function systemMenuTreeUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemMenuTreeUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListMenuOutSchema_>('/system/menu/tree', {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 修改菜单 修改菜单 PUT /system/menu/update/${param0} */
export function systemMenuUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemMenuUpdateIdUsingPutParams;
  body: API.MenuUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaMenuOutSchema_>(
    `/system/menu/update/${param0}`,
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
