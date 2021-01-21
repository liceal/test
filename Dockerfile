# 引入node
FROM node:latest as js_builder

# 打包项目生成dict
COPY . /build
WORKDIR /build
RUN npm install --registry https://registry.npm.taobao.org
RUN npm run build

# 引入nginx
FROM nginx:latest

# 将dist文件夹 复制到 /usr/share/nginx/html 下
# 分段构建 --from=上面的FROM镜像内的 build/dist 包含WORKDIR
COPY --from=js_builder build/dist/ /usr/share/nginx/html/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
# COPY --from=js-builder /opt/web/dist /usr/share/nginx/html/web
# CMD ["nginx", "-g", "daemon off;"]