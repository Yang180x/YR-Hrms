/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 删除日志 删除日志 DELETE /system/log/delete */
export function systemLogOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemLogOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/log/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 日志详情 日志详情 GET /system/log/detail/${param0} */
export function systemLogDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemLogDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaOperationLogOutSchema_>(
    `/system/log/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出日志 导出日志 POST /system/log/export */
export function systemLogOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemLogOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/log/export', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 查询日志 查询日志 GET /system/log/list */
export function systemLogListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemLogListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListOperationLogOutSchema_>(
    '/system/log/list',
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
