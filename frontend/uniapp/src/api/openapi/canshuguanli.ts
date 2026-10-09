/* eslint-disable */
// @ts-ignore
import { openapiRequest as request, type CustomRequestOptions_ } from '@/http';

import * as API from './types';

/** 创建参数 创建参数 POST /system/param/create */
export function systemParamCreateUsingPost({
  body,
  options,
}: {
  body: API.ParamsCreateSchema;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaParamsOutSchema_>('/system/param/create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 删除参数 删除参数 DELETE /system/param/delete */
export function systemParamOpenApiDeleteUsingDelete({
  body,
  options,
}: {
  body: API.SystemParamOpenApiDeleteUsingDeleteBody;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaParamsOutSchema_>('/system/param/delete', {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/json',
    },
    data: body,
    ...(options || {}),
  });
}

/** 获取参数详情 获取参数详情 GET /system/param/detail/${param0} */
export function systemParamDetailIdUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemParamDetailIdUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaParamsOutSchema_>(
    `/system/param/detail/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 导出参数 导出参数 POST /system/param/export */
export function systemParamOpenApiExportUsingPost({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemParamOpenApiExportUsingPostParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaNoneType_>('/system/param/export', {
    method: 'POST',
    params: {
      ...params,
    },
    ...(options || {}),
  });
}

/** 获取初始化缓存参数 获取初始化缓存参数 GET /system/param/info */
export function systemParamInfoUsingGet({
  options,
}: {
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListParamsOutSchema_>('/system/param/info', {
    method: 'GET',
    ...(options || {}),
  });
}

/** 根据配置键获取参数详情 根据配置键获取参数详情 GET /system/param/key/${param0} */
export function systemParamKeyConfigKeyUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemParamKeyConfigKeyUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { config_key: param0, ...queryParams } = params;

  return request<API.ResponseSchemaParamsOutSchema_>(
    `/system/param/key/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}

/** 获取参数列表 获取参数列表 GET /system/param/list */
export function systemParamListUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemParamListUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  return request<API.ResponseSchemaListParamsOutSchema_>('/system/param/list', {
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

/** 修改参数 修改参数 PUT /system/param/update/${param0} */
export function systemParamUpdateIdUsingPut({
  params,
  body,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemParamUpdateIdUsingPutParams;
  body: API.ParamsUpdateSchema;
  options?: CustomRequestOptions_;
}) {
  const { id: param0, ...queryParams } = params;

  return request<API.ResponseSchemaParamsOutSchema_>(
    `/system/param/update/${param0}`,
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

/** 上传文件 上传文件参数:- file (UploadFile): 上传的文件对象- request (Request): 请求对象返回:- JSONResponse: 包含上传文件结果的 JSON 响应 POST /system/param/upload */
export function systemParamUploadUsingPost({
  body,
  options,
}: {
  body: API.BodyUploadFileControllerSystemParamUploadPost;
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

  return request<API.ResponseSchemaNoneType_>('/system/param/upload', {
    method: 'POST',
    headers: {
      'Content-Type': 'multipart/form-data',
    },
    data: formData,
    ...(options || {}),
  });
}

/** 根据配置键获取参数值 根据配置键获取参数值 GET /system/param/value/${param0} */
export function systemParamValueConfigKeyUsingGet({
  params,
  options,
}: {
  // 叠加生成的Param类型 (非body参数openapi默认没有生成对象)
  params: API.SystemParamValueConfigKeyUsingGetParams;
  options?: CustomRequestOptions_;
}) {
  const { config_key: param0, ...queryParams } = params;

  return request<API.ResponseSchemaParamsOutSchema_>(
    `/system/param/value/${param0}`,
    {
      method: 'GET',
      params: { ...queryParams },
      ...(options || {}),
    }
  );
}
