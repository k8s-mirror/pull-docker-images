## 部署 elasticsearch

1. 设置存储器

   ```sh
   kubectl apply -f elasticsearch/storage-class.yaml
   ```

2. 部署 ES

   ```sh
   kubectl apply -f elasticsearch/deploy-elasticsearch.yaml
   ```

3. 监控集群健康和创建进度

   ```sh
   kubectl get elasticsearch -n eck
   ```

4. 查看 Pod 状态

   ```sh
   kubectl get pods --selector='elasticsearch.k8s.elastic.co/cluster-name=elasticsearch' -n eck
   ```

5. 查看请求访问

   ```sh
   kubectl get service elasticsearch-es-http -n eck
   ```

6. 获得密码

   ```sh
   PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}' -n eck)
   ```

7. 集群里请求访问

   ```sh
   curl -u "elastic:$PASSWORD" -k "https://elasticsearch-es-http:9200"
   ```

8. 本地请求访问

   路由重定向

   ```sh
   kubectl port-forward service/elasticsearch-es-http 9200
   ```

   访问

   ```
   curl -u "elastic:$PASSWORD" -k "https://localhost:9200"
   ```

## 部署 Kibana 实例

1. 部署

   ```sh
   kubectl apply -f elasticsearch/deploy-kibana.yaml
   ```

2. 查看 pod

   ```sh
   kubectl get pod --selector='kibana.k8s.elastic.co/name=kibana' -n eck
   ```

3. 查看服务

   ```sh
   kubectl get service kibana-kb-http -n eck
   ```

4. 重定向端口到本地

   ```sh
   kubectl port-forward service/kibana-kb-http 5601 -n eck
   ```

5. 获取访问密码

   默认用户：elastic

   ```sh
   kubectl get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' -n eck | base64 --decode; echo
   ```

6. 访问

   浏览器打开 https://localhost:5601

## 部署 metricbeat

1. 部署

   ```sh
   kubectl apply -f elasticsearch/beats/metricbeat_hosts.yaml
   ```

2. 查看

   ```sh
   kubectl get beat -n eck
   ```

3. 查看 pod

   ```sh
   kubectl get pods --selector='beat.k8s.elastic.co/name=metricbeat' -n eck
   ```

4. 查看 pod 日志

   ```sh
   kubectl logs -f metricbeat-beat-metricbeat-bpzdr -n eck
   ```

5. 访问日志

   ```sh
   curl -u "elastic:$PASSWORD" -k "https://localhost:9200/metricbeat-*/_search"
   ```
