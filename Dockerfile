# 使用 nginx 镜像作为基础
FROM nginx:alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories 

# 安装 runit 和 Node.js
RUN apk add --update --no-cache \
    runit \
    nodejs \
    npm \
    openssl \
    curl && \
    npm install -g markdown-editor-server

RUN npm config set registry https://mirrors.cloud.tencent.com/npm/

# 设置工作目录
WORKDIR /app

# 创建 runit 服务目录结构
RUN mkdir -p /etc/service/nginx /etc/service/markdown-server /etc/sv/nginx /etc/sv/markdown-server

# 创建用于存放密码文件和 Nginx 配置的目录
RUN mkdir -p /etc/nginx/auth /etc/nginx/conf.d
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
# 复制自定义的 Nginx 配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf


# 创建 markdown-server 的 runit 服务脚本
RUN echo '#!/bin/sh' > /etc/service/markdown-server/run && \
    echo 'exec markdown-editor-server' >> /etc/service/markdown-server/run && \
    chmod +x /etc/service/markdown-server/run

# 创建认证设置脚本
COPY setup-auth.sh /app/setup-auth.sh 
RUN chmod +x /app/setup-auth.sh 


# 创建 nginx 的 runit 服务脚本
COPY nginx-run.sh  /etc/service/nginx/run 
RUN  chmod +x /etc/service/nginx/run


# 创建运行目录和必要的目录
RUN mkdir -p /app/docs && \
    mkdir -p /var/run/runit && \
    mkdir -p /var/run/runit/supervise

# 声明 Markdown 服务器运行的端口（Nginx 默认使用 80）
ENV NOTE_STORAGE_PATH=/app/docs
# 设置认证用户名和密码的环境变量
ENV BASIC_AUTH_USER=admin
ENV BASIC_AUTH_PASSWORD=admin123
ENV APP_PORT=3000

# 设置 volumes
VOLUME ["/app/docs"]

# 使用 runsvdir 启动所有服务
CMD ["runsvdir", "/etc/service"]