-- FastapiAdmin DDL — PostgreSQL
-- 用法: psql -U postgres -f fastapiadmin_ddl.sql

-- CREATE DATABASE fastapiadmin WITH ENCODING 'UTF8';
\c fastapiadmin

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
	name VARCHAR(64) NOT NULL, 
	vendor VARCHAR(32) NOT NULL, 
	api_type VARCHAR(32) NOT NULL, 
	api_key VARCHAR(255), 
	base_url VARCHAR(255), 
	is_default BOOLEAN, 
	sort_order INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id)
);
CREATE INDEX ix_ai_provider_created_time ON ai_provider (created_time);
CREATE INDEX ix_ai_provider_deleted_time ON ai_provider (deleted_time);
CREATE INDEX ix_ai_provider_id ON ai_provider (id);
CREATE INDEX ix_ai_provider_is_deleted ON ai_provider (is_deleted);
CREATE INDEX ix_ai_provider_status ON ai_provider (status);
CREATE INDEX ix_ai_provider_updated_time ON ai_provider (updated_time);
CREATE UNIQUE INDEX ix_ai_provider_uuid ON ai_provider (uuid);

CREATE TABLE sys_dept (
	name VARCHAR(64) NOT NULL, 
	"order" INTEGER NOT NULL, 
	code VARCHAR(16) NOT NULL, 
	leader VARCHAR(32), 
	phone VARCHAR(11), 
	email VARCHAR(64), 
	parent_id INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	UNIQUE (code), 
	FOREIGN KEY(parent_id) REFERENCES sys_dept (id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX ix_sys_dept_created_time ON sys_dept (created_time);
CREATE INDEX ix_sys_dept_deleted_time ON sys_dept (deleted_time);
CREATE INDEX ix_sys_dept_id ON sys_dept (id);
CREATE INDEX ix_sys_dept_is_deleted ON sys_dept (is_deleted);
CREATE INDEX ix_sys_dept_parent_id ON sys_dept (parent_id);
CREATE INDEX ix_sys_dept_status ON sys_dept (status);
CREATE INDEX ix_sys_dept_updated_time ON sys_dept (updated_time);
CREATE UNIQUE INDEX ix_sys_dept_uuid ON sys_dept (uuid);

CREATE TABLE sys_dict_type (
	dict_name VARCHAR(64) NOT NULL, 
	dict_type VARCHAR(255) NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	UNIQUE (dict_type)
);
CREATE INDEX ix_sys_dict_type_created_time ON sys_dict_type (created_time);
CREATE INDEX ix_sys_dict_type_deleted_time ON sys_dict_type (deleted_time);
CREATE INDEX ix_sys_dict_type_id ON sys_dict_type (id);
CREATE INDEX ix_sys_dict_type_is_deleted ON sys_dict_type (is_deleted);
CREATE INDEX ix_sys_dict_type_status ON sys_dict_type (status);
CREATE INDEX ix_sys_dict_type_updated_time ON sys_dict_type (updated_time);
CREATE UNIQUE INDEX ix_sys_dict_type_uuid ON sys_dict_type (uuid);

CREATE TABLE sys_menu (
	name VARCHAR(50) NOT NULL, 
	type INTEGER NOT NULL, 
	"order" INTEGER NOT NULL, 
	permission VARCHAR(100), 
	icon VARCHAR(50), 
	route_name VARCHAR(100), 
	route_path VARCHAR(200), 
	component_path VARCHAR(200), 
	redirect VARCHAR(200), 
	hidden BOOLEAN NOT NULL, 
	keep_alive BOOLEAN NOT NULL, 
	always_show BOOLEAN NOT NULL, 
	title VARCHAR(50), 
	params JSON, 
	affix BOOLEAN NOT NULL, 
	client VARCHAR(20) DEFAULT 'pc' NOT NULL, 
	parent_id INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(parent_id) REFERENCES sys_menu (id) ON DELETE SET NULL
);
CREATE INDEX ix_sys_menu_created_time ON sys_menu (created_time);
CREATE INDEX ix_sys_menu_deleted_time ON sys_menu (deleted_time);
CREATE INDEX ix_sys_menu_id ON sys_menu (id);
CREATE INDEX ix_sys_menu_is_deleted ON sys_menu (is_deleted);
CREATE INDEX ix_sys_menu_parent_id ON sys_menu (parent_id);
CREATE INDEX ix_sys_menu_status ON sys_menu (status);
CREATE INDEX ix_sys_menu_updated_time ON sys_menu (updated_time);
CREATE UNIQUE INDEX ix_sys_menu_uuid ON sys_menu (uuid);

CREATE TABLE sys_param (
	config_name VARCHAR(64) NOT NULL, 
	config_key VARCHAR(500) NOT NULL, 
	config_value VARCHAR(500), 
	config_type BOOLEAN, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id)
);
CREATE INDEX ix_sys_param_created_time ON sys_param (created_time);
CREATE INDEX ix_sys_param_deleted_time ON sys_param (deleted_time);
CREATE INDEX ix_sys_param_id ON sys_param (id);
CREATE INDEX ix_sys_param_is_deleted ON sys_param (is_deleted);
CREATE INDEX ix_sys_param_status ON sys_param (status);
CREATE INDEX ix_sys_param_updated_time ON sys_param (updated_time);
CREATE UNIQUE INDEX ix_sys_param_uuid ON sys_param (uuid);

CREATE TABLE sys_role (
	name VARCHAR(64) NOT NULL, 
	code VARCHAR(16) NOT NULL, 
	"order" INTEGER NOT NULL, 
	data_scope INTEGER NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	UNIQUE (code)
);
CREATE INDEX ix_sys_role_created_time ON sys_role (created_time);
CREATE INDEX ix_sys_role_deleted_time ON sys_role (deleted_time);
CREATE INDEX ix_sys_role_id ON sys_role (id);
CREATE INDEX ix_sys_role_is_deleted ON sys_role (is_deleted);
CREATE INDEX ix_sys_role_status ON sys_role (status);
CREATE INDEX ix_sys_role_updated_time ON sys_role (updated_time);
CREATE UNIQUE INDEX ix_sys_role_uuid ON sys_role (uuid);

CREATE TABLE sys_tenant (
	name VARCHAR(100) NOT NULL, 
	code VARCHAR(100) NOT NULL, 
	start_time TIMESTAMP WITHOUT TIME ZONE, 
	end_time TIMESTAMP WITHOUT TIME ZONE, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	UNIQUE (name), 
	UNIQUE (code)
);
CREATE INDEX ix_sys_tenant_created_time ON sys_tenant (created_time);
CREATE INDEX ix_sys_tenant_deleted_time ON sys_tenant (deleted_time);
CREATE INDEX ix_sys_tenant_id ON sys_tenant (id);
CREATE INDEX ix_sys_tenant_is_deleted ON sys_tenant (is_deleted);
CREATE INDEX ix_sys_tenant_status ON sys_tenant (status);
CREATE INDEX ix_sys_tenant_updated_time ON sys_tenant (updated_time);
CREATE UNIQUE INDEX ix_sys_tenant_uuid ON sys_tenant (uuid);

CREATE TABLE task_job (
	job_id VARCHAR(64) NOT NULL, 
	job_name VARCHAR(128), 
	trigger_type VARCHAR(32), 
	status VARCHAR(16) NOT NULL, 
	next_run_time VARCHAR(64), 
	job_state TEXT, 
	result TEXT, 
	error TEXT, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id)
);
CREATE INDEX ix_task_job_created_time ON task_job (created_time);
CREATE INDEX ix_task_job_deleted_time ON task_job (deleted_time);
CREATE INDEX ix_task_job_id ON task_job (id);
CREATE INDEX ix_task_job_is_deleted ON task_job (is_deleted);
CREATE INDEX ix_task_job_job_id ON task_job (job_id);
CREATE INDEX ix_task_job_updated_time ON task_job (updated_time);
CREATE UNIQUE INDEX ix_task_job_uuid ON task_job (uuid);

