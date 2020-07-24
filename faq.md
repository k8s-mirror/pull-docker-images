# 常见问题

> https://my.oschina.net/u/1464083/blog/2996853/print

## 报认证错误

[error]: config error file="/etc/fluent/fluent.conf" error="Invalid Kubernetes API v1 endpoint https://172.21.0.1:443/api: SSL_connect returned=1 errno=0 state=error: certificate verify failed"

1. 创建配置文件 fluentd-conf

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-conf
  namespace: kube-system
data:
  fluentd-conf: |
    <match fluent.**>
      type null
    </match>
    <source>
      type tail
      path /var/log/containers/*.log
      pos_file /var/log/es-containers.log.pos
      time_format %Y-%m-%dT%H:%M:%S.%NZ
      tag kubernetes.*
      format json
      read_from_head true
    </source>
    <filter kubernetes.**>
      type kubernetes_metadata
      verify_ssl false
    </filter>
```

运行

```sh
kubectl apply -f knative/fluentd-conf.yaml
```

2. 编辑守护进程
   在数据卷->添加本地存储

   1. 存储类型->配置项
   2. 挂载源->fluentd-conf
   3. 容器路径： /etc/fluent/

保存后更新
