# 2020 年 Kubernetes GUI 客户端 : kube-dashboard, Lens, Octant 和 kubenav

> https://medium.com/dictcp/kubernetes-gui-clients-in-2020-kube-dashboard-lens-octant-and-kubenav-ce28df9bb0f0

Kubernetes 是近几年一个在容器业务流程平台上领先的标准之一.
而每 Kubernetes 系统管理员都熟悉它的命令行客户端，kubectl.
我是几年它的粉丝.
即使它是如此强大, 这是很难用它来了解整个集群 没有交互式用户界面和数据可视化.
与此同时, kubectl 的学习曲线可能阻止采用 Kubernetes 每一个初级开发者, 尤其是并不是每个人都在记住每一个命令行语句很感兴趣 开始使用 Kubernetes 前.
于是, 我会选择一些 Kubernetes UI 客户, 有一些我自己的选择标准 (虽然不是每个选定的客户端覆盖所有).

- 易于使用

  请确保它是不是很难使用, 即使是新人, 因为 Kubernetes 概念本身已经不是一个简单的.

- 多平台支持

  虽然我的主要工作环境的 MacOS, 我也是一个沉重的 Ubuntu / ChromeOS 的用户.
  我更喜欢一个工具，可以在多个平台上运行.

- 资源 YAML manifests 观看 (和编辑)
- Pod 查看日志 (和命令执行)
- 聚集度量支持 (Prometheus 统计)
- CRD (自定义资源的定义) 支持

  如今，社区通过操作框架扩展 Kubernetes (看到 OperatorHub) 和 那些实现需要存储在自定义资源的配置 (CRD) (此处详细了解).
  CRD 的支持是（几乎）是在这个现代 Kubernetes 世界必须.

有入围 (同 tl;dr):

- Kubernetes Dashboard (kube-dashboard) [最成熟和流行]
- Lens [最强大的一个]
- Octant [易于安装和最便携]
- kubenav [Android 和 iOS 支持]

## Kubernetes Dashboard (kube-dashboard)

![Image for post](https://miro.medium.com/max/1400/1*sD0LKJ3JeGZ-2AQT7HjdSg.png)

Kubernetes Dashboard 是目前最流行和成熟的 Kubernetes GUI 客户端.
此网页 UI 页面提供的应用程序的概述群集上运行, 以及创建或修改个人 Kubernetes 资源.
相对于其他客户喜欢`Lens`和`Octant`, 其过滤能力是有限.
您无法通过标签筛选资源.
由于 Kubernetes 仪表板必须安装到您的 Kubernetes 集群，你需要处理用户登录和访问权限问题.
但是建立这个网站托管用户界面的相关认证不是那么简单.
它的默认设置需要您登录通过输入令牌或每次上传 KubeConfig 文件.
有些教程 (例如。这个) 建议注入的 OAuth2 反向代理在前面简化登录过程.
简而言之, 这将是伟大正确设置它为一个团队 (用统一的管理界面), 但很麻烦，如果你是系统中的唯一一个用户.
此外，由于代码程序的谷歌暑期, 最初的工作 CRD 支持在 2017 年开始 后来有人合并到上游.
该 CRD（自定义资源定义）的支持，最终包括在最近的测试版本（2.0.0-beta8）。
将其安装（您 Kubernetes 集群）,

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml# ref: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui
```

## Lens

![Image for post](https://miro.medium.com/max/1400/1*N2TmMYRqfCcHrYErZJ9JNA.png)

Lens 是一个 Electron-based 应用 (支持 Windows, macOS, Linux).
它最初是由 Kontena 开发, 最近被释放 Mirantis 收购后的一个开源项目.
这是我用过的强大 Kubernetes UI 之一.
它支持 CRD 和 Helm3 (罕见的因为它被释放最近, 其他客户端上几乎没有任何支持).
除了非常强大的 GUI, 你还可以调用其内置的终端和执行自己喜欢的 kubectl 命令 — 和 Lens 将处理集群设置为你.
它是如此高兴，我取代 kubectl 它使用它几个小时后，.
我遇到的唯一问题是'Electron` GPU 进程的内存泄漏。
要安装它 (下 macOS),

```sh
brew casks install lens
```

## Octant

![Image for post](https://miro.medium.com/max/1400/1*JomAqVVf8AXpI8c768SibQ.gif)

Octant ,在 VMware 开源程序, 是一个 Web UI 开发人员了解 Kubernetes 群发生了什么.
它几乎不需要任何安装(只是 Golang 二进制在客户端) 并从~/.kube/config /\$KUBECONFIG 读取本地集群设置 .
它是如此的轻便，你可能在你的树莓派运行 (since it is shipped with Linux ARM binary).
There is also a developer friendly feature: creating port forwards through its intuitive interface.

![Image for post](https://miro.medium.com/max/1400/1*6NqUfPC8y-FCM7Eyll2RiQ.png)

从这个工具唯一的缺点是，, 资源 YAML 舱单是只读，无法通过八分编辑.
这是不正常的一个主要问题，如果你是通过 Git 的变化下提供舱单 (aka. GitOps).
但它是相当麻烦的时候有生产问题和即席 YAML 编辑需要.
要安装它 (下 macOS),

```sh
brew install octant
octant
```

## kubenav

![Image for post](https://miro.medium.com/max/1400/1*aD1lluqB0Pl2RMYvQkN_gg.png)

kubenav 是一个非常年轻的项目 (第一次提交是 2020 年 1 月) 但它的目标几乎每一个平台(Windows, macOS, Linux, Android and iOS) 通过`Ionic`框架基础.
并且它是 Kubernetes 唯一的 Android 手机客户端. (有来自 Skippbox 是`Cabin`, 但它已被废弃了，因为它是由 Bitnami 收购).
由于该项目处于非常早期的阶段，特征是不一样丰富等项目 (例如。没有 YAML manifests 编辑, 没有聚集度量的可视化) 和错误预期 (尤其是当创建/导入集群).
例如，它不支持基本身份验证登录 (其在缺省情况下都 microk8s 和 k3s 使用) 第 1 天(固定版本 1.3.0).
但其背后的开发人员正在努力工作，我们可以期待一个更完整的产品很快交付。
您可以在 Android / iOS 移动设备上安装，或者安装它（在 MacOS），你可能

- 从https://kubenav.io/这里下载 , 要么
- 通过我个人的自制软件龙头

```sh
brew tap dictcp/tap
brew cask install kubenav
```

## Summary

我现在用上述 4 个工具不同的使用情况

- Kubernetes Dashboard: 我的公司
- Lens: 在 Kubernetes IDE 上我的 MacBook Pro，
- Octant: 首选 UI 客户端/仪表板在训练新人,
- kubenav: 安装在我的手机, 对于一些快速故障排除，以我个人的 Kubernetes 集群.

## 参考

也有几篇文章在谈论 Kubernetes UI 客户端.

- https://srcco.de/posts/kubernetes-web-uis-in-2019.html
- https://www.virtuallyghetto.com/2020/04/useful-interactive-terminal-and-graphical-ui-tools-for-kubernetes.html
