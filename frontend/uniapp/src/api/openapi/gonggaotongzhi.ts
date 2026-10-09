/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 获取全局启用公告 获取全局启用公告 GET /system/notice/available */
export function systemNoticeAvailableUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListNoticeOutSchema_>(
    '/system/notice/available',
    {
      method: 'GET',
      ...(options || {}),
    }
  );
}

/** 批量修改公告状态 批量修改公告状态 PATCH /system/notice/available/setting */
export function systemNoticeAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/notice/available/setting',
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

/** 创建公告 创建公告 POST /system/notice/create */
export function systemNoticeCreateUsingPost({
  body,
  options,
}: {
  body: API.NoticeCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoticeOutSchema_>('/system/notice/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 删除公告 删除公告 DELETE /system/notice/delete */
export function systemNoticeOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemNoticeOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/notice/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 获取公告详情 获取公告详情 GET /system/notice/detail/${param0} */
export function systemNoticeDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemNoticeDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaNoticeOutSchema_>(
    `/system/notice/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出公告 导出公告 POST /system/notice/export */
export function systemNoticeOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemNoticeOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/notice/export', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 查询公告 查询公告 GET /system/notice/list */
export function systemNoticeListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemNoticeListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListNoticeOutSchema_>(
    '/system/notice/list',
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

/** 修改公告 修改公告 PUT /system/notice/update/${param0} */
export function systemNoticeUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemNoticeUpdateIdUsingPutParams;
  body: API.NoticeUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaNoticeOutSchema_>(
    `/system/notice/update/${param0}`,
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
