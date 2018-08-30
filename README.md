# Delete-RS-K8S
#### clean_rs.sh 脚本为清除k8s中单namespace下的多余的rs，清除机制为保存最近5次
* clean_rs.sh 脚本中需要手动修改lilei2为你想要清除的namespace名字
#### clean_rs_new.sh 脚本为清除k8s集群中所有namespaces下的rs，清除机制为保存最近5次
* 不需要做任何修改，只要有kubectl命令，以及拥有k8s集群权限即可
#### 利用crontab创建自己想要的定时任务