CREATE TABLE ai_model (
	provider_id INTEGER NOT NULL, 
	model_key VARCHAR(128) NOT NULL, 
	name VARCHAR(128) NOT NULL, 
	url VARCHAR(255), 
	tool_calling BOOLEAN, 
	vision BOOLEAN, 
	max_input_tokens INTEGER, 
	max_output_tokens INTEGER, 
	thinking BOOLEAN, 
	temperature FLOAT, 
	is_default BOOLEAN, 
	sort_order INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(provider_id) REFERENCES ai_provider (id) ON DELETE CASCADE
);
CREATE INDEX ix_ai_model_created_time ON ai_model (created_time);
CREATE INDEX ix_ai_model_deleted_time ON ai_model (deleted_time);
CREATE INDEX ix_ai_model_id ON ai_model (id);
CREATE INDEX ix_ai_model_is_deleted ON ai_model (is_deleted);
CREATE INDEX ix_ai_model_provider_id ON ai_model (provider_id);
CREATE INDEX ix_ai_model_status ON ai_model (status);
CREATE INDEX ix_ai_model_updated_time ON ai_model (updated_time);
CREATE UNIQUE INDEX ix_ai_model_uuid ON ai_model (uuid);

CREATE TABLE sys_dict_data (
	dict_sort INTEGER NOT NULL, 
	dict_label VARCHAR(255) NOT NULL, 
	dict_value VARCHAR(255) NOT NULL, 
	css_class VARCHAR(255), 
	list_class VARCHAR(255), 
	is_default BOOLEAN NOT NULL, 
	dict_type VARCHAR(255) NOT NULL, 
	dict_type_id INTEGER NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	PRIMARY KEY (id), 
	FOREIGN KEY(dict_type_id) REFERENCES sys_dict_type (id) ON DELETE CASCADE
);
CREATE INDEX ix_sys_dict_data_created_time ON sys_dict_data (created_time);
CREATE INDEX ix_sys_dict_data_deleted_time ON sys_dict_data (deleted_time);
CREATE INDEX ix_sys_dict_data_id ON sys_dict_data (id);
CREATE INDEX ix_sys_dict_data_is_deleted ON sys_dict_data (is_deleted);
CREATE INDEX ix_sys_dict_data_status ON sys_dict_data (status);
CREATE INDEX ix_sys_dict_data_updated_time ON sys_dict_data (updated_time);
CREATE UNIQUE INDEX ix_sys_dict_data_uuid ON sys_dict_data (uuid);

