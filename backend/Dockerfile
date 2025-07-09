FROM node:22-alpine

WORKDIR /app

# 安装必要工具
RUN apk add --no-cache curl python3 make g++ && \
    npm cache clean --force

# 复制package文件
COPY package*.json ./

# 清理并安装依赖
RUN npm config set fetch-timeout 300000 && \
    npm config set fetch-retry-maxtimeout 300000 && \
    npm install --verbose --production=false

# 复制Prisma配置
COPY prisma ./prisma/

# 生成Prisma client
RUN npx prisma generate

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 暴露端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# 启动命令
CMD ["npm", "start"]