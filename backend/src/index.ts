import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import rateLimit from 'express-rate-limit'
import { PrismaClient } from '@prisma/client'
import authRoutes from './routes/auth.routes'
import articleRoutes from './routes/article.routes'

const app = express()
const PORT = process.env.PORT || 8000
const prisma = new PrismaClient()

// 数据库连接检查
async function checkDatabaseConnection() {
  try {
    await prisma.$connect()
    console.log('✅ 数据库连接成功')
  } catch (error) {
    console.error('❌ 数据库连接失败:', error)
    process.exit(1)
  }
}

// 安全中间件
app.use(helmet({
  contentSecurityPolicy: false, // 开发时禁用CSP
}))

// CORS配置
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}))

// 速率限制
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分钟
  max: 100, // 每个IP最多100个请求
  message: {
    success: false,
    error: {
      code: 'TOO_MANY_REQUESTS',
      message: '请求过于频繁，请稍后再试'
    }
  }
})

// 认证相关的特殊限制
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15分钟
  max: 5, // 每个IP最多5次登录/注册尝试
  message: {
    success: false,
    error: {
      code: 'TOO_MANY_AUTH_ATTEMPTS',
      message: '认证尝试次数过多，请15分钟后再试'
    }
  }
})

app.use(limiter)

// 解析JSON
app.use(express.json({ limit: '10mb' }))
app.use(express.urlencoded({ extended: true, limit: '10mb' }))

// 健康检查端点
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: '服务器运行正常',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  })
})

// API路由
app.use('/api/auth', authLimiter, authRoutes)
app.use('/api/articles', articleRoutes)

// 根路径
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: '博客后端API服务',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/api/auth',
      articles: '/api/articles',
      docs: 'https://github.com/your-username/blog-backend#api-documentation'
    }
  })
})

// 404处理
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: {
      code: 'NOT_FOUND',
      message: `路径 ${req.originalUrl} 不存在`
    }
  })
})

// 全局错误处理
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Unhandled error:', err)
  
  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: '服务器内部错误'
    }
  })
})

// 启动服务器
async function startServer() {
  try {
    // 检查数据库连接
    await checkDatabaseConnection()
    
    // 启动HTTP服务器
    app.listen(PORT, () => {
      console.log(`🚀 服务器启动成功！`)
      console.log(`📍 地址: http://localhost:${PORT}`)
      console.log(`🔧 环境: ${process.env.NODE_ENV || 'development'}`)
      console.log(`💾 数据库: PostgreSQL`)
      console.log(`📋 API文档: http://localhost:${PORT}/`)
      console.log('\n可用端点:')
      console.log(`  GET  /health              - 健康检查`)
      console.log(`  POST /api/auth/register   - 用户注册`)
      console.log(`  POST /api/auth/login      - 用户登录`)
      console.log(`  GET  /api/auth/me         - 获取用户信息`)
      console.log(`  PUT  /api/auth/profile    - 更新用户资料`)
      console.log(`  PUT  /api/auth/password   - 修改密码`)
      console.log(`  POST /api/auth/logout     - 用户登出`)
      console.log(`  GET  /api/articles        - 获取文章列表`)
      console.log(`  POST /api/articles        - 创建文章`)
      console.log(`  GET  /api/articles/:id    - 获取文章详情`)
      console.log(`  PUT  /api/articles/:id    - 更新文章`)
      console.log(`  DELETE /api/articles/:id  - 删除文章`)
    })
  } catch (error) {
    console.error('❌ 服务器启动失败:', error)
    process.exit(1)
  }
}

// 启动应用
startServer()

// 优雅关闭
async function gracefulShutdown(signal: string) {
  console.log(`\n🛑 收到${signal}信号，开始优雅关闭...`)
  try {
    await prisma.$disconnect()
    console.log('✅ 数据库连接已关闭')
    process.exit(0)
  } catch (error) {
    console.error('❌ 关闭过程中出现错误:', error)
    process.exit(1)
  }
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'))
process.on('SIGINT', () => gracefulShutdown('SIGINT')) 