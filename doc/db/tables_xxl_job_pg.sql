-- 创建序列
CREATE SEQUENCE xxl_job_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
CREATE TABLE xxl_job_info (
                              id INT PRIMARY KEY DEFAULT nextval('xxl_job_info_id_seq'),
                              job_group INT NOT NULL,
                              job_desc VARCHAR(255) NOT NULL,
                              add_time TIMESTAMP DEFAULT NULL,
                              update_time TIMESTAMP DEFAULT NULL,
                              author VARCHAR(64) DEFAULT NULL,
                              alarm_email VARCHAR(255) DEFAULT NULL,
                              schedule_type VARCHAR(50) NOT NULL DEFAULT 'NONE',
                              schedule_conf VARCHAR(128) DEFAULT NULL,
                              misfire_strategy VARCHAR(50) NOT NULL DEFAULT 'DO_NOTHING',
                              executor_route_strategy VARCHAR(50) DEFAULT NULL,
                              executor_handler VARCHAR(255) DEFAULT NULL,
                              executor_param VARCHAR(512) DEFAULT NULL,
                              executor_block_strategy VARCHAR(50) DEFAULT NULL,
                              executor_timeout INT NOT NULL DEFAULT 0,
                              executor_fail_retry_count INT NOT NULL DEFAULT 0,
                              glue_type VARCHAR(50) NOT NULL,
                              glue_source TEXT,
                              glue_remark VARCHAR(128) DEFAULT NULL,
                              glue_updatetime TIMESTAMP DEFAULT NULL,
                              child_jobid VARCHAR(255) DEFAULT NULL,
                              trigger_status SMALLINT NOT NULL DEFAULT 0,
                              trigger_last_time BIGINT NOT NULL DEFAULT 0,
                              trigger_next_time BIGINT NOT NULL DEFAULT 0
);

-- 为表的列添加注释
COMMENT ON COLUMN xxl_job_info.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_info.author IS '作者';
COMMENT ON COLUMN xxl_job_info.alarm_email IS '报警邮件';
COMMENT ON COLUMN xxl_job_info.schedule_type IS '调度类型';
COMMENT ON COLUMN xxl_job_info.schedule_conf IS '调度配置，值含义取决于调度类型';
COMMENT ON COLUMN xxl_job_info.misfire_strategy IS '调度过期策略';
COMMENT ON COLUMN xxl_job_info.executor_route_strategy IS '执行器路由策略';
COMMENT ON COLUMN xxl_job_info.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_info.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_info.executor_block_strategy IS '阻塞处理策略';
COMMENT ON COLUMN xxl_job_info.executor_timeout IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN xxl_job_info.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_info.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_info.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_info.glue_remark IS 'GLUE备注';
COMMENT ON COLUMN xxl_job_info.glue_updatetime IS 'GLUE更新时间';
COMMENT ON COLUMN xxl_job_info.child_jobid IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN xxl_job_info.trigger_status IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN xxl_job_info.trigger_last_time IS '上次调度时间';
COMMENT ON COLUMN xxl_job_info.trigger_next_time IS '下次调度时间';


-- 创建序列
CREATE SEQUENCE xxl_job_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
-- 创建表
CREATE TABLE xxl_job_log (
                             id BIGINT PRIMARY KEY DEFAULT nextval('xxl_job_log_id_seq'),
                             job_group INT NOT NULL,
                             job_id INT NOT NULL,
                             executor_address VARCHAR(255) DEFAULT NULL,
                             executor_handler VARCHAR(255) DEFAULT NULL,
                             executor_param VARCHAR(512) DEFAULT NULL,
                             executor_sharding_param VARCHAR(20) DEFAULT NULL,
                             executor_fail_retry_count INT NOT NULL DEFAULT 0,
                             trigger_time TIMESTAMP DEFAULT NULL,
                             trigger_code INT NOT NULL,
                             trigger_msg TEXT,
                             handle_time TIMESTAMP DEFAULT NULL,
                             handle_code INT NOT NULL,
                             handle_msg TEXT,
                             alarm_status SMALLINT NOT NULL DEFAULT 0
);

-- 创建索引
CREATE INDEX trigger_time_idx ON xxl_job_log(trigger_time);
CREATE INDEX handle_code_idx ON xxl_job_log(handle_code);


COMMENT ON COLUMN xxl_job_log.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_log.job_id IS '任务，主键ID';
COMMENT ON COLUMN xxl_job_log.executor_address IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN xxl_job_log.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_log.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_log.executor_sharding_param IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN xxl_job_log.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_log.trigger_time IS '调度-时间';
COMMENT ON COLUMN xxl_job_log.trigger_code IS '调度-结果';
COMMENT ON COLUMN xxl_job_log.trigger_msg IS '调度-日志';
COMMENT ON COLUMN xxl_job_log.handle_time IS '执行-时间';
COMMENT ON COLUMN xxl_job_log.handle_code IS '执行-状态';
COMMENT ON COLUMN xxl_job_log.handle_msg IS '执行-日志';
COMMENT ON COLUMN xxl_job_log.alarm_status IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';

