# 登录注册功能使用指南

## 功能概述

问卷系统现已支持完整的用户认证功能，包括：
- ✅ 用户注册
- ✅ 用户登录
- ✅ 用户登出
- ✅ 登录状态管理
- ✅ 基于角色的权限控制

## 使用说明

### 1. 注册新账号

1. 点击导航栏的"注册"按钮
2. 填写注册信息：
   - **用户名**：3-20个字符，只能包含字母、数字和下划线
   - **密码**：至少6位
   - **确认密码**：必须与密码一致
   - **邮箱**：可选
3. 点击"注册"按钮
4. 注册成功后会自动跳转到登录页面

### 2. 登录账号

1. 点击导航栏的"登录"按钮
2. 输入用户名和密码
3. 点击"登录"按钮
4. 登录成功后会跳转到问卷列表页面

### 3. 退出登录

1. 登录后，导航栏右上角会显示"欢迎，用户名"
2. 点击"退出"按钮
3. 确认后即可退出登录

## 测试账号

系统已预置两个测试账号：

**管理员账号：**
- 用户名：`admin`
- 密码：`password`
- 权限：可查看所有用户创建的问卷

**普通用户账号：**
- 用户名：`user1`
- 密码：`password`
- 权限：只能查看和管理自己创建的问卷

## 权限说明

### 管理员（ADMIN）
- 可以查看所有问卷
- 可以编辑和删除所有问卷
- 可以查看所有问卷的统计数据

### 普通用户（USER）
- 只能查看自己创建的问卷
- 只能编辑和删除自己创建的问卷
- 只能查看自己问卷的统计数据

## 功能限制

以下功能需要登录后才能使用：

1. **创建问卷**：必须登录
2. **编辑问卷**：必须登录且为问卷创建者
3. **问卷管理**：必须登录
4. **查看统计**：必须登录

**无需登录的功能：**
- 填写问卷（通过访问码）
- 查看首页

## 技术实现

### 后端

1. **认证接口**（`/api/auth`）：
   - `POST /login` - 用户登录
   - `POST /register` - 用户注册
   - `GET /user/{id}` - 获取用户信息

2. **用户服务**（`UserService`）：
   - 用户登录验证
   - 用户注册处理
   - 密码验证（简化版）

### 前端

1. **状态管理**（`stores/user.js`）：
   - 使用 Pinia 管理用户状态
   - localStorage 持久化登录状态
   - 自动恢复登录状态

2. **页面组件**：
   - `Login.vue` - 登录页面
   - `Register.vue` - 注册页面

3. **路由守卫**：
   - 问卷管理页面检查登录状态
   - 未登录自动跳转到登录页

## 数据存储

用户登录信息存储在浏览器的 localStorage 中：
- Key: `user`
- Value: JSON格式的用户信息（不包含密码）

**清除登录状态：**
- 点击"退出"按钮
- 清除浏览器缓存
- 手动删除 localStorage

## API 示例

### 登录请求

```javascript
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "password"
}
```

**响应：**
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "username": "admin",
    "email": "admin@lanen.site",
    "role": "ADMIN",
    "createTime": "2025-01-01T00:00:00",
    "updateTime": "2025-01-01T00:00:00"
  }
}
```

### 注册请求

```javascript
POST http://localhost:8080/api/auth/register
Content-Type: application/json

{
  "username": "newuser",
  "password": "123456",
  "email": "newuser@example.com"
}
```

## 安全注意事项

### 当前实现（学习项目）

- 密码明文存储（仅用于学习）
- 简单的密码验证
- 无Token机制
- 无Session管理

### 生产环境建议

如果要用于生产环境，建议添加：

1. **密码加密**：
   ```java
   // 使用 BCrypt 加密
   BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
   String hashedPassword = encoder.encode(password);
   ```

2. **JWT Token**：
   - 添加 JWT 依赖
   - 生成和验证 Token
   - 在请求头中携带 Token

3. **Session 管理**：
   - 使用 Spring Security
   - 配置 Session 超时
   - 防止 Session 固定攻击

4. **验证码**：
   - 登录时添加图形验证码
   - 防止暴力破解

5. **HTTPS**：
   - 使用 SSL/TLS 加密传输
   - 保护用户密码安全

## 自定义配置

### 修改密码规则

编辑 `backend/src/main/java/com/system/backend/controller/AuthController.java`：

```java
if (request.getPassword().length() < 8) {
    return Result.error("密码长度至少8位");
}
```

### 修改用户名规则

编辑 `frontend/src/views/Register.vue`：

```javascript
if (form.value.username.length < 5) {
  error.value = '用户名至少5个字符'
  return
}
```

## 常见问题

### Q1: 忘记密码怎么办？

A: 当前版本未实现找回密码功能。可以直接在数据库中修改：

```sql
UPDATE user SET password = 'newpassword' WHERE username = 'your_username';
```

### Q2: 如何修改用户角色？

A: 直接在数据库中修改：

```sql
UPDATE user SET role = 'ADMIN' WHERE username = 'your_username';
```

### Q3: 为什么退出登录后还能访问某些页面？

A: 问卷填写页面无需登录。只有问卷管理、创建、编辑等功能需要登录。

### Q4: 可以同时登录多个账号吗？

A: 不可以。系统使用 localStorage 存储登录状态，同一浏览器只能登录一个账号。

### Q5: 登录状态会过期吗？

A: 当前版本登录状态不会过期，除非手动退出或清除浏览器缓存。

## 开发者提示

### 添加新的用户字段

1. 修改数据库表结构：
   ```sql
   ALTER TABLE user ADD COLUMN phone VARCHAR(20);
   ```

2. 更新实体类：
   ```java
   // User.java
   private String phone;
   ```

3. 更新注册接口和表单

### 添加邮箱验证

1. 添加邮件发送功能
2. 生成验证码
3. 发送验证邮件
4. 验证后激活账号

## 升级建议

为了让系统更加完善，可以考虑添加：

- [ ] 找回密码功能
- [ ] 邮箱验证
- [ ] 手机验证
- [ ] 第三方登录（微信、QQ等）
- [ ] 用户头像上传
- [ ] 个人信息修改
- [ ] 密码修改
- [ ] 登录日志
- [ ] 在线用户管理

## 总结

本系统的登录注册功能已经实现了基本的用户认证流程，适合学习和小型项目使用。如需用于生产环境，请务必加强安全措施。