CREATE TABLE sys_role_depts (
	role_id INTEGER NOT NULL, 
	dept_id INTEGER NOT NULL, 
	PRIMARY KEY (role_id, dept_id), 
	FOREIGN KEY(role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(dept_id) REFERENCES sys_dept (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sys_role_menus (
	role_id INTEGER NOT NULL, 
	menu_id INTEGER NOT NULL, 
	PRIMARY KEY (role_id, menu_id), 
	FOREIGN KEY(role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(menu_id) REFERENCES sys_menu (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sys_user (
	username VARCHAR(64) NOT NULL, 
	password VARCHAR(255) NOT NULL, 
	name VARCHAR(32) NOT NULL, 
	mobile VARCHAR(11), 
	email VARCHAR(64), 
	gender VARCHAR(1), 
	avatar VARCHAR(255), 
	is_superuser BOOLEAN NOT NULL, 
	last_login TIMESTAMP WITH TIME ZONE, 
	id_card VARCHAR(255), 
	gitee_login VARCHAR(32), 
	github_login VARCHAR(32), 
	wx_login VARCHAR(32), 
	qq_login VARCHAR(32), 
	dept_id INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	tenant_id INTEGER NOT NULL, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	UNIQUE (username), 
	UNIQUE (mobile), 
	UNIQUE (email), 
	FOREIGN KEY(dept_id) REFERENCES sys_dept (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(tenant_id) REFERENCES sys_tenant (id) ON DELETE RESTRICT ON UPDATE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(64) NOT NULL, 
	access_url VARCHAR(500) NOT NULL, 
	icon_url VARCHAR(300), 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	tenant_id INTEGER NOT NULL, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(tenant_id) REFERENCES sys_tenant (id) ON DELETE RESTRICT ON UPDATE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(64) NOT NULL, 
	a INTEGER, 
	b BIGINT, 
	c FLOAT, 
	d BOOLEAN NOT NULL, 
	e DATE, 
	f TIME WITHOUT TIME ZONE, 
	g TIMESTAMP WITHOUT TIME ZONE, 
	h TEXT, 
	i JSON, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(64) NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	table_name VARCHAR(200) NOT NULL, 
	table_comment VARCHAR(500), 
	class_name VARCHAR(100) NOT NULL, 
	package_name VARCHAR(100), 
	module_name VARCHAR(30), 
	business_name VARCHAR(30), 
	function_name VARCHAR(100), 
	sub_table_name VARCHAR(64) DEFAULT NULL, 
	sub_table_fk_name VARCHAR(64) DEFAULT NULL, 
	parent_menu_id INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(100) NOT NULL, 
	type VARCHAR(50) NOT NULL, 
	config TEXT, 
	description VARCHAR(500), 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(100) NOT NULL, 
	source_id INTEGER NOT NULL, 
	target_id INTEGER NOT NULL, 
	source_path VARCHAR(500), 
	target_path VARCHAR(500), 
	transfer_status INTEGER NOT NULL, 
	progress INTEGER NOT NULL, 
	error_msg TEXT, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(100) NOT NULL, 
	code VARCHAR(50) NOT NULL, 
	nodes_json TEXT, 
	edges_json TEXT, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	CONSTRAINT uq_storage_workflow_code UNIQUE (code), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	type INTEGER NOT NULL, 
	request_path VARCHAR(255) NOT NULL, 
	request_method VARCHAR(10) NOT NULL, 
	request_payload TEXT, 
	request_ip VARCHAR(50), 
	login_location VARCHAR(255), 
	request_os VARCHAR(64), 
	request_browser VARCHAR(64), 
	response_code INTEGER NOT NULL, 
	response_json TEXT, 
	process_time VARCHAR(20), 
	username VARCHAR(64), 
	mobile VARCHAR(11), 
	login_platform VARCHAR(32), 
	signature VARCHAR(256), 
	signed_fields VARCHAR(512), 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	notice_title VARCHAR(64) NOT NULL, 
	notice_type VARCHAR(1) NOT NULL, 
	notice_content TEXT, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	name VARCHAR(64) NOT NULL, 
	"order" INTEGER NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	user_id INTEGER NOT NULL, 
	role_id INTEGER NOT NULL, 
	PRIMARY KEY (user_id, role_id), 
	FOREIGN KEY(user_id) REFERENCES sys_user (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(role_id) REFERENCES sys_role (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE task_node (
	name VARCHAR(64) NOT NULL, 
	code VARCHAR(32) NOT NULL, 
	jobstore VARCHAR(64), 
	executor VARCHAR(64), 
	trigger VARCHAR(64), 
	trigger_args TEXT, 
	func TEXT, 
	args TEXT, 
	kwargs TEXT, 
	coalesce BOOLEAN, 
	max_instances INTEGER, 
	start_date VARCHAR(64), 
	end_date VARCHAR(64), 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	UNIQUE (code), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	column_name VARCHAR(200) NOT NULL, 
	column_comment VARCHAR(500), 
	column_type VARCHAR(100) NOT NULL, 
	column_length VARCHAR(50), 
	column_default VARCHAR(200), 
	is_pk BOOLEAN DEFAULT false NOT NULL, 
	is_increment BOOLEAN DEFAULT false NOT NULL, 
	is_nullable BOOLEAN DEFAULT true NOT NULL, 
	is_unique BOOLEAN DEFAULT false NOT NULL, 
	python_type VARCHAR(100), 
	python_field VARCHAR(200), 
	is_insert BOOLEAN DEFAULT true NOT NULL, 
	is_edit BOOLEAN DEFAULT true NOT NULL, 
	is_list BOOLEAN DEFAULT true NOT NULL, 
	is_query BOOLEAN DEFAULT false NOT NULL, 
	query_type VARCHAR(50), 
	html_type VARCHAR(100), 
	dict_type VARCHAR(200), 
	sort INTEGER NOT NULL, 
	table_id INTEGER NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(table_id) REFERENCES gen_table (id) ON DELETE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	user_id INTEGER NOT NULL, 
	position_id INTEGER NOT NULL, 
	PRIMARY KEY (user_id, position_id), 
	FOREIGN KEY(user_id) REFERENCES sys_user (id) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY(position_id) REFERENCES sys_position (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sys_version (
	version VARCHAR(32) NOT NULL, 
	title VARCHAR(200) NOT NULL, 
	date VARCHAR(50) NOT NULL, 
	content TEXT, 
	sort INTEGER NOT NULL, 
	status INTEGER NOT NULL, 
	description VARCHAR(500), 
	require_re_login BOOLEAN NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	UNIQUE (version), 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	title VARCHAR(200) NOT NULL, 
	status INTEGER NOT NULL, 
	description TEXT, 
	ticket_content TEXT, 
	summary TEXT, 
	ticket_type VARCHAR(20) NOT NULL, 
	images TEXT, 
	reply TEXT, 
	assigned_id INTEGER, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(assigned_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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
	ticket_id INTEGER NOT NULL, 
	content TEXT NOT NULL, 
	id SERIAL NOT NULL, 
	uuid VARCHAR(64) NOT NULL, 
	status VARCHAR(10) NOT NULL, 
	description TEXT, 
	created_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	updated_time TIMESTAMP WITHOUT TIME ZONE NOT NULL, 
	is_deleted BOOLEAN NOT NULL, 
	deleted_time TIMESTAMP WITHOUT TIME ZONE, 
	created_id INTEGER, 
	updated_id INTEGER, 
	deleted_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(ticket_id) REFERENCES sys_ticket (id) ON DELETE CASCADE, 
	FOREIGN KEY(created_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(updated_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE, 
	FOREIGN KEY(deleted_id) REFERENCES sys_user (id) ON DELETE SET NULL ON UPDATE CASCADE
);
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

-- 运行时表（非 ORM 模型）：APScheduler SQLAlchemy jobstore
DROP TABLE IF EXISTS apscheduler_jobs;
CREATE TABLE IF NOT EXISTS apscheduler_jobs (
  id varchar(191) NOT NULL,
  next_run_time double precision DEFAULT NULL,
  job_state bytea NOT NULL,
  CONSTRAINT apscheduler_jobs_pkey PRIMARY KEY (id)
);
CREATE INDEX IF NOT EXISTS ix_apscheduler_jobs_next_run_time ON apscheduler_jobs (next_run_time);

-- Alembic 版本表（配合 python main.py revision/upgrade 使用）
DROP TABLE IF EXISTS alembic_version;
CREATE TABLE IF NOT EXISTS alembic_version (
  version_num varchar(32) NOT NULL,
  CONSTRAINT alembic_version_pkey PRIMARY KEY (version_num)
);
