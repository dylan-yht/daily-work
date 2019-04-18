## 搭建Registry
> 服务器ip为：172.16.77.71


安装Docker Registry，Docker版本需要1.6以上
	
	[root@k8s-77-71 ~]# docker --version
	Docker version 18.06.1-ce, build e68fc7a
	
 docker官方给提供了Registry的镜像  直接拉取

	[root@k8s-77-71 ~]# docker pull registry
	
### 启动容器
> 默认情况下，会将仓库存放于容器内的/var/lib/registry（官网Dockerfile中查看）目录下
以防容器出问题导致镜像丢失，我们将挂载本地目录到容器的/var/lib/registry下

	docker run -itd  --restart always --name docker-hub -p 5000:5000 -v /opt/data/registry:/var/lib/registry registry

 查看私有仓库  目前没有存储镜像 所以显示为空
 
 	curl -XGET 127.0.0.1:5000/v2/_catalog
 
 查看镜像版本列表
 
 	curl -XGET 127.0.0.1:5000/v2/image_name/tags/list
 	
 
### push镜像到私有仓库
	
	[root@k8s-77-71 ~]# docker tag  mingo 172.16.77.71:5000/mongo
	[root@k8s-77-71 ~]# docker push 172.16.77.71:5000/mongo:latest
	
###  其他机器配置连接私有仓库
每台机器 docker 私有仓库配置vi /etc/docker/daemon.json写入以下内容：

	{
  		"insecure-registries": [
    		"172.16.77.71:5000"
  		]
	}
	
然后重启docker

	sudo systemctl   daemon-reload
	systemctl restart docker.service
	
注：如果配置多个私有仓库，daemon.json中用“,”隔开

### 可能出现错误

在别的机器上往私有仓库push时可能会出现以下错误
	
	error parsing HTTP 400 response body: invalid character 'F' looking for beginning of value: "Failed parsing or buffering the chunk-encoded client body.\r\n"

初步判断应该是docker使用代理导致，解决办法：vim  /etc/systemd/system/docker.service.d/http-proxy.conf

    [Service]
	Environment="HTTP_PROXY=http://172.16.77.36:8118/" "HTTPS_PROXY=http://	172.16.77.36:8118" "NO_PROXY=172.16.7.222,172.16.77.71,127.0.0.1,localhost"
	
重启daemon
	
	sudo systemctl   daemon-reload 
	
查看参数是否生效

	sudo  systemctl show docker --property Environment
	
重启服务

	sudo systemctl  restart docker
	
重新push

## 设置私有仓库的用户认证
> 私有仓库搭建以后其他所有客户端均可以push、pull， docker官方提供认证方法对docker仓库进行权限保护

删除原启动的docker容器

	docker stop docker-hub
	docker rm docker-hub
	
创建保存账号密码的文件

	mkdir  /opt/data/auth
	docker run  --entrypoint htpasswd registry -Bbn  username  userpasswd > auth/htpasswd
	
重新启动容器
	
	docker run -d -p 5000:5000 --restart=always --name docker-hub \
  		-v /opt/data/registry:/var/lib/registry \
  		-v /opt/data/auth:/auth \
  		-e "REGISTRY_AUTH=htpasswd" \
  		-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  		-e  REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  		registry
  		
现在客户端再pull、push会提示报错，无法提交。需要登录私有仓库
登录：docker login -u username -p userpasswd 172.16.77.71:5000
退出：docker logout 172.16.77.71:5000
认证以后无法直接在服务器查看 curl 172.16.77.71:5000/v2/_catalog仓库的镜像，会出现报错，但是可以用浏览器访问（界面不友好，能看到信息很少）

参考文档：

[http://blog.chinaunix.net/uid-23500957-id-5784564.html](http://blog.chinaunix.net/uid-23500957-id-5784564.html)

[https://www.jianshu.com/p/7918c9af45a3](https://www.jianshu.com/p/7918c9af45a3)