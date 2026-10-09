/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 批量修改字典数据状态 批量修改字典数据状态 PATCH /system/dict/data/available/setting */
export function systemDictDataAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/dict/data/available/setting',
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

/** 创建字典数据 创建字典数据 POST /system/dict/data/create */
export function systemDictDataCreateUsingPost({
  body,
  options,
}: {
  body: API.DictDataCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaDictDataOutSchema_>(
    '/system/dict/data/create',
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

/** 删除字典数据 删除字典数据 DELETE /system/dict/data/delete */
export function systemDictDataOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemDictDataOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/dict/data/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 获取字典数据详情 获取字典数据详情 GET /system/dict/data/detail/${param0} */
export function systemDictDataDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictDataDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaDictDataOutSchema_>(
    `/system/dict/data/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出字典数据 导出字典数据 POST /system/dict/data/export */
export function systemDictDataOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictDataOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/dict/data/export', {
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

/** 根据字典类型获取数据 根据字典类型获取数据 GET /system/dict/data/info/${param0} */
export function systemDictDataInfoDictTypeUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictDataInfoDictTypeUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { dict_type: param0, ...queryParams } = params;

  return request<API.ResponseSchemaListDictDataOutSchema_>(
    `/system/dict/data/info/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 查询字典数据 查询字典数据 GET /system/dict/data/list */
export function systemDictDataListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictDataListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListDictDataOutSchema_>(
    '/system/dict/data/list',
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

/** 修改字典数据 修改字典数据 PUT /system/dict/data/update/${param0} */
export function systemDictDataUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictDataUpdateIdUsingPutParams;
  body: API.DictDataUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaDictDataOutSchema_>(
    `/system/dict/data/update/${param0}`,
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

/** 批量修改字典类型状态 批量修改字典类型状态 PATCH /system/dict/type/available/setting */
export function systemDictTypeAvailableSettingUsingPatch({
  body,
  options,
}: {
  body: API.BatchSetAvailable;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>(
    '/system/dict/type/available/setting',
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

/** 创建字典类型 创建字典类型 POST /system/dict/type/create */
export function systemDictTypeCreateUsingPost({
  body,
  options,
}: {
  body: API.DictTypeCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaDictTypeOutSchema_>(
    '/system/dict/type/create',
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

/** 删除字典类型 删除字典类型 DELETE /system/dict/type/delete */
export function systemDictTypeOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemDictTypeOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/dict/type/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 获取字典类型详情 获取字典类型详情 GET /system/dict/type/detail/${param0} */
export function systemDictTypeDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictTypeDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaDictTypeOutSchema_>(
    `/system/dict/type/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出字典类型 导出字典类型 POST /system/dict/type/export */
export function systemDictTypeOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictTypeOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/dict/type/export', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 查询字典类型 查询字典类型 GET /system/dict/type/list */
export function systemDictTypeListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictTypeListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListDictTypeOutSchema_>(
    '/system/dict/type/list',
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

/** 获取全部字典类型 获取全部字典类型 GET /system/dict/type/optionselect */
export function systemDictTypeOptionselectUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListDictTypeOutSchema_>(
    '/system/dict/type/optionselect',
    {
      method: 'GET',
      ...(options || {}),
    }
  );
}

/** 修改字典类型 修改字典类型 PUT /system/dict/type/update/${param0} */
export function systemDictTypeUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemDictTypeUpdateIdUsingPutParams;
  body: API.DictTypeUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaDictTypeOutSchema_>(
    `/system/dict/type/update/${param0}`,
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
