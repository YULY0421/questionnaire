# 问卷调查系统

一个功能完善的问卷调查系统，采用复古90年代网页风格设计。

## 技术栈

### 后端
- **Spring Boot 3.5.6** - Java后端框架
- **MyBatis 3.0.3** - ORM框架
- **MySQL** - 数据库
- **Lombok** - 简化Java代码

### 前端
- **Vue.js 3** - JavaScript框架
- **Vue Router 4** - 路由管理
- **Pinia** - 状态管理
- **Vite** - 构建工具

## 功能特性

### 🔐 用户认证系统
- ✅ 用户注册和登录
- ✅ 登录状态持久化
- ✅ 路由守卫保护
- ✅ 角色权限管理（普通用户/管理员）

### 1. 问卷管理子系统
- ✅ 创建问卷（设置标题、说明、问卷类型）
- ✅ 添加多种题型：单选、多选、填空、评分
- ✅ 题目必答设置
- ✅ 问卷状态管理（草稿、已发布、已结束）
- ✅ 生成问卷访问链接
- ✅ 访问权限设置（公开/指定用户）
- ✅ 查看问卷列表
- ✅ 修改、删除问卷（权限控制）
- ✅ 管理员可管理所有问卷

### 2. 问卷广场
- ✅ 展示所有公开问卷
- ✅ 题目预览功能
- ✅ 参与人数统计
- ✅ 快速填写入口
- ✅ 访问码复制

### 3. 问卷填写子系统
- ✅ 根据访问码加载问卷
- ✅ 无需登录即可填写
- ✅ 自动渲染不同类型题目
- ✅ 响应式布局（支持PC/移动端）
- ✅ 实时验证必填题目
- ✅ 防重复提交检测（基于IP）
- ✅ 一键提交问卷
- ✅ 提交成功提示

### 4. 数据统计子系统
- ✅ 展示问卷总体参与人数
- ✅ 数据概览卡片
- ✅ 按题目维度统计答题情况
- ✅ 导出TXT格式报告
- ✅ 导出Excel/CSV格式
- ✅ 自动生成统计图表
- ✅ 计算选项比例、平均分等指标

### 5. 问卷分享系统
- ✅ 专门的分享页面
- ✅ 一键复制访问码
- ✅ 一键复制访问链接
- ✅ 二维码生成（演示版）
- ✅ 多种分享方式说明

## 项目结构

```
questionnaire/
├── backend/                 # Spring Boot后端
│   ├── src/main/java/
│   │   └── com/system/backend/
│   │       ├── config/     # 配置类
│   │       ├── controller/ # 控制器
│   │       ├── dto/        # 数据传输对象
│   │       ├── entity/     # 实体类
│   │       ├── mapper/     # MyBatis映射接口
│   │       └── service/    # 业务逻辑层
│   └── src/main/resources/
│       ├── mapper/         # MyBatis XML映射文件
│       └── application.properties
├── frontend/               # Vue.js前端
│   ├── src/
│   │   ├── api/           # API服务
│   │   ├── assets/        # 静态资源（CSS）
│   │   ├── router/        # 路由配置
│   │   └── views/         # 页面组件
│   └── package.json
└── database/              # 数据库脚本
    └── schema.sql
```

## 快速开始

### 1. 数据库设置

```bash
# 1. 创建数据库
mysql -u root -p
CREATE DATABASE questionnaire_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 2. 导入数据库表结构
mysql -u root -p questionnaire_db < C:/Users/10064/Desktop/School-25-26/questionnaire/questionnaire/database/schema.sql
```

**注意：** 请根据实际情况修改 `backend/src/main/resources/application.properties` 中的数据库连接信息：
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/questionnaire_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=你的密码
```

### 2. 启动后端

```bash
cd backend

# 使用Maven启动
./mvnw spring-boot:run

# 或者在Windows上使用
mvnw.cmd spring-boot:run
```

后端将在 `http://localhost:8080` 上运行。

### 3. 启动前端

```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端将在 `http://localhost:5173` 上运行。

### 4. 访问系统

在浏览器中打开：`http://localhost:5173`

## 使用指南

### 创建问卷

1. 点击首页的"创建新问卷"按钮
2. 填写问卷标题和说明
3. 选择问卷类型（匿名/实名）
4. 添加题目：
   - 单选题：适合单一选项的问题
   - 多选题：允许选择多个选项
   - 填空题：自由文本输入
   - 评分题：1-5分评分
5. 保存问卷（状态为"草稿"）
6. 在问卷列表中点击"发布"按钮发布问卷

### 填写问卷

1. 获取问卷访问码（8位字符）
2. 在首页输入访问码
3. 填写所有必答题目
4. 提交问卷

### 查看统计

1. 在问卷列表中点击"统计"按钮
2. 查看各题目的统计结果：
   - 选择题：查看选项分布和百分比
   - 填空题：查看所有答案列表
   - 评分题：查看平均分、最高分、最低分和分布
3. 点击"导出数据"下载统计报告

## API接口文档

### 问卷接口

- `POST /api/questionnaire` - 创建问卷
- `PUT /api/questionnaire/{id}` - 更新问卷
- `DELETE /api/questionnaire/{id}` - 删除问卷
- `GET /api/questionnaire/{id}` - 获取问卷详情
- `GET /api/questionnaire/code/{code}` - 通过访问码获取问卷
- `GET /api/questionnaire/all` - 获取所有问卷
- `PUT /api/questionnaire/{id}/publish` - 发布问卷
- `PUT /api/questionnaire/{id}/end` - 结束问卷

### 答卷接口

- `POST /api/response` - 提交答卷
- `GET /api/response/questionnaire/{id}` - 获取问卷的所有答卷
- `GET /api/response/questionnaire/{id}/count` - 获取答卷数量

### 统计接口

- `GET /api/statistics/{id}` - 获取问卷统计数据

## 设计特色

### 复古风格
- 采用90年代网页设计风格
- Times New Roman字体
- 米色背景色
- 经典的凸起/凹陷边框效果
- 简洁的表格样式
- 蓝色超链接和紫色已访问链接

## 数据库表结构

- `user` - 用户表
- `questionnaire` - 问卷表
- `question` - 题目表
- `question_option` - 题目选项表
- `response` - 答卷表
- `answer` - 答案表

详细的表结构请参考 `database/schema.sql`

## 注意事项

1. 这是一个学习项目，未包含生产环境部署相关配置
2. 未实现完整的用户认证系统（使用固定用户ID）
3. 密码存储使用明文（生产环境应使用BCrypt等加密）
4. 未实现完整的权限控制
5. 数据导出功能较为简单，仅支持文本格式

## 开发说明

### 添加新功能

1. **后端**：
   - 在 `entity` 包中添加实体类
   - 在 `mapper` 包中添加Mapper接口
   - 在 `resources/mapper` 中添加XML映射
   - 在 `service` 包中实现业务逻辑
   - 在 `controller` 包中添加REST接口

2. **前端**：
   - 在 `api` 目录中添加API调用
   - 在 `views` 目录中创建页面组件
   - 在 `router/index.js` 中配置路由

## 许可证

本项目仅供学习使用。

## 联系方式

如有问题，请查看代码注释或提交Issue。

