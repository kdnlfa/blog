# 测试文章创建功能脚本

Write-Host "开始测试文章创建功能..." -ForegroundColor Green

# 1. 检查后端服务状态
Write-Host "`n1. 检查后端服务..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:8000/health" -Method GET -TimeoutSec 5
    Write-Host "✅ 后端服务正常运行" -ForegroundColor Green
    Write-Host "服务信息: $($healthResponse | ConvertTo-Json)"
} catch {
    Write-Host "❌ 后端服务未启动或连接失败" -ForegroundColor Red
    Write-Host "错误信息: $($_.Exception.Message)"
    Write-Host "请确保在 backend 目录运行: npm run dev"
    exit 1
}

# 2. 检查前端服务状态
Write-Host "`n2. 检查前端服务..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method HEAD -TimeoutSec 5
    Write-Host "✅ 前端服务正常运行" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端服务未启动" -ForegroundColor Red
    Write-Host "请确保在 frontend 目录运行: npm run dev"
}

# 3. 登录获取令牌
Write-Host "`n3. 登录获取认证令牌..." -ForegroundColor Yellow
$loginData = @{
    email = "wang_mx@bupt.edu.cn"
    password = "wang123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/auth/login" -Method POST -Body $loginData -ContentType "application/json"
    if ($loginResponse.success) {
        Write-Host "✅ 登录成功" -ForegroundColor Green
        $token = $loginResponse.data.token
        Write-Host "用户: $($loginResponse.data.user.displayName)"
    } else {
        Write-Host "❌ 登录失败: $($loginResponse.message)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ 登录请求失败" -ForegroundColor Red
    Write-Host "错误信息: $($_.Exception.Message)"
    exit 1
}

# 4. 测试创建文章
Write-Host "`n4. 测试创建文章..." -ForegroundColor Yellow
$articleData = @{
    title = "测试文章 - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    content = @"
# 这是一篇测试文章

这是文章的内容部分。

## 功能测试

- [x] 标题设置
- [x] 内容编写
- [x] 分类设置
- [x] 标签添加
- [x] 发布状态

## 代码示例

```javascript
console.log('Hello, Blog System!');
```

**测试完成！**
"@
    excerpt = "这是一篇用于测试博客系统文章创建功能的测试文章。"
    category = "技术分享"
    tags = @("测试", "API", "博客系统")
    imageUrl = ""
    isPublished = $true
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer $token"
}

try {
    $createResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/articles" -Method POST -Body $articleData -Headers $headers
    if ($createResponse.success) {
        Write-Host "✅ 文章创建成功！" -ForegroundColor Green
        Write-Host "文章ID: $($createResponse.data.id)"
        Write-Host "文章标题: $($createResponse.data.title)"
        Write-Host "文章链接: http://localhost:3000/blog/$($createResponse.data.slug)"
        Write-Host "管理链接: http://localhost:3000/admin"
    } else {
        Write-Host "❌ 文章创建失败: $($createResponse.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ 创建文章请求失败" -ForegroundColor Red
    Write-Host "错误信息: $($_.Exception.Message)"
    
    # 显示详细错误信息
    if ($_.Exception.Response) {
        $errorStream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorStream)
        $errorContent = $reader.ReadToEnd()
        Write-Host "详细错误: $errorContent" -ForegroundColor Red
    }
}

Write-Host "`n测试完成！" -ForegroundColor Green
Write-Host "如果测试成功，你可以访问以下链接："
Write-Host "- 创建文章: http://localhost:3000/admin/create"
Write-Host "- 管理文章: http://localhost:3000/admin"
Write-Host "- 查看博客: http://localhost:3000/blog" 