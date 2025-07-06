# 个人博客项目 - 设计系统指南

## 设计系统概述

设计系统是一套可重用的组件、设计规范和开发指南，确保整个应用的一致性和可维护性。

## 项目结构

```
blog/
├── frontend/
│   ├── components/
│   │   ├── ui/              # 基础UI组件（原子级）
│   │   ├── layout/          # 布局组件（分子级）
│   │   ├── blog/            # 业务组件（有机体级）
│   │   └── pages/           # 页面级组件
│   ├── lib/
│   │   ├── utils.ts         # 工具函数
│   │   └── constants.ts     # 常量定义
│   └── styles/
│       └── globals.css      # 全局样式
├── backend/
└── shared/
    └── types/               # 共享类型定义
```

## 设计系统层级

### 1. 原子级组件 (Atoms)
- Button, Input, Label, Icon
- 最小的UI构建块，不可再分

### 2. 分子级组件 (Molecules)  
- SearchBox, FormField, Card
- 由多个原子组件组合而成

### 3. 有机体级组件 (Organisms)
- Header, PostList, Sidebar
- 由分子和原子组件组成的复杂组件

### 4. 模板级组件 (Templates)
- PageLayout, BlogLayout
- 定义页面结构和布局

### 5. 页面级组件 (Pages)
- HomePage, PostPage, AboutPage
- 具体的页面实现 