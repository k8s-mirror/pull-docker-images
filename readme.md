# 通过 Travis CI 自动构建镜像到阿里云镜像库和 dockehub

> 发表于 2020-04-19 | 分类于 k8s | 阅读次数： 67 本文字数： 1.7k | 阅读时长 ≈ 2 分钟
> 应用： https://blog.flyfox.top/2020/04/19/%E9%80%9A%E8%BF%87Travis-CI%E8%87%AA%E5%8A%A8%E6%9E%84%E5%BB%BA%E9%95%9C%E5%83%8F%E5%88%B0%E9%98%BF%E9%87%8C%E4%BA%91%E9%95%9C%E5%83%8F%E5%BA%93%E5%92%8Cdockehub

其实之前我已经写过一篇关于通过阿里云镜像库下载 gcr.io 镜像的文章，但是该方法有一个问题，每次需要新的镜像都需要在阿里云镜像库手动创建，太麻烦了，这篇文章通过 Travis CI 可以自动构建镜像到阿里云，方便好用

## 创建 github 仓库

首先登录 github 创建一个仓库，名称自定义，仓库包含如下 2 个文件：

- **img-list.txt** 外网镜像列表文件
- **.travis.yaml** travisCI 自动构建文件

示例仓库：https://github.com/smartliby/pull-docker-images

.travis.yaml 内容如下，主要从国外镜像仓库 pull 镜像，打 tag，并 push 到阿里云或 dockerhub

```yml
language: bash

services:
  - docker

env:
  global:
    # change the registry name and username/password to yourself's.
    - DOCKER_HUB=smartliby
    - ALI_REGISTRY=registry.cn-hangzhou.aliyuncs.com/smartliby

before_script:
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - echo "$ALI_PASSWORD" | docker login "$ALI_REGISTRY" -u "$ALI_USERNAME" --password-stdin

script:
  - echo "start pull and retag and push"
  - |
    for image in $(cat img-list.txt)
    do
      image_name=${image##*/}
      image_name=${image_name%@*}
      docker pull $image
      docker tag $image $DOCKER_HUB/$image_name
      echo $ALI_REGISTRY
      docker tag $image $ALI_REGISTRY/$image_name

      # push到dockerhub
      docker push $DOCKER_HUB/$image_name
      # push到阿里云仓库
      docker push $ALI_REGISTRY/$image_name
    done
```

.travis.yaml 文件监测 github 仓库的代码变动，当有代码变动时比如 img-list.txt 写入新的镜像列表时将触发 tarvis 的自动构建
这里需要登录阿里云或 dockerhub 才能执行 docker push 操作，其中\$ALI_USERNAME 这类变量在 TravisCI 管理界面定义好即可。

## Travis CI 配置

访问 travis 官网： https://www.travis-ci.com， 使用 github 账号登录。

开启需要进行自动化构建的仓库并设置\$ALI_USERNAME 这类变量即可
![](https://blog.flyfox.top/images/media/%E9%80%89%E5%8C%BA_085.png)
当对 github 仓库执行 git commit、git push 操作时将自动触发构建，执行仓库中的脚本
![](https://blog.flyfox.top/images/media/%E9%80%89%E5%8C%BA_086.png)
登录阿里云或 dockerhub 查看，img-list.txt 列表中的镜像已经成功被 push 上来
![](https://blog.flyfox.top/images/media/%E9%80%89%E5%8C%BA_087.png)
![](https://blog.flyfox.top/images/media/%E9%80%89%E5%8C%BA_088.png)

## 参考

[1] https://blog.csdn.net/networken/article/details/84571373

![](https://blog.flyfox.top/images/wechat-qcode.jpg)
