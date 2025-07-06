# 博客网站部署准备脚本
# 作者：AI Assistant
# 用途：自动化部署前的准备工作

Write-Host "🚀 博客网站部署准备脚本" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# 检查必要的软件
Write-Host "1. 检查必要的软件..." -ForegroundColor Yellow
$hasNode = Get-Command node -ErrorAction SilentlyContinue
$hasGit = Get-Command git -ErrorAction SilentlyContinue
$hasNpm = Get-Command npm -ErrorAction SilentlyContinue

if (-not $hasNode) {
    Write-Host "❌ 未找到Node.js，请先安装：https://nodejs.org" -ForegroundColor Red
    exit 1
}

if (-not $hasGit) {
    Write-Host "❌ 未找到Git，请先安装：https://git-scm.com" -ForegroundColor Red
    exit 1
}

if (-not $hasNpm) {
    Write-Host "❌ 未找到npm，请确保Node.js安装完整" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 所有必要软件已安装" -ForegroundColor Green
Write-Host ""

# 创建环境变量文件
Write-Host "2. 创建环境变量文件..." -ForegroundColor Yellow

# 后端环境变量
$backendEnv = @"
# 数据库连接（需要替换为实际数据库URL）
DATABASE_URL="postgresql://username:password@localhost:5432/blog_db"

# JWT密钥（生产环境必须更改）
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"
JWT_EXPIRES_IN="7d"

# 服务器配置
PORT=8000
NODE_ENV="production"

# CORS设置（需要替换为实际前端域名）
FRONTEND_URL="https://your-domain.com"
"@

# 前端环境变量
$frontendEnv = @"
# 后端API地址（需要替换为实际后端域名）
NEXT_PUBLIC_API_URL="https://your-backend-domain.com"

# 网站信息
NEXT_PUBLIC_SITE_NAME="我的个人博客"
NEXT_PUBLIC_SITE_DESCRIPTION="基于Next.js构建的现代化个人博客"
NEXT_PUBLIC_SITE_URL="https://your-domain.com"
"@

try {
    # 创建后端.env文件
    $backendEnv | Out-File -FilePath "backend/.env" -Encoding UTF8
    Write-Host "✅ 创建后端.env文件成功" -ForegroundColor Green
    
    # 创建前端.env.local文件
    $frontendEnv | Out-File -FilePath "frontend/.env.local" -Encoding UTF8
    Write-Host "✅ 创建前端.env.local文件成功" -ForegroundColor Green
} catch {
    Write-Host "❌ 创建环境变量文件失败：$($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# 安装依赖
Write-Host "3. 安装项目依赖..." -ForegroundColor Yellow

# 后端依赖
Write-Host "安装后端依赖..." -ForegroundColor Cyan
Set-Location backend
try {
    npm install
    Write-Host "✅ 后端依赖安装成功" -ForegroundColor Green
} catch {
    Write-Host "❌ 后端依赖安装失败" -ForegroundColor Red
}

# 前端依赖
Write-Host "安装前端依赖..." -ForegroundColor Cyan
Set-Location ../frontend
try {
    npm install
    Write-Host "✅ 前端依赖安装成功" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端依赖安装失败" -ForegroundColor Red
}

Set-Location ..

Write-Host ""

# 构建测试
Write-Host "4. 构建测试..." -ForegroundColor Yellow

# 测试后端构建
Write-Host "测试后端构建..." -ForegroundColor Cyan
Set-Location backend
try {
    npm run build
    Write-Host "✅ 后端构建成功" -ForegroundColor Green
} catch {
    Write-Host "❌ 后端构建失败" -ForegroundColor Red
}

# 测试前端构建
Write-Host "测试前端构建..." -ForegroundColor Cyan
Set-Location ../frontend
try {
    npm run build
    Write-Host "✅ 前端构建成功" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端构建失败" -ForegroundColor Red
}

Set-Location ..

Write-Host ""

# Git检查
Write-Host "5. Git仓库检查..." -ForegroundColor Yellow

$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠️  有未提交的更改，建议先提交代码" -ForegroundColor Yellow
    Write-Host "运行以下命令提交代码：" -ForegroundColor Cyan
    Write-Host "git add ." -ForegroundColor White
    Write-Host "git commit -m '准备部署'" -ForegroundColor White
    Write-Host "git push origin main" -ForegroundColor White
} else {
    Write-Host "✅ Git仓库状态正常" -ForegroundColor Green
}

Write-Host ""

# 部署建议
Write-Host "🎯 部署建议：" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

Write-Host "新手推荐方案：" -ForegroundColor Yellow
Write-Host "1. 前端部署到 Vercel（免费）" -ForegroundColor White
Write-Host "2. 后端部署到 Railway（免费额度）" -ForegroundColor White
Write-Host "3. 使用 Railway 提供的 PostgreSQL" -ForegroundColor White
Write-Host ""

Write-Host "进阶方案：" -ForegroundColor Yellow
Write-Host "1. 购买VPS服务器（$5-10/月）" -ForegroundColor White
Write-Host "2. 使用Docker部署" -ForegroundColor White
Write-Host "3. 配置域名和SSL证书" -ForegroundColor White
Write-Host ""

Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "1. 阅读 '部署指南.md' 文件" -ForegroundColor White
Write-Host "2. 根据选择的方案进行部署" -ForegroundColor White
Write-Host "3. 修改环境变量文件中的占位符" -ForegroundColor White
Write-Host ""

Write-Host "重要提醒：" -ForegroundColor Red
Write-Host "- 生产环境必须更改JWT_SECRET" -ForegroundColor Yellow
Write-Host "- 确保数据库连接字符串正确" -ForegroundColor Yellow
Write-Host "- 配置正确的CORS域名" -ForegroundColor Yellow
Write-Host ""

Write-Host "🎉 部署准备完成！查看 '部署指南.md' 继续操作" -ForegroundColor Green 