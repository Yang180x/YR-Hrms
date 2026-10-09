/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改部门状态 批量修改部门状态 PATCH /system/dept/available/setting */
export function systemDeptAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/dept/available/setting',
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

/** 创建部门 创建部门 POST /system/dept/create */
export function systemDeptCreateUsingPost({
  body,
  options,
}: {
  body: API.DeptCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaDeptOutSchema_>('/system/dept/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 删除部门 删除部门 DELETE /system/dept/delete */
export function systemDeptOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemDeptOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/dept/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 查询部门详情 查询部门详情 GET /system/dept/detail/${param0} */
export function systemDeptDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDeptDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaDeptOutSchema_>(
    `/system/dept/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 查询部门树 查询部门树 GET /system/dept/tree */
export function systemDeptTreeUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDeptTreeUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListDeptOutSchema_>('/system/dept/tree', {
    method: 'GET',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 修改部门 修改部门 PUT /system/dept/update/${param0} */
export function systemDeptUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDeptUpdateIdUsingPutParams;
  body: API.DeptUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaDeptOutSchema_>(
    `/system/dept/update/${param0}`,
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
