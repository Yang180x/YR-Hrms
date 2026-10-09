/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改租户状态 批量修改租户状态 PATCH /system/tenant/available/setting */
export function systemTenantAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<unknown>('/system/tenant/available/setting', {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 创建租户 创建租户 POST /system/tenant/create */
export function systemTenantCreateUsingPost({
  body,
  options,
}: {
  body: API.TenantCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaTenantOutSchema_>('/system/tenant/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 删除租户 删除租户 DELETE /system/tenant/delete */
export function systemTenantOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemTenantOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<unknown>('/system/tenant/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 获取租户详情 获取租户详情 GET /system/tenant/detail/${param0} */
export function systemTenantDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemTenantDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaTenantOutSchema_>(
    `/system/tenant/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 查询租户列表 查询租户列表（分页） GET /system/tenant/list */
export function systemTenantListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemTenantListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaDict_>('/system/tenant/list', {
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

/** 修改租户 修改租户 PUT /system/tenant/update/${param0} */
export function systemTenantUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemTenantUpdateIdUsingPutParams;
  body: API.TenantUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaTenantOutSchema_>(
    `/system/tenant/update/${param0}`,
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