-- 创建序列
CREATE SEQUENCE xxl_job_log_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
CREATE TABLE xxl_job_log_report (
                                    id INT PRIMARY KEY DEFAULT nextval('xxl_job_log_report_id_seq'),
                                    trigger_day TIMESTAMP DEFAULT NULL,
                                    running_count INT NOT NULL DEFAULT 0,
                                    suc_count INT NOT NULL DEFAULT 0,
                                    fail_count INT NOT NULL DEFAULT 0,
                                    update_time TIMESTAMP DEFAULT NULL,
                                    UNIQUE (trigger_day)
);

COMMENT ON COLUMN xxl_job_log_report.trigger_day IS '调度-时间';
COMMENT ON COLUMN xxl_job_log_report.running_count IS '运行中-日志数量';
COMMENT ON COLUMN xxl_job_log_report.suc_count IS '执行成功-日志数量';
COMMENT ON COLUMN xxl_job_log_report.fail_count IS '执行失败-日志数量';


-- 创建序列
CREATE SEQUENCE xxl_job_logglue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
CREATE TABLE xxl_job_logglue (
                                 id INT PRIMARY KEY DEFAULT nextval('xxl_job_logglue_id_seq'),
                                 job_id INT NOT NULL,
                                 glue_type VARCHAR(50) DEFAULT NULL,
                                 glue_source TEXT,
                                 glue_remark VARCHAR(128) NOT NULL,
                                 add_time TIMESTAMP DEFAULT NULL,
                                 update_time TIMESTAMP DEFAULT NULL
);

COMMENT ON COLUMN xxl_job_logglue.job_id IS '任务，主键ID';
COMMENT ON COLUMN xxl_job_logglue.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_logglue.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_logglue.glue_remark IS 'GLUE备注';

-- 创建序列
CREATE SEQUENCE xxl_job_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
-- 创建表
CREATE TABLE xxl_job_registry (
                                  id INT PRIMARY KEY DEFAULT nextval('xxl_job_registry_id_seq'),
                                  registry_group VARCHAR(50) NOT NULL,
                                  registry_key VARCHAR(255) NOT NULL,
                                  registry_value VARCHAR(255) NOT NULL,
                                  update_time TIMESTAMP DEFAULT NULL
);

-- 创建组合索引
CREATE INDEX i_g_k_v_idx ON xxl_job_registry(registry_group, registry_key, registry_value);


-- 创建序列
CREATE SEQUENCE xxl_job_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
CREATE TABLE xxl_job_group (
                               id INT PRIMARY KEY DEFAULT nextval('xxl_job_group_id_seq'),
                               app_name VARCHAR(64) NOT NULL,
                               title VARCHAR(30) NOT NULL,
                               address_type SMALLINT NOT NULL DEFAULT 0,
                               address_list TEXT DEFAULT NULL,
                               update_time TIMESTAMP DEFAULT NULL
);

COMMENT ON COLUMN xxl_job_group.app_name IS '执行器AppName';
COMMENT ON COLUMN xxl_job_group.title IS '执行器名称';
COMMENT ON COLUMN xxl_job_group.address_type IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN xxl_job_group.address_list IS '执行器地址列表，多地址逗号分隔';

-- 创建序列
CREATE SEQUENCE xxl_job_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 创建表并使用序列生成自增主键
CREATE TABLE xxl_job_user (
                              id INT PRIMARY KEY DEFAULT nextval('xxl_job_user_id_seq'),
                              username VARCHAR(50) NOT NULL,
                              password VARCHAR(50) NOT NULL,
                              role SMALLINT NOT NULL,
                              permission VARCHAR(255) DEFAULT NULL,
                              UNIQUE (username)
);

COMMENT ON COLUMN xxl_job_user.username IS '账号';
COMMENT ON COLUMN xxl_job_user.password IS '密码';
COMMENT ON COLUMN xxl_job_user.role IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN xxl_job_user.permission IS '权限：执行器ID列表，多个逗号分割';

CREATE TABLE xxl_job_lock (
                              lock_name VARCHAR(50) PRIMARY KEY
);

COMMENT ON COLUMN xxl_job_lock.lock_name IS '锁名称';


INSERT INTO xxl_job_user(id, username, password, role, permission) VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO xxl_job_lock ( lock_name) VALUES ( 'schedule_lock');

commit;

