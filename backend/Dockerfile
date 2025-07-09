FROM node:22

WORKDIR /app

# 安装curl用于健康检查
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* && \
    npm cache clean --force

# 复制package文件
COPY package*.json ./

# 安装依赖
RUN npm install --production=false

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