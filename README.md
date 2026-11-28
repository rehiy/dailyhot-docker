# 今日热榜

聚合各平台热点数据的单容器镜像，包含 DailyHot 前端、DailyHotApi、Nginx 和 Redis。

## 快速启动

```sh
docker run -d --name dailyhot --restart unless-stopped -p 80:80 \
    -e APP_ICP="京备ICP12345" \
    -e APP_COPYRIGHT="Example" \
    -e APP_COPYRIGHT_URL="https://www.example.org" \
    rehiy/dailyhot:latest
```

浏览器访问 `http://localhost/` 查看热榜，访问 `http://localhost/api/all` 查看接口列表。

镜像支持 Linux AMD64 和 ARM64；Node.js 使用 22 系列。Redis 仅监听容器内回环地址，用于非持久化缓存。

## 配置

| 环境变量 | 默认值 | 说明 |
| --- | --- | --- |
| APP_ICP | 空 | ICP 备案信息 |
| APP_COPYRIGHT | Example | 页脚署名 |
| APP_COPYRIGHT_URL | http://www.example.org | 页脚链接 |

前端配置值使用普通单行文本。后端支持上游 API 的缓存时长、请求超时及 Cookie 等环境变量。

## 构建与更新

`versions.env` 记录前端、后端的确切上游 Git Commit。依赖按上游 pnpm 锁文件安装。

```sh
docker build --pull -t dailyhot:local .
./scripts/smoke-test.sh linux/amd64 dailyhot:local
```

GitHub Actions 使用 AMD64 和 ARM64 原生 Runner 分别构建并运行容器测试，不依赖 QEMU 模拟。主分支更新、手动触发及每周定时任务在两个架构均通过测试后，发布已验证的镜像并合并多架构 manifest。

定时任务每周一 03:25 UTC（北京时间 11:25）检查上游并重新构建，以获取基础镜像和系统软件更新。手动运行主分支工作流也会检查上游版本。上游 Commit 发生变化时，仅在镜像成功发布后提交新的版本记录。

Docker Hub 发布标签：

- `latest`：最新通过验证的双架构镜像。
- `build-<run_id>-<run_attempt>`：对应具体流水线运行的镜像。

镜像 OCI 标签（labels）中同时记录前端和后端的 Git Commit。发布需配置仓库 Secrets `DOCKER_USERNAME`、`DOCKER_PASSWORD`，PR 不使用发布凭据。

## 上游项目

- [DailyHot](https://github.com/imsyy/DailyHot)
- [DailyHotApi](https://github.com/imsyy/DailyHotApi)
