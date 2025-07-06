# 1. 登录
$loginData = '{"email":"wang_mx@bupt.edu.cn","password":"wang123"}'
$response = Invoke-RestMethod -Uri "http://localhost:8000/api/auth/login" -Method POST -Body $loginData -ContentType "application/json"
$token = $response.data.token

# 2. 获取文章列表
Invoke-RestMethod -Uri "http://localhost:8000/api/articles" -Method GET

# 3. 创建文章
$articleData = '{"title":"API测试文章","content":"测试内容","category":"测试","tags":["API","测试"],"isPublished":true}'
$headers = @{"Authorization" = "Bearer $token"; "Content-Type" = "application/json"}
Invoke-RestMethod -Uri "http://localhost:8000/api/articles" -Method POST -Body $articleData -Headers $headers