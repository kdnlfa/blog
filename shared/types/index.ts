// ============ 基础类型 ============
export interface BaseEntity {
  id: string
  createdAt: string
  updatedAt: string
}

// ============ 用户相关类型 ============
export interface User extends BaseEntity {
  name: string
  email: string
  avatar?: string
  bio?: string
  role: UserRole
  isActive: boolean
}

export type UserRole = 'admin' | 'author' | 'reader'

export interface AuthUser {
  id: string
  name: string
  email: string
  avatar?: string
  role: UserRole
}

// ============ 博客内容类型 ============
export interface Post extends BaseEntity {
  title: string
  content: string
  excerpt: string
  slug: string
  publishedAt?: string
  featuredImage?: string
  author: Author
  category: Category
  tags: Tag[]
  status: PostStatus
  seo: PostSEO
  stats: PostStats
}

export type PostStatus = 'draft' | 'published' | 'archived'

export interface PostSEO {
  metaTitle?: string
  metaDescription?: string
  keywords?: string[]
  ogImage?: string
}

export interface PostStats {
  views: number
  likes: number
  comments: number
  readingTime: number // 分钟
}

export interface Author extends BaseEntity {
  name: string
  email: string
  avatar?: string
  bio?: string
  website?: string
  social?: SocialLinks
}

export interface SocialLinks {
  github?: string
  twitter?: string
  linkedin?: string
  website?: string
}

export interface Category extends BaseEntity {
  name: string
  slug: string
  description?: string
  color?: string
  icon?: string
  postCount?: number
}

export interface Tag extends BaseEntity {
  name: string
  slug: string
  color?: string
  postCount?: number
}

// ============ 评论系统类型 ============
export interface Comment extends BaseEntity {
  content: string
  author: CommentAuthor
  postId: string
  parentId?: string // 回复功能
  replies?: Comment[]
  status: CommentStatus
  isApproved: boolean
}

export type CommentStatus = 'pending' | 'approved' | 'rejected' | 'spam'

export interface CommentAuthor {
  name: string
  email: string
  website?: string
  avatar?: string
  isRegistered: boolean
}

// ============ API相关类型 ============
export interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

export interface PaginatedResponse<T> {
  data: T[]
  pagination: Pagination
}

export interface Pagination {
  page: number
  pageSize: number
  total: number
  totalPages: number
  hasNext: boolean
  hasPrev: boolean
}

export interface ApiError {
  code: string
  message: string
  details?: any
}

// ============ 查询参数类型 ============
export interface PostQuery {
  page?: number
  pageSize?: number
  category?: string
  tag?: string
  status?: PostStatus
  search?: string
  author?: string
  sortBy?: 'createdAt' | 'publishedAt' | 'title' | 'views'
  sortOrder?: 'asc' | 'desc'
}

export interface CategoryQuery {
  page?: number
  pageSize?: number
  search?: string
}

export interface TagQuery {
  page?: number
  pageSize?: number
  search?: string
}

// ============ 表单类型 ============
export interface PostCreateForm {
  title: string
  content: string
  excerpt?: string
  categoryId: string
  tagIds: string[]
  featuredImage?: string
  status: PostStatus
  publishedAt?: string
  seo: PostSEO
}

export interface PostUpdateForm extends Partial<PostCreateForm> {
  id: string
}

export interface CategoryForm {
  name: string
  description?: string
  color?: string
  icon?: string
}

export interface TagForm {
  name: string
  color?: string
}

export interface CommentForm {
  content: string
  author: {
    name: string
    email: string
    website?: string
  }
  postId: string
  parentId?: string
}

export interface UserForm {
  name: string
  email: string
  bio?: string
  avatar?: string
  social?: SocialLinks
}

// ============ 组件Props类型 ============
export interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger'
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  loading?: boolean
  disabled?: boolean
  fullWidth?: boolean
  children: React.ReactNode
  onClick?: () => void
  type?: 'button' | 'submit' | 'reset'
  className?: string
}

export interface InputProps {
  label?: string
  placeholder?: string
  error?: string
  helperText?: string
  required?: boolean
  disabled?: boolean
  type?: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url'
  value?: string
  onChange?: (value: string) => void
  className?: string
}

export interface CardProps {
  children: React.ReactNode
  padding?: 'none' | 'sm' | 'md' | 'lg'
  shadow?: 'none' | 'sm' | 'md' | 'lg'
  border?: boolean
  hover?: boolean
  className?: string
}

// ============ 布局类型 ============
export interface LayoutProps {
  children: React.ReactNode
  title?: string
  description?: string
  keywords?: string[]
  ogImage?: string
  noIndex?: boolean
}

export interface HeaderProps {
  navigation?: NavigationItem[]
  user?: AuthUser | null
  onMenuToggle?: () => void
}

export interface NavigationItem {
  name: string
  href: string
  icon?: React.ComponentType<any>
  badge?: string | number
  children?: NavigationItem[]
}

// ============ 搜索类型 ============
export interface SearchResult {
  posts: Post[]
  categories: Category[]
  tags: Tag[]
  totalResults: number
}

export interface SearchFilters {
  type?: 'all' | 'posts' | 'categories' | 'tags'
  dateRange?: {
    start: string
    end: string
  }
  category?: string
  tags?: string[]
}

// ============ 统计类型 ============
export interface DashboardStats {
  totalPosts: number
  totalViews: number
  totalComments: number
  totalUsers: number
  recentPosts: Post[]
  popularPosts: Post[]
  topCategories: Category[]
  monthlyViews: MonthlyStats[]
}

export interface MonthlyStats {
  month: string
  views: number
  posts: number
  comments: number
}

// ============ 文件上传类型 ============
export interface FileUpload {
  file: File
  preview?: string
  progress: number
  status: 'pending' | 'uploading' | 'success' | 'error'
  error?: string
}

export interface UploadedFile {
  id: string
  filename: string
  originalName: string
  mimetype: string
  size: number
  url: string
  uploadedAt: string
}

// ============ 主题类型 ============
export interface ThemeConfig {
  mode: 'light' | 'dark' | 'system'
  primaryColor: string
  accentColor: string
  fontFamily: string
  fontSize: 'sm' | 'md' | 'lg'
}

// ============ 站点配置类型 ============
export interface SiteConfig {
  title: string
  description: string
  url: string
  logo?: string
  favicon?: string
  author: Author
  social: SocialLinks
  analytics?: {
    googleAnalyticsId?: string
    baiduAnalyticsId?: string
  }
  seo: {
    defaultTitle: string
    titleTemplate: string
    defaultDescription: string
    defaultKeywords: string[]
    defaultOgImage: string
  }
} 