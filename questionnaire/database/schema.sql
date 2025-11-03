-- 问卷调查系统数据库表结构

-- 1. 用户表
CREATE TABLE `user` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码',
  `email` VARCHAR(100) COMMENT '邮箱',
  `role` VARCHAR(20) DEFAULT 'USER' COMMENT '角色：ADMIN/USER',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 问卷表
CREATE TABLE `questionnaire` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL COMMENT '问卷标题',
  `description` TEXT COMMENT '问卷说明',
  `type` VARCHAR(20) NOT NULL COMMENT '问卷类型：ANONYMOUS匿名/REAL_NAME实名',
  `status` VARCHAR(20) DEFAULT 'DRAFT' COMMENT '状态：DRAFT草稿/PUBLISHED已发布/ENDED已结束',
  `access_type` VARCHAR(20) DEFAULT 'PUBLIC' COMMENT '访问权限：PUBLIC公开/PRIVATE指定用户',
  `access_code` VARCHAR(50) UNIQUE COMMENT '访问链接码',
  `creator_id` BIGINT NOT NULL COMMENT '创建者ID',
  `start_time` DATETIME COMMENT '开始时间',
  `end_time` DATETIME COMMENT '结束时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`creator_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问卷表';

-- 3. 题目表
CREATE TABLE `question` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `questionnaire_id` BIGINT NOT NULL COMMENT '所属问卷ID',
  `title` TEXT NOT NULL COMMENT '题目标题',
  `type` VARCHAR(20) NOT NULL COMMENT '题目类型：SINGLE单选/MULTIPLE多选/TEXT填空/RATING评分',
  `is_required` TINYINT(1) DEFAULT 0 COMMENT '是否必答：0否/1是',
  `sort_order` INT DEFAULT 0 COMMENT '排序顺序',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目表';

-- 4. 选项表（用于单选、多选题）
CREATE TABLE `question_option` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `question_id` BIGINT NOT NULL COMMENT '所属题目ID',
  `option_text` VARCHAR(500) NOT NULL COMMENT '选项内容',
  `sort_order` INT DEFAULT 0 COMMENT '排序顺序',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`question_id`) REFERENCES `question`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目选项表';

-- 5. 答卷表
CREATE TABLE `response` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `questionnaire_id` BIGINT NOT NULL COMMENT '问卷ID',
  `user_id` BIGINT COMMENT '用户ID（实名问卷）',
  `ip_address` VARCHAR(50) COMMENT '提交IP',
  `status` VARCHAR(20) DEFAULT 'DRAFT' COMMENT '状态：DRAFT草稿/SUBMITTED已提交',
  `submit_time` DATETIME COMMENT '提交时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaire`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='答卷表';

-- 6. 答案表
CREATE TABLE `answer` (
  `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `response_id` BIGINT NOT NULL COMMENT '答卷ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `option_id` BIGINT COMMENT '选项ID（单选、多选题）',
  `answer_text` TEXT COMMENT '答案文本（填空题）',
  `rating_value` INT COMMENT '评分值（评分题）',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`response_id`) REFERENCES `response`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`question_id`) REFERENCES `question`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`option_id`) REFERENCES `question_option`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='答案表';

-- 创建索引
CREATE INDEX idx_questionnaire_creator ON questionnaire(creator_id);
CREATE INDEX idx_questionnaire_status ON questionnaire(status);
CREATE INDEX idx_question_questionnaire ON question(questionnaire_id);
CREATE INDEX idx_option_question ON question_option(question_id);
CREATE INDEX idx_response_questionnaire ON response(questionnaire_id);
CREATE INDEX idx_answer_response ON answer(response_id);
CREATE INDEX idx_answer_question ON answer(question_id);

-- 插入测试数据
INSERT INTO `user` (`username`, `password`, `email`, `role`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'admin@lanen.site', 'ADMIN'),
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'user@lanen.site', 'USER');

