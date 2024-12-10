# 今日热榜

**汇聚全网热点，热门尽览无余**，今日热榜可以为用户提供最新、最热门的信息，尽览各大平台热点，轻松掌握时事动态。该平台整合了互联网上各个领域的热门话题，涵盖新闻、娱乐、科技、社会等多个方面，用户无需漫游多个平台，即可获取丰富多彩的信息。

## 快速启动

使用如下代码启动后，浏览器打开 <http://www.example.org> 查看WEB界面，打开 <http://www.example.org/api/all> 查看所有接口。

```shell
docker run -d -p 80 \
    -e APP_ICP="京备ICP12345" \
    -e APP_COPYRIGHT="Example" \
    -e APP_COPYRIGHT_URL="http://www.example.org" \
    rehiy/dailyhot
```

## 主要更新

- 合并前端和后端到一个容器
- 支持修改前端参数

## 其他

感谢上游源码维护者的无私奉献，赠人玫瑰、手留余香。

- <https://github.com/imsyy/DailyHot>
- <https://github.com/imsyy/DailyHotApi>
