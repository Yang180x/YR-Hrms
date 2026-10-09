-- FastapiAdmin DDL — 2026-09-22
-- 使用方式: mysql -u root -p < fastapiadmin_ddl.sql

CREATE DATABASE IF NOT EXISTS `fastapiadmin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `fastapiadmin`;

DROP TABLE IF EXISTS sys_user_positions;
DROP TABLE IF EXISTS gen_table_column;
DROP TABLE IF EXISTS task_node;
DROP TABLE IF EXISTS sys_user_roles;
DROP TABLE IF EXISTS sys_position;
DROP TABLE IF EXISTS sys_notice;
DROP TABLE IF EXISTS sys_log;
DROP TABLE IF EXISTS storage_workflow;
DROP TABLE IF EXISTS storage_transfer;
DROP TABLE IF EXISTS storage_node;
DROP TABLE IF EXISTS gen_table;
DROP TABLE IF EXISTS gen_demo01;
DROP TABLE IF EXISTS gen_demo;
DROP TABLE IF EXISTS app_portal;
DROP TABLE IF EXISTS sys_ticket_comment;
DROP TABLE IF EXISTS sys_ticket;
DROP TABLE IF EXISTS sys_version;
DROP TABLE IF EXISTS sys_user;
DROP TABLE IF EXISTS sys_role_menus;
DROP TABLE IF EXISTS sys_role_depts;
DROP TABLE IF EXISTS sys_dict_data;
DROP TABLE IF EXISTS ai_model;
DROP TABLE IF EXISTS task_job;
DROP TABLE IF EXISTS sys_tenant;
DROP TABLE IF EXISTS sys_role;
DROP TABLE IF EXISTS sys_param;
DROP TABLE IF EXISTS sys_menu;
DROP TABLE IF EXISTS sys_dict_type;
DROP TABLE IF EXISTS sys_dept;
DROP TABLE IF EXISTS ai_provider;

CREATE TABLE ai_provider (
	name VARCHAR(64) NOT NULL COMMENT '供应商名称（如 mimo-tp / DeepSeek）', 
	vendor VARCHAR(32) NOT NULL COMMENT '厂商类型(openai/anthropic/google/ollama/deepseek/customendpoint等)', 
	api_type VARCHAR(32) NOT NULL COMMENT 'API协议类型(chat-completions/messages/ollama/gemini等)', 
	api_key VARCHAR(255) COMMENT '供应商API密钥（模型级可覆盖）', 
	base_url VARCHAR(255) COMMENT '供应商默认API地址（模型可覆盖）', 
	is_default BOOL COMMENT '是否为默认供应商', 
	sort_order INTEGER COMMENT '排序号（越大越靠前）', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id)
)COMMENT='AI供应商表';
CREATE INDEX ix_ai_provider_created_time ON ai_provider (created_time);
CREATE INDEX ix_ai_provider_deleted_time ON ai_provider (deleted_time);
CREATE INDEX ix_ai_provider_id ON ai_provider (id);
CREATE INDEX ix_ai_provider_is_deleted ON ai_provider (is_deleted);
CREATE INDEX ix_ai_provider_status ON ai_provider (status);
CREATE INDEX ix_ai_provider_updated_time ON ai_provider (updated_time);
CREATE UNIQUE INDEX ix_ai_provider_uuid ON ai_provider (uuid);

CREATE TABLE sys_dept (
	name VARCHAR(64) NOT NULL COMMENT '部门名称', 
	`order` INTEGER NOT NULL COMMENT '显示排序', 
	code VARCHAR(16) NOT NULL COMMENT '部门编码', 
	leader VARCHAR(32) COMMENT '部门负责人', 
	phone VARCHAR(11) COMMENT '手机', 
	email VARCHAR(64) COMMENT '邮箱', 
	parent_id INTEGER COMMENT '父级部门ID', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	UNIQUE (code), 
	FOREIGN KEY(parent_id) REFERENCES sys_dept (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='部门表';
CREATE INDEX ix_sys_dept_created_time ON sys_dept (created_time);
CREATE INDEX ix_sys_dept_deleted_time ON sys_dept (deleted_time);
CREATE INDEX ix_sys_dept_id ON sys_dept (id);
CREATE INDEX ix_sys_dept_is_deleted ON sys_dept (is_deleted);
CREATE INDEX ix_sys_dept_parent_id ON sys_dept (parent_id);
CREATE INDEX ix_sys_dept_status ON sys_dept (status);
CREATE INDEX ix_sys_dept_updated_time ON sys_dept (updated_time);
CREATE UNIQUE INDEX ix_sys_dept_uuid ON sys_dept (uuid);

CREATE TABLE sys_dict_type (
	dict_name VARCHAR(64) NOT NULL COMMENT '字典名称', 
	dict_type VARCHAR(255) NOT NULL COMMENT '字典类型', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	UNIQUE (dict_type)
)COMMENT='字典类型表';
CREATE INDEX ix_sys_dict_type_created_time ON sys_dict_type (created_time);
CREATE INDEX ix_sys_dict_type_deleted_time ON sys_dict_type (deleted_time);
CREATE INDEX ix_sys_dict_type_id ON sys_dict_type (id);
CREATE INDEX ix_sys_dict_type_is_deleted ON sys_dict_type (is_deleted);
CREATE INDEX ix_sys_dict_type_status ON sys_dict_type (status);
CREATE INDEX ix_sys_dict_type_updated_time ON sys_dict_type (updated_time);
CREATE UNIQUE INDEX ix_sys_dict_type_uuid ON sys_dict_type (uuid);

CREATE TABLE sys_menu (
	name VARCHAR(50) NOT NULL COMMENT '菜单名称', 
	type INTEGER NOT NULL COMMENT '菜单类型(1:目录 2:菜单 3:按钮/权限 4:链接)', 
	`order` INTEGER NOT NULL COMMENT '显示排序', 
	permission VARCHAR(100) COMMENT '权限标识(如:module_system:user:query)', 
	icon VARCHAR(50) COMMENT '菜单图标', 
	route_name VARCHAR(100) COMMENT '路由名称', 
	route_path VARCHAR(200) COMMENT '路由路径', 
	component_path VARCHAR(200) COMMENT '组件路径', 
	redirect VARCHAR(200) COMMENT '重定向地址', 
	hidden BOOL NOT NULL COMMENT '是否隐藏(True:隐藏 False:显示)', 
	keep_alive BOOL NOT NULL COMMENT '是否缓存(True:是 False:否)', 
	always_show BOOL NOT NULL COMMENT '是否始终显示(True:是 False:否)', 
	title VARCHAR(50) COMMENT '菜单标题', 
	params JSON COMMENT '路由参数(JSON对象)', 
	affix BOOL NOT NULL COMMENT '是否固定标签页(True:是 False:否)', 
	client VARCHAR(20) NOT NULL COMMENT '终端(pc:管理端桌面 app:移动端)' DEFAULT 'pc', 
	parent_id INTEGER COMMENT '父菜单ID', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	FOREIGN KEY(parent_id) REFERENCES sys_menu (id) ON DELETE SET NULL
)COMMENT='菜单表';
CREATE INDEX ix_sys_menu_created_time ON sys_menu (created_time);
CREATE INDEX ix_sys_menu_deleted_time ON sys_menu (deleted_time);
CREATE INDEX ix_sys_menu_id ON sys_menu (id);
CREATE INDEX ix_sys_menu_is_deleted ON sys_menu (is_deleted);
CREATE INDEX ix_sys_menu_parent_id ON sys_menu (parent_id);
CREATE INDEX ix_sys_menu_status ON sys_menu (status);
CREATE INDEX ix_sys_menu_updated_time ON sys_menu (updated_time);
CREATE UNIQUE INDEX ix_sys_menu_uuid ON sys_menu (uuid);

CREATE TABLE sys_param (
	config_name VARCHAR(64) NOT NULL COMMENT '参数名称', 
	config_key VARCHAR(500) NOT NULL COMMENT '参数键名', 
	config_value VARCHAR(500) COMMENT '参数键值', 
	config_type BOOL COMMENT '系统内置(True:是 False:否)', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id)
)COMMENT='系统参数表';
CREATE INDEX ix_sys_param_created_time ON sys_param (created_time);
CREATE INDEX ix_sys_param_deleted_time ON sys_param (deleted_time);
CREATE INDEX ix_sys_param_id ON sys_param (id);
CREATE INDEX ix_sys_param_is_deleted ON sys_param (is_deleted);
CREATE INDEX ix_sys_param_status ON sys_param (status);
CREATE INDEX ix_sys_param_updated_time ON sys_param (updated_time);
CREATE UNIQUE INDEX ix_sys_param_uuid ON sys_param (uuid);

CREATE TABLE sys_role (
	name VARCHAR(64) NOT NULL COMMENT '角色名称', 
	code VARCHAR(16) NOT NULL COMMENT '角色编码', 
	`order` INTEGER NOT NULL COMMENT '显示排序', 
	data_scope INTEGER NOT NULL COMMENT '数据权限范围(1:仅本人 2:本部门 3:本部门及以下 4:全部 5:自定义)', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	UNIQUE (code)
)COMMENT='角色表';
CREATE INDEX ix_sys_role_created_time ON sys_role (created_time);
CREATE INDEX ix_sys_role_deleted_time ON sys_role (deleted_time);
CREATE INDEX ix_sys_role_id ON sys_role (id);
CREATE INDEX ix_sys_role_is_deleted ON sys_role (is_deleted);
CREATE INDEX ix_sys_role_status ON sys_role (status);
CREATE INDEX ix_sys_role_updated_time ON sys_role (updated_time);
CREATE UNIQUE INDEX ix_sys_role_uuid ON sys_role (uuid);

CREATE TABLE sys_tenant (
	name VARCHAR(100) NOT NULL COMMENT '租户名称', 
	code VARCHAR(100) NOT NULL COMMENT '租户编码', 
	start_time DATETIME COMMENT '开始时间', 
	end_time DATETIME COMMENT '结束时间', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	UNIQUE (name), 
	UNIQUE (code)
)COMMENT='租户表';
CREATE INDEX ix_sys_tenant_created_time ON sys_tenant (created_time);
CREATE INDEX ix_sys_tenant_deleted_time ON sys_tenant (deleted_time);
CREATE INDEX ix_sys_tenant_id ON sys_tenant (id);
CREATE INDEX ix_sys_tenant_is_deleted ON sys_tenant (is_deleted);
CREATE INDEX ix_sys_tenant_status ON sys_tenant (status);
CREATE INDEX ix_sys_tenant_updated_time ON sys_tenant (updated_time);
CREATE UNIQUE INDEX ix_sys_tenant_uuid ON sys_tenant (uuid);

CREATE TABLE task_job (
	job_id VARCHAR(64) NOT NULL COMMENT '任务ID', 
	job_name VARCHAR(128) COMMENT '任务名称', 
	trigger_type VARCHAR(32) COMMENT '触发方式: cron/interval/date/manual', 
	status VARCHAR(16) NOT NULL COMMENT '执行状态', 
	next_run_time VARCHAR(64) COMMENT '下次执行时间', 
	job_state TEXT COMMENT '任务状态信息', 
	result TEXT COMMENT '执行结果', 
	error TEXT COMMENT '错误信息', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id)
)COMMENT='任务执行日志表';
CREATE INDEX ix_task_job_created_time ON task_job (created_time);
CREATE INDEX ix_task_job_deleted_time ON task_job (deleted_time);
CREATE INDEX ix_task_job_id ON task_job (id);
CREATE INDEX ix_task_job_is_deleted ON task_job (is_deleted);
CREATE INDEX ix_task_job_job_id ON task_job (job_id);
CREATE INDEX ix_task_job_updated_time ON task_job (updated_time);
CREATE UNIQUE INDEX ix_task_job_uuid ON task_job (uuid);

CREATE TABLE ai_model (
	provider_id INTEGER NOT NULL COMMENT '所属供应商ID', 
	model_key VARCHAR(128) NOT NULL COMMENT '模型id（如 mimo-v2.5）', 
	name VARCHAR(128) NOT NULL COMMENT '模型显示名（如 mimo-v2.5-tp）', 
	url VARCHAR(255) COMMENT '模型端点地址（覆盖供应商默认，可空）', 
	tool_calling BOOL COMMENT '是否支持工具调用', 
	vision BOOL COMMENT '是否支持视觉/图片输入', 
	max_input_tokens INTEGER COMMENT '最大输入token数', 
	max_output_tokens INTEGER COMMENT '最大输出token数', 
	thinking BOOL COMMENT '是否启用思考模式（推理模型）', 
	temperature FLOAT COMMENT '温度（默认0.7）', 
	is_default BOOL COMMENT '是否为默认模型', 
	sort_order INTEGER COMMENT '排序号（越大越靠前）', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	FOREIGN KEY(provider_id) REFERENCES ai_provider (id) ON DELETE CASCADE
)COMMENT='AI模型表';
CREATE INDEX ix_ai_model_created_time ON ai_model (created_time);
CREATE INDEX ix_ai_model_deleted_time ON ai_model (deleted_time);
CREATE INDEX ix_ai_model_id ON ai_model (id);
CREATE INDEX ix_ai_model_is_deleted ON ai_model (is_deleted);
CREATE INDEX ix_ai_model_provider_id ON ai_model (provider_id);
CREATE INDEX ix_ai_model_status ON ai_model (status);
CREATE INDEX ix_ai_model_updated_time ON ai_model (updated_time);
CREATE UNIQUE INDEX ix_ai_model_uuid ON ai_model (uuid);

CREATE TABLE sys_dict_data (
	dict_sort INTEGER NOT NULL COMMENT '字典排序', 
	dict_label VARCHAR(255) NOT NULL COMMENT '字典标签', 
	dict_value VARCHAR(255) NOT NULL COMMENT '字典键值', 
	css_class VARCHAR(255) COMMENT '样式属性（其他样式扩展）', 
	list_class VARCHAR(255) COMMENT '表格回显样式', 
	is_default BOOL NOT NULL COMMENT '是否默认（True是 False否）', 
	dict_type VARCHAR(255) NOT NULL COMMENT '字典类型', 
	dict_type_id INTEGER NOT NULL COMMENT '字典类型ID', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	PRIMARY KEY (id), 
	FOREIGN KEY(dict_type_id) REFERENCES sys_dict_type (id) ON DELETE CASCADE
)COMMENT='字典数据表';
CREATE INDEX ix_sys_dict_data_created_time ON sys_dict_data (created_time);
CREATE INDEX ix_sys_dict_data_deleted_time ON sys_dict_data (deleted_time);
CREATE INDEX ix_sys_dict_data_id ON sys_dict_data (id);
CREATE INDEX ix_sys_dict_data_is_deleted ON sys_dict_data (is_deleted);
CREATE INDEX ix_sys_dict_data_status ON sys_dict_data (status);
CREATE INDEX ix_sys_dict_data_updated_time ON sys_dict_data (updated_time);
CREATE UNIQUE INDEX ix_sys_dict_data_uuid ON sys_dict_data (uuid);

CREATE TABLE sys_role_depts (
	role_id INTEGER NOT NULL COMMENT '角色ID', 
	dept_id INTEGER NOT NULL COMMENT '部门ID', 
	PRIMARY KEY (role_id, dept_id), 
	FOREIGN KEY(role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(dept_id) REFERENCES sys_dept (id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT='角色部门关联表';

CREATE TABLE sys_role_menus (
	role_id INTEGER NOT NULL COMMENT '角色ID', 
	menu_id INTEGER NOT NULL COMMENT '菜单ID', 
	PRIMARY KEY (role_id, menu_id), 
	FOREIGN KEY(role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(menu_id) REFERENCES sys_menu (id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT='角色菜单关联表';

CREATE TABLE sys_user (
	username VARCHAR(64) NOT NULL COMMENT '用户名/登录账号', 
	password VARCHAR(255) NOT NULL COMMENT '密码哈希', 
	name VARCHAR(32) NOT NULL COMMENT '昵称', 
	mobile VARCHAR(11) COMMENT '手机号', 
	email VARCHAR(64) COMMENT '邮箱', 
	gender VARCHAR(1) COMMENT '性别(0:男 1:女 2:未知)', 
	avatar VARCHAR(255) COMMENT '头像URL地址', 
	is_superuser BOOL NOT NULL COMMENT '是否超管', 
	last_login DATETIME COMMENT '最后登录时间', 
	id_card VARCHAR(255) COMMENT '身份证号(SM4加密)', 
	gitee_login VARCHAR(32) COMMENT 'Gitee登录', 
	github_login VARCHAR(32) COMMENT 'Github登录', 
	wx_login VARCHAR(32) COMMENT '微信登录', 
	qq_login VARCHAR(32) COMMENT 'QQ登录', 
	dept_id INTEGER COMMENT '部门ID', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	tenant_id INTEGER NOT NULL COMMENT '租户ID', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	UNIQUE (username), 
	UNIQUE (mobile), 
	UNIQUE (email), 
	FOREIGN KEY(dept_id) REFERENCES sys_dept (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(tenant_id) REFERENCES sys_tenant (id) ON DELETE RESTRICT ON UPDATE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='用户表';
CREATE INDEX ix_sys_user_created_id ON sys_user (created_id);
CREATE INDEX ix_sys_user_created_time ON sys_user (created_time);
CREATE INDEX ix_sys_user_deleted_id ON sys_user (deleted_id);
CREATE INDEX ix_sys_user_deleted_time ON sys_user (deleted_time);
CREATE INDEX ix_sys_user_dept_id ON sys_user (dept_id);
CREATE INDEX ix_sys_user_id ON sys_user (id);
CREATE INDEX ix_sys_user_is_deleted ON sys_user (is_deleted);
CREATE INDEX ix_sys_user_status ON sys_user (status);
CREATE INDEX ix_sys_user_tenant_id ON sys_user (tenant_id);
CREATE INDEX ix_sys_user_updated_id ON sys_user (updated_id);
CREATE INDEX ix_sys_user_updated_time ON sys_user (updated_time);
CREATE UNIQUE INDEX ix_sys_user_uuid ON sys_user (uuid);

CREATE TABLE app_portal (
	name VARCHAR(64) NOT NULL COMMENT '应用名称', 
	access_url VARCHAR(500) NOT NULL COMMENT '访问地址', 
	icon_url VARCHAR(300) COMMENT '应用图标URL', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	tenant_id INTEGER NOT NULL COMMENT '租户ID', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(tenant_id) REFERENCES sys_tenant (id) ON DELETE RESTRICT ON UPDATE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='门户应用';
CREATE INDEX ix_app_portal_created_id ON app_portal (created_id);
CREATE INDEX ix_app_portal_created_time ON app_portal (created_time);
CREATE INDEX ix_app_portal_deleted_id ON app_portal (deleted_id);
CREATE INDEX ix_app_portal_deleted_time ON app_portal (deleted_time);
CREATE INDEX ix_app_portal_id ON app_portal (id);
CREATE INDEX ix_app_portal_is_deleted ON app_portal (is_deleted);
CREATE INDEX ix_app_portal_status ON app_portal (status);
CREATE INDEX ix_app_portal_tenant_id ON app_portal (tenant_id);
CREATE INDEX ix_app_portal_updated_id ON app_portal (updated_id);
CREATE INDEX ix_app_portal_updated_time ON app_portal (updated_time);
CREATE UNIQUE INDEX ix_app_portal_uuid ON app_portal (uuid);

CREATE TABLE gen_demo (
	name VARCHAR(64) NOT NULL COMMENT '名称', 
	a INTEGER COMMENT '整数', 
	b BIGINT COMMENT '大整数', 
	c FLOAT COMMENT '浮点数', 
	d BOOL NOT NULL COMMENT '布尔型', 
	e DATE COMMENT '日期', 
	f TIME COMMENT '时间', 
	g DATETIME COMMENT '日期时间', 
	h TEXT COMMENT '长文本', 
	i JSON COMMENT '元数据(JSON格式)', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='示例表';
CREATE INDEX ix_gen_demo_created_id ON gen_demo (created_id);
CREATE INDEX ix_gen_demo_created_time ON gen_demo (created_time);
CREATE INDEX ix_gen_demo_deleted_id ON gen_demo (deleted_id);
CREATE INDEX ix_gen_demo_deleted_time ON gen_demo (deleted_time);
CREATE INDEX ix_gen_demo_id ON gen_demo (id);
CREATE INDEX ix_gen_demo_is_deleted ON gen_demo (is_deleted);
CREATE INDEX ix_gen_demo_status ON gen_demo (status);
CREATE INDEX ix_gen_demo_updated_id ON gen_demo (updated_id);
CREATE INDEX ix_gen_demo_updated_time ON gen_demo (updated_time);
CREATE UNIQUE INDEX ix_gen_demo_uuid ON gen_demo (uuid);

CREATE TABLE gen_demo01 (
	name VARCHAR(64) NOT NULL COMMENT '名称', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='示例1表';
CREATE INDEX ix_gen_demo01_created_id ON gen_demo01 (created_id);
CREATE INDEX ix_gen_demo01_created_time ON gen_demo01 (created_time);
CREATE INDEX ix_gen_demo01_deleted_id ON gen_demo01 (deleted_id);
CREATE INDEX ix_gen_demo01_deleted_time ON gen_demo01 (deleted_time);
CREATE INDEX ix_gen_demo01_id ON gen_demo01 (id);
CREATE INDEX ix_gen_demo01_is_deleted ON gen_demo01 (is_deleted);
CREATE INDEX ix_gen_demo01_status ON gen_demo01 (status);
CREATE INDEX ix_gen_demo01_updated_id ON gen_demo01 (updated_id);
CREATE INDEX ix_gen_demo01_updated_time ON gen_demo01 (updated_time);
CREATE UNIQUE INDEX ix_gen_demo01_uuid ON gen_demo01 (uuid);

CREATE TABLE gen_table (
	table_name VARCHAR(200) NOT NULL COMMENT '表名称', 
	table_comment VARCHAR(500) COMMENT '表描述', 
	class_name VARCHAR(100) NOT NULL COMMENT '实体类名称', 
	package_name VARCHAR(100) COMMENT '生成包路径', 
	module_name VARCHAR(30) COMMENT '生成模块名', 
	business_name VARCHAR(30) COMMENT '生成业务名', 
	function_name VARCHAR(100) COMMENT '生成功能名', 
	sub_table_name VARCHAR(64) COMMENT '关联子表的表名', 
	sub_table_fk_name VARCHAR(64) COMMENT '子表关联的外键名', 
	parent_menu_id INTEGER COMMENT '父菜单ID', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='代码生成表';
CREATE INDEX ix_gen_table_created_id ON gen_table (created_id);
CREATE INDEX ix_gen_table_created_time ON gen_table (created_time);
CREATE INDEX ix_gen_table_deleted_id ON gen_table (deleted_id);
CREATE INDEX ix_gen_table_deleted_time ON gen_table (deleted_time);
CREATE INDEX ix_gen_table_id ON gen_table (id);
CREATE INDEX ix_gen_table_is_deleted ON gen_table (is_deleted);
CREATE INDEX ix_gen_table_status ON gen_table (status);
CREATE INDEX ix_gen_table_updated_id ON gen_table (updated_id);
CREATE INDEX ix_gen_table_updated_time ON gen_table (updated_time);
CREATE UNIQUE INDEX ix_gen_table_uuid ON gen_table (uuid);

CREATE TABLE storage_node (
	name VARCHAR(100) NOT NULL COMMENT '节点名称', 
	type VARCHAR(50) NOT NULL COMMENT '存储类型: local/s3/ftp/sftp', 
	config TEXT COMMENT '连接配置 JSON', 
	description VARCHAR(500) COMMENT '描述', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='存储节点表';
CREATE INDEX ix_storage_node_created_id ON storage_node (created_id);
CREATE INDEX ix_storage_node_created_time ON storage_node (created_time);
CREATE INDEX ix_storage_node_deleted_id ON storage_node (deleted_id);
CREATE INDEX ix_storage_node_deleted_time ON storage_node (deleted_time);
CREATE INDEX ix_storage_node_id ON storage_node (id);
CREATE INDEX ix_storage_node_is_deleted ON storage_node (is_deleted);
CREATE INDEX ix_storage_node_status ON storage_node (status);
CREATE INDEX ix_storage_node_updated_id ON storage_node (updated_id);
CREATE INDEX ix_storage_node_updated_time ON storage_node (updated_time);
CREATE UNIQUE INDEX ix_storage_node_uuid ON storage_node (uuid);

CREATE TABLE storage_transfer (
	name VARCHAR(100) NOT NULL COMMENT '任务名称', 
	source_id INTEGER NOT NULL COMMENT '源存储节点ID', 
	target_id INTEGER NOT NULL COMMENT '目标存储节点ID', 
	source_path VARCHAR(500) COMMENT '源路径', 
	target_path VARCHAR(500) COMMENT '目标路径', 
	transfer_status INTEGER NOT NULL COMMENT '传输状态: 0待执行 1执行中 2成功 3失败', 
	progress INTEGER NOT NULL COMMENT '进度百分比', 
	error_msg TEXT COMMENT '错误信息', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='传输任务表';
CREATE INDEX ix_storage_transfer_created_id ON storage_transfer (created_id);
CREATE INDEX ix_storage_transfer_created_time ON storage_transfer (created_time);
CREATE INDEX ix_storage_transfer_deleted_id ON storage_transfer (deleted_id);
CREATE INDEX ix_storage_transfer_deleted_time ON storage_transfer (deleted_time);
CREATE INDEX ix_storage_transfer_id ON storage_transfer (id);
CREATE INDEX ix_storage_transfer_is_deleted ON storage_transfer (is_deleted);
CREATE INDEX ix_storage_transfer_status ON storage_transfer (status);
CREATE INDEX ix_storage_transfer_updated_id ON storage_transfer (updated_id);
CREATE INDEX ix_storage_transfer_updated_time ON storage_transfer (updated_time);
CREATE UNIQUE INDEX ix_storage_transfer_uuid ON storage_transfer (uuid);

CREATE TABLE storage_workflow (
	name VARCHAR(100) NOT NULL COMMENT '工作流名称', 
	code VARCHAR(50) NOT NULL COMMENT '工作流编码', 
	nodes_json TEXT COMMENT '节点配置 JSON', 
	edges_json TEXT COMMENT '连线配置 JSON', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	CONSTRAINT uq_storage_workflow_code UNIQUE (code), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='存储工作流表';
CREATE INDEX ix_storage_workflow_created_id ON storage_workflow (created_id);
CREATE INDEX ix_storage_workflow_created_time ON storage_workflow (created_time);
CREATE INDEX ix_storage_workflow_deleted_id ON storage_workflow (deleted_id);
CREATE INDEX ix_storage_workflow_deleted_time ON storage_workflow (deleted_time);
CREATE INDEX ix_storage_workflow_id ON storage_workflow (id);
CREATE INDEX ix_storage_workflow_is_deleted ON storage_workflow (is_deleted);
CREATE INDEX ix_storage_workflow_status ON storage_workflow (status);
CREATE INDEX ix_storage_workflow_updated_id ON storage_workflow (updated_id);
CREATE INDEX ix_storage_workflow_updated_time ON storage_workflow (updated_time);
CREATE UNIQUE INDEX ix_storage_workflow_uuid ON storage_workflow (uuid);

CREATE TABLE sys_log (
	type INTEGER NOT NULL COMMENT '日志类型(1登录日志 2操作日志)', 
	request_path VARCHAR(255) NOT NULL COMMENT '请求路径', 
	request_method VARCHAR(10) NOT NULL COMMENT '请求方式', 
	request_payload LONGTEXT COMMENT '请求体', 
	request_ip VARCHAR(50) COMMENT '请求IP地址', 
	login_location VARCHAR(255) COMMENT '登录位置', 
	request_os VARCHAR(64) COMMENT '操作系统', 
	request_browser VARCHAR(64) COMMENT '浏览器', 
	response_code INTEGER NOT NULL COMMENT '响应状态码', 
	response_json LONGTEXT COMMENT '响应体', 
	process_time VARCHAR(20) COMMENT '处理时间', 
	username VARCHAR(64) COMMENT '操作人账号（冗余）', 
	mobile VARCHAR(11) COMMENT '操作人手机号（冗余）', 
	login_platform VARCHAR(32) COMMENT '登录平台(PC/FLUTTER/UNIAPP)', 
	signature VARCHAR(256) COMMENT 'SM2签名值（国密完整性保护）', 
	signed_fields VARCHAR(512) COMMENT '被签名字段标识（JSON格式）', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='系统日志表';
CREATE INDEX ix_sys_log_created_id ON sys_log (created_id);
CREATE INDEX ix_sys_log_created_time ON sys_log (created_time);
CREATE INDEX ix_sys_log_deleted_id ON sys_log (deleted_id);
CREATE INDEX ix_sys_log_deleted_time ON sys_log (deleted_time);
CREATE INDEX ix_sys_log_id ON sys_log (id);
CREATE INDEX ix_sys_log_is_deleted ON sys_log (is_deleted);
CREATE INDEX ix_sys_log_status ON sys_log (status);
CREATE INDEX ix_sys_log_updated_id ON sys_log (updated_id);
CREATE INDEX ix_sys_log_updated_time ON sys_log (updated_time);
CREATE UNIQUE INDEX ix_sys_log_uuid ON sys_log (uuid);

CREATE TABLE sys_notice (
	notice_title VARCHAR(64) NOT NULL COMMENT '公告标题', 
	notice_type VARCHAR(1) NOT NULL COMMENT '公告类型(1通知 2公告)', 
	notice_content TEXT COMMENT '公告内容', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='通知公告表';
CREATE INDEX ix_sys_notice_created_id ON sys_notice (created_id);
CREATE INDEX ix_sys_notice_created_time ON sys_notice (created_time);
CREATE INDEX ix_sys_notice_deleted_id ON sys_notice (deleted_id);
CREATE INDEX ix_sys_notice_deleted_time ON sys_notice (deleted_time);
CREATE INDEX ix_sys_notice_id ON sys_notice (id);
CREATE INDEX ix_sys_notice_is_deleted ON sys_notice (is_deleted);
CREATE INDEX ix_sys_notice_status ON sys_notice (status);
CREATE INDEX ix_sys_notice_updated_id ON sys_notice (updated_id);
CREATE INDEX ix_sys_notice_updated_time ON sys_notice (updated_time);
CREATE UNIQUE INDEX ix_sys_notice_uuid ON sys_notice (uuid);

CREATE TABLE sys_position (
	name VARCHAR(64) NOT NULL COMMENT '岗位名称', 
	`order` INTEGER NOT NULL COMMENT '显示排序', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='岗位表';
CREATE INDEX ix_sys_position_created_id ON sys_position (created_id);
CREATE INDEX ix_sys_position_created_time ON sys_position (created_time);
CREATE INDEX ix_sys_position_deleted_id ON sys_position (deleted_id);
CREATE INDEX ix_sys_position_deleted_time ON sys_position (deleted_time);
CREATE INDEX ix_sys_position_id ON sys_position (id);
CREATE INDEX ix_sys_position_is_deleted ON sys_position (is_deleted);
CREATE INDEX ix_sys_position_status ON sys_position (status);
CREATE INDEX ix_sys_position_updated_id ON sys_position (updated_id);
CREATE INDEX ix_sys_position_updated_time ON sys_position (updated_time);
CREATE UNIQUE INDEX ix_sys_position_uuid ON sys_position (uuid);

CREATE TABLE sys_user_roles (
	user_id INTEGER NOT NULL COMMENT '用户ID', 
	role_id INTEGER NOT NULL COMMENT '角色ID', 
	PRIMARY KEY (user_id, role_id), 
	FOREIGN KEY(user_id) REFERENCES sys_user (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT='用户角色关联表';

CREATE TABLE task_node (
	name VARCHAR(64) NOT NULL COMMENT '节点名称', 
	code VARCHAR(32) NOT NULL COMMENT '节点编码', 
	jobstore VARCHAR(64) COMMENT '存储器', 
	executor VARCHAR(64) COMMENT '执行器', 
	`trigger` VARCHAR(64) COMMENT '触发器', 
	trigger_args TEXT COMMENT '触发器参数', 
	func TEXT COMMENT '代码块', 
	args TEXT COMMENT '位置参数', 
	kwargs TEXT COMMENT '关键字参数', 
	coalesce BOOL COMMENT '是否合并运行', 
	max_instances INTEGER COMMENT '最大实例数', 
	start_date VARCHAR(64) COMMENT '开始时间', 
	end_date VARCHAR(64) COMMENT '结束时间', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	UNIQUE (code), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='节点类型表';
CREATE INDEX ix_task_node_created_id ON task_node (created_id);
CREATE INDEX ix_task_node_created_time ON task_node (created_time);
CREATE INDEX ix_task_node_deleted_id ON task_node (deleted_id);
CREATE INDEX ix_task_node_deleted_time ON task_node (deleted_time);
CREATE INDEX ix_task_node_id ON task_node (id);
CREATE INDEX ix_task_node_is_deleted ON task_node (is_deleted);
CREATE INDEX ix_task_node_status ON task_node (status);
CREATE INDEX ix_task_node_updated_id ON task_node (updated_id);
CREATE INDEX ix_task_node_updated_time ON task_node (updated_time);
CREATE UNIQUE INDEX ix_task_node_uuid ON task_node (uuid);

CREATE TABLE gen_table_column (
	column_name VARCHAR(200) NOT NULL COMMENT '列名称', 
	column_comment VARCHAR(500) COMMENT '列描述', 
	column_type VARCHAR(100) NOT NULL COMMENT '列类型', 
	column_length VARCHAR(50) COMMENT '列长度', 
	column_default VARCHAR(200) COMMENT '列默认值', 
	is_pk BOOL NOT NULL COMMENT '是否主键' DEFAULT false, 
	is_increment BOOL NOT NULL COMMENT '是否自增' DEFAULT false, 
	is_nullable BOOL NOT NULL COMMENT '是否允许为空' DEFAULT true, 
	is_unique BOOL NOT NULL COMMENT '是否唯一' DEFAULT false, 
	python_type VARCHAR(100) COMMENT 'Python类型', 
	python_field VARCHAR(200) COMMENT 'Python字段名', 
	is_insert BOOL NOT NULL COMMENT '是否为新增字段' DEFAULT true, 
	is_edit BOOL NOT NULL COMMENT '是否编辑字段' DEFAULT true, 
	is_list BOOL NOT NULL COMMENT '是否列表字段' DEFAULT true, 
	is_query BOOL NOT NULL COMMENT '是否查询字段' DEFAULT false, 
	query_type VARCHAR(50) COMMENT '查询方式', 
	html_type VARCHAR(100) COMMENT '显示类型', 
	dict_type VARCHAR(200) COMMENT '字典类型', 
	sort INTEGER NOT NULL COMMENT '排序', 
	table_id INTEGER NOT NULL COMMENT '归属表编号', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(table_id) REFERENCES gen_table (id) ON DELETE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='代码生成表字段';
CREATE INDEX ix_gen_table_column_created_id ON gen_table_column (created_id);
CREATE INDEX ix_gen_table_column_created_time ON gen_table_column (created_time);
CREATE INDEX ix_gen_table_column_deleted_id ON gen_table_column (deleted_id);
CREATE INDEX ix_gen_table_column_deleted_time ON gen_table_column (deleted_time);
CREATE INDEX ix_gen_table_column_id ON gen_table_column (id);
CREATE INDEX ix_gen_table_column_is_deleted ON gen_table_column (is_deleted);
CREATE INDEX ix_gen_table_column_status ON gen_table_column (status);
CREATE INDEX ix_gen_table_column_table_id ON gen_table_column (table_id);
CREATE INDEX ix_gen_table_column_updated_id ON gen_table_column (updated_id);
CREATE INDEX ix_gen_table_column_updated_time ON gen_table_column (updated_time);
CREATE UNIQUE INDEX ix_gen_table_column_uuid ON gen_table_column (uuid);

CREATE TABLE sys_user_positions (
	user_id INTEGER NOT NULL COMMENT '用户ID', 
	position_id INTEGER NOT NULL COMMENT '岗位ID', 
	PRIMARY KEY (user_id, position_id), 
	FOREIGN KEY(user_id) REFERENCES sys_user (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(position_id) REFERENCES sys_position (id) ON DELETE CASCADE ON UPDATE CASCADE
)COMMENT='用户岗位关联表';

CREATE TABLE sys_version (
	version VARCHAR(32) NOT NULL COMMENT '版本号', 
	title VARCHAR(200) NOT NULL COMMENT '版本标题', 
	date VARCHAR(50) NOT NULL COMMENT '发布日期', 
	content TEXT COMMENT '版本富文本内容', 
	sort INTEGER NOT NULL COMMENT '排序', 
	status INTEGER NOT NULL COMMENT '状态: 0=草稿,1=已发布,2=已回滚', 
	description VARCHAR(500) COMMENT '备注', 
	require_re_login BOOL NOT NULL COMMENT '是否需要重新登录', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	UNIQUE (version), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='版本管理表';
CREATE INDEX ix_sys_version_created_id ON sys_version (created_id);
CREATE INDEX ix_sys_version_created_time ON sys_version (created_time);
CREATE INDEX ix_sys_version_deleted_id ON sys_version (deleted_id);
CREATE INDEX ix_sys_version_deleted_time ON sys_version (deleted_time);
CREATE INDEX ix_sys_version_id ON sys_version (id);
CREATE INDEX ix_sys_version_is_deleted ON sys_version (is_deleted);
CREATE INDEX ix_sys_version_updated_id ON sys_version (updated_id);
CREATE INDEX ix_sys_version_updated_time ON sys_version (updated_time);
CREATE UNIQUE INDEX ix_sys_version_uuid ON sys_version (uuid);
CREATE TABLE sys_ticket (
	title VARCHAR(200) NOT NULL COMMENT '标题', 
	status INTEGER NOT NULL COMMENT '状态(0:待处理 1:处理中 2:已完成 3:已关闭)', 
	description TEXT COMMENT '备注', 
	ticket_content TEXT COMMENT '工单内容（富文本）', 
	summary TEXT COMMENT '工单内容（纯文本摘要）', 
	ticket_type VARCHAR(20) NOT NULL COMMENT '工单类型(suggestion:建议 bug:缺陷 optimize:优化 other:其他)', 
	images TEXT COMMENT '图片URL列表(JSON数组)', 
	reply TEXT COMMENT '回复内容', 
	assigned_id INTEGER COMMENT '处理人ID', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(assigned_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='工单表';
CREATE INDEX ix_sys_ticket_assigned_id ON sys_ticket (assigned_id);
CREATE INDEX ix_sys_ticket_created_id ON sys_ticket (created_id);
CREATE INDEX ix_sys_ticket_created_time ON sys_ticket (created_time);
CREATE INDEX ix_sys_ticket_deleted_id ON sys_ticket (deleted_id);
CREATE INDEX ix_sys_ticket_deleted_time ON sys_ticket (deleted_time);
CREATE INDEX ix_sys_ticket_id ON sys_ticket (id);
CREATE INDEX ix_sys_ticket_is_deleted ON sys_ticket (is_deleted);
CREATE INDEX ix_sys_ticket_title ON sys_ticket (title);
CREATE INDEX ix_sys_ticket_updated_id ON sys_ticket (updated_id);
CREATE INDEX ix_sys_ticket_updated_time ON sys_ticket (updated_time);
CREATE UNIQUE INDEX ix_sys_ticket_uuid ON sys_ticket (uuid);
CREATE TABLE sys_ticket_comment (
	ticket_id INTEGER NOT NULL COMMENT '工单ID', 
	content TEXT NOT NULL COMMENT '评论内容（富文本）', 
	id INTEGER NOT NULL COMMENT '主键ID' AUTO_INCREMENT, 
	uuid VARCHAR(64) NOT NULL COMMENT 'UUID全局唯一标识', 
	status VARCHAR(10) NOT NULL COMMENT '状态(0:正常 1:禁用)', 
	description TEXT COMMENT '备注/描述', 
	created_time DATETIME NOT NULL COMMENT '创建时间', 
	updated_time DATETIME NOT NULL COMMENT '更新时间', 
	is_deleted BOOL NOT NULL COMMENT '是否已删除(0:未删除 1:已删除)', 
	deleted_time DATETIME COMMENT '删除时间', 
	created_id INTEGER COMMENT '创建人ID', 
	updated_id INTEGER COMMENT '更新人ID', 
	deleted_id INTEGER COMMENT '删除人ID', 
	PRIMARY KEY (id), 
	FOREIGN KEY(ticket_id) REFERENCES sys_ticket (id) ON DELETE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
)COMMENT='工单评论表';
CREATE INDEX ix_sys_ticket_comment_created_id ON sys_ticket_comment (created_id);
CREATE INDEX ix_sys_ticket_comment_created_time ON sys_ticket_comment (created_time);
CREATE INDEX ix_sys_ticket_comment_deleted_id ON sys_ticket_comment (deleted_id);
CREATE INDEX ix_sys_ticket_comment_deleted_time ON sys_ticket_comment (deleted_time);
CREATE INDEX ix_sys_ticket_comment_id ON sys_ticket_comment (id);
CREATE INDEX ix_sys_ticket_comment_is_deleted ON sys_ticket_comment (is_deleted);
CREATE INDEX ix_sys_ticket_comment_status ON sys_ticket_comment (status);
CREATE INDEX ix_sys_ticket_comment_ticket_id ON sys_ticket_comment (ticket_id);
CREATE INDEX ix_sys_ticket_comment_updated_id ON sys_ticket_comment (updated_id);
CREATE INDEX ix_sys_ticket_comment_updated_time ON sys_ticket_comment (updated_time);
CREATE UNIQUE INDEX ix_sys_ticket_comment_uuid ON sys_ticket_comment (uuid);

-- Alembic 版本表（配合 python main.py revision/upgrade 使用）
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--

-- 运行时表（非 ORM 模型）：APScheduler SQLAlchemy jobstore
-- Table structure for table `apscheduler_jobs`
--

DROP TABLE IF EXISTS `apscheduler_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apscheduler_jobs` (
  `id` varchar(191) NOT NULL,
  `next_run_time` double DEFAULT NULL,
  `job_state` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_apscheduler_jobs_next_run_time` (`next_run_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
