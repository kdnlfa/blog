import { Request, Response, NextFunction } from 'express'
import { AuthService, AuthError } from '../services/auth.service'

// 扩展Express Request类型，添加用户信息
declare global {
  namespace Express {
    interface Request {
      user?: {
        userId: string
        email: string
        role: string
      }
    }
  }
}

const authService = new AuthService()

// 认证中间件
export const authenticateToken = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.headers.authorization
    const token = authHeader && authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null

    if (!token) {
      res.status(401).json({
        success: false,
        error: {
          code: 'NO_TOKEN',
          message: '请提供认证token'
        }
      })
      return
    }

    const payload = authService.verifyToken(token)
    
    req.user = {
      userId: payload.userId,
      email: payload.email,
      role: payload.role
    }

    next()
  } catch (error) {
    if (error instanceof AuthError) {
      res.status(401).json({
        success: false,
        error: {
          code: error.code,
          message: error.message
        }
      })
      return
    }

    res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: '服务器内部错误'
      }
    })
  }
}

// 可选认证中间件（不强制要求登录）
export const optionalAuth = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization
    const token = authHeader && authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null

    if (token) {
      try {
        const payload = authService.verifyToken(token)
        req.user = {
          userId: payload.userId,
          email: payload.email,
          role: payload.role
        }
      } catch (error) {
        // Token无效时不报错，继续执行
      }
    }

    next()
  } catch (error) {
    next()
  }
}

// 角色检查中间件
// 修复requireRole函数
export const requireRole = (roles: string[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        error: {
          code: 'NOT_AUTHENTICATED',
          message: '请先登录'
        }
      })
      return
    }

    if (!roles.includes(req.user.role)) {
      res.status(403).json({
        success: false,
        error: {
          code: 'INSUFFICIENT_PERMISSIONS',
          message: '权限不足'
        }
      })
      return
    }

    next()
  }
}

// 管理员权限中间件
export const requireAdmin = requireRole(['ADMIN'])

// 编辑者或管理员权限中间件
export const requireEditor = requireRole(['EDITOR', 'ADMIN']) 