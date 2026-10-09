/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改岗位状态 批量修改岗位状态 PATCH /system/position/available/setting */
export function systemPositionAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/position/available/setting',
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

/** 创建岗位 创建岗位 POST /system/position/create */
export function systemPositionCreateUsingPost({
  body,
  options,
}: {
  body: API.PositionCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaPositionOutSchema_>(
    '/system/position/create',
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

/** 删除岗位 删除岗位 DELETE /system/position/delete */
export function systemPositionOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemPositionOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/position/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 查询岗位详情 查询岗位详情 GET /system/position/detail/${param0} */
export function systemPositionDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemPositionDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaPositionOutSchema_>(
    `/system/position/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出岗位 导出岗位 POST /system/position/export */
export function systemPositionOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemPositionOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/position/export', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 查询岗位 查询岗位 GET /system/position/list */
export function systemPositionListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemPositionListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListPositionOutSchema_>(
    '/system/position/list',
    {
      method: 'GET',
      params: {
        // page_no has a default value: 1
        page_no: '1',
        // page_size has a default value: 10
        page_size: '10',

        ...params,
      },
      ...(options || {}),
    }
  );
}

/** 修改岗位 修改岗位 PUT /system/position/update/${param0} */
export function systemPositionUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemPositionUpdateIdUsingPutParams;
  body: API.PositionUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaPositionOutSchema_>(
    `/system/position/update/${param0}`,
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
