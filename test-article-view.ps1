# 测试文章查看功能脚本

Write-Host "开始测试文章查看功能..." -ForegroundColor Green

# 1. 检查服务状态
Write-Host "`n1. 检查服务状态..." -ForegroundColor Yellow
try {
    $backendHealth = Invoke-RestMethod -Uri "http://localhost:8000/health" -Method GET -TimeoutSec 3
    Write-Host "✅ 后端服务正常" -ForegroundColor Green
} catch {
    Write-Host "❌ 后端服务未启动" -ForegroundColor Red
    Write-Host "请运行: cd backend && npm run dev"
    exit 1
}

try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method HEAD -TimeoutSec 3
    Write-Host "✅ 前端服务正常" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端服务未启动" -ForegroundColor Red
    Write-Host "请运行: cd frontend && npm run dev"
    exit 1
}

# 2. 获取文章列表
Write-Host "`n2. 测试文章列表API..." -ForegroundColor Yellow
try {
    $articlesResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/articles" -Method GET
    if ($articlesResponse.success) {
        $articles = $articlesResponse.data.articles
        Write-Host "✅ 文章列表获取成功" -ForegroundColor Green
        Write-Host "共找到 $($articles.Count) 篇文章"
        
        if ($articles.Count -gt 0) {
            $firstArticle = $articles[0]
            Write-Host "`n📖 第一篇文章信息："
            Write-Host "  - 标题: $($firstArticle.title)"
            Write-Host "  - Slug: $($firstArticle.slug)"
            Write-Host "  - 分类: $($firstArticle.category)"
            Write-Host "  - 作者: $($firstArticle.author.displayName)"
            Write-Host "  - 发布状态: $(if($firstArticle.isPublished){'已发布'}else{'草稿'})"
            
            # 3. 测试文章详情API
            Write-Host "`n3. 测试文章详情API..." -ForegroundColor Yellow
            try {
                $articleDetail = Invoke-RestMethod -Uri "http://localhost:8000/api/articles/slug/$($firstArticle.slug)" -Method GET
                if ($articleDetail.success) {
                    Write-Host "✅ 文章详情获取成功" -ForegroundColor Green
                    Write-Host "文章内容长度: $($articleDetail.data.content.Length) 字符"
                } else {
                    Write-Host "❌ 文章详情获取失败: $($articleDetail.message)" -ForegroundColor Red
                }
            } catch {
                Write-Host "❌ 文章详情API请求失败" -ForegroundColor Red
                Write-Host "错误: $($_.Exception.Message)"
            }
            
            # 4. 提供访问链接
            Write-Host "`n🔗 可以访问的链接：" -ForegroundColor Cyan
            Write-Host "  - 博客首页: http://localhost:3000/blog"
            Write-Host "  - 第一篇文章: http://localhost:3000/blog/$($firstArticle.slug)"
            Write-Host "  - 创建文章: http://localhost:3000/admin/create"
            Write-Host "  - 文章管理: http://localhost:3000/admin"
            
        } else {
            Write-Host "⚠️ 暂无文章，建议先创建一篇文章" -ForegroundColor Yellow
            Write-Host "创建文章链接: http://localhost:3000/admin/create"
        }
    } else {
        Write-Host "❌ 文章列表获取失败: $($articlesResponse.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ 文章列表API请求失败" -ForegroundColor Red
    Write-Host "错误: $($_.Exception.Message)"
}

Write-Host "`n✨ 测试完成！" -ForegroundColor Green
Write-Host "如果所有测试都通过，文章查看功能应该正常工作了。"
Write-Host "你可以在浏览器中访问上面的链接来验证。" 