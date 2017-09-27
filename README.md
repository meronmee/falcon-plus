# Falcon+


![Open-Falcon](./logo.png)

[![Build Status](https://travis-ci.org/open-falcon/falcon-plus.svg?branch=plus-dev)](https://travis-ci.org/open-falcon/falcon-plus)
[![codecov](https://codecov.io/gh/open-falcon/falcon-plus/branch/plus-dev/graph/badge.svg)](https://codecov.io/gh/open-falcon/falcon-plus)
[![GoDoc](https://godoc.org/github.com/open-falcon/falcon-plus?status.svg)](https://godoc.org/github.com/open-falcon/falcon-plus)
[![Code Issues](https://www.quantifiedcode.com/api/v1/project/5035c017b02c4a4a807ebc4e9f153e6f/badge.svg)](https://www.quantifiedcode.com/app/project/5035c017b02c4a4a807ebc4e9f153e6f)
[![Go Report Card](https://goreportcard.com/badge/github.com/open-falcon/falcon-plus)](https://goreportcard.com/report/github.com/open-falcon/falcon-plus)
[![License](https://img.shields.io/badge/LICENSE-Apache2.0-ff69b4.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)

<hr>

# Changelogs by Meorn
- redis增加密码支持
- 修改脚本及配置文件中所有数据库都带上falcon_前缀
- 脚本默认初始化root用户
- 增加初始化配置脚本init_server.sh和init_client.sh
- 整合进来dashboard

# Dashboard changelogs by Meorn ( Fork from [dashboard](https://github.com/open-falcon/dashboard))
- 只能管理员添加用户，不能自行注册
- 修改用户权限控制
- 登录后默认跳转到dashboard
- hostgroups->hosts添加改完选择，列表中的超链接改为提示
- 相关提示优化

# 整合版安装部署
## 准备
- 按照下面的编译方式打包生产： open-falcon-vx.x.x.tar.gz (以下使用open-falcon-v0.2.1.m2.tar.gz)
- redis,mysql

## 服务端
- 创建工作目录
```
export FALCON_HOME=/mnt/local/monitor
export WORKSPACE=$FALCON_HOME/open-falcon
mkdir -p $WORKSPACE
cd $FALCON_HOME
```

- 安装mysql和redis,如果已有这两项服务（不一定在同一台机器上）直接跳过

- 进入FALCON_HOME,将open-falcon-v0.2.1.m2.tar.gz上传到该目录下并解压
```
tar -xzvf open-falcon-v0.2.1.m2.tar.gz  -C $WORKSPACE
```

- 初始化数据库： $WORKSPACE/scripts/mysql/db_schema/*.sql
- 根据情况修改配置信息（ 先查看服务器端口占用情况） 
```
netstat -nltp|grep -E '1988|9080|9081|6090|6055|9912|6071|6070|16060|18433|14444|6060|8433|4444|6031|6030|6081|6080'

vi $WORKSPACE/init_server.sh

ufw allow 3306;ufw allow 6379;ufw allow 1988;ufw allow 9080;ufw allow 9081;ufw allow 6030;ufw allow 8433;
ufw allow 6090;ufw allow 6055;ufw allow 9912;ufw allow 6071;ufw allow 6070;ufw allow 16060;ufw allow 14444;ufw allow 18433;ufw allow 6060;ufw allow 4444;ufw allow 6031;ufw allow 6081;ufw allow 6080;
```

- 执行初始化脚本
```
$WORKSPACE/init_server.sh
```

- 启动所有组件
```
cd $WORKSPACE
./open-falcon start
```

- 检查各组件状态
```
cd $WORKSPACE
./open-falcon check
```

- 更多的命令行工具用法
```
# ./open-falcon [start|stop|restart|check|monitor|reload] module
Example:
./open-falcon start agent
For debugging , You can check $WorkDir/$moduleName/log/logs/xxx.log
```

**-----------------------------------dashboard-----------------------------------**

- 安装dashboard相关组件
```
apt-get install -y python-virtualenv;

apt-get install -y slapd ldap-utils;
输入admin密码123456

apt-get install -y libmysqld-dev;
apt-get install -y build-essential;
apt-get install -y python-dev libldap2-dev libsasl2-dev libssl-dev;

cd $WORKSPACE/dashboard/;ll;
virtualenv ./env;
./env/bin/pip install -r pip_requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

cd $WORKSPACE/dashboard/
启动dashboard
bash control start
停止dashboard
bash control stop
查日志
bash control tail
```

## 客户端
- 创建工作目录
```
export FALCON_HOME=/mnt/local/monitor
export WORKSPACE=$FALCON_HOME/open-falcon
mkdir -p $WORKSPACE
cd $FALCON_HOME
```

- 进入FALCON_HOME,将open-falcon-v0.2.1.m2.tar.gz上传到该目录下并解压
```
tar -xzvf open-falcon-v0.2.1.m2.tar.gz  -C $WORKSPACE
```

- 根据情况修改配置信息（ 先查看服务器端口占用情况） 
````
netstat -nltp|grep -E '1988'

vi $WORKSPACE/init_client.sh

ufw allow 1988;
````

- 执行初始化脚本
```
$WORKSPACE/init_client.sh
```

- 启动Agent
```
cd $WORKSPACE
./open-falcon start agent
```

- 检查Agent状态
```
cd $WORKSPACE
./open-falcon check
./agent/bin/falcon-agent --check
```

- 更多的命令行工具用法
```
./open-falcon start agent  启动进程
./open-falcon stop agent  停止进程
./open-falcon monitor agent  查看日志
```

<hr>

# Documentations

- [Usage](http://book.open-falcon.org)
- [Open-Falcon API](http://open-falcon.org/falcon-plus)

# Prerequisite

- Git >= 1.7.5
- Go >= 1.6

# Getting Started

## Docker

Please refer to ./docker/[README.md](https://github.com/open-falcon/falcon-plus/blob/master/docker/README.md).

## Build from source
**before start, please make sure you prepared this:**

```
yum install -y redis
yum install -y mysql-server

```

*NOTE: be sure to check redis and mysql-server have successfully started.*

And then

```
# Please make sure that you have set `$GOPATH` and `$GOROOT` correctly.
# If you have not golang in your host, please follow [https://golang.org/doc/install] to install golang.

mkdir -p $GOPATH/src/github.com/open-falcon
cd $GOPATH/src/github.com/open-falcon
git clone https://github.com/open-falcon/falcon-plus.git

```

**And do not forget to init the database first (if you have not loaded the database schema before)**

```
cd $GOPATH/src/github.com/open-falcon/falcon-plus/scripts/mysql/db_schema/
mysql -h 127.0.0.1 -u root -p < 1_uic-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 2_portal-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 3_dashboard-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 4_graph-db-schema.sql
mysql -h 127.0.0.1 -u root -p < 5_alarms-db-schema.sql
```

**NOTE: if you are upgrading from v0.1 to current version v0.2.0,then**. [More upgrading instruction](http://www.jianshu.com/p/6fb2c2b4d030)

    mysql -h 127.0.0.1 -u root -p < 5_alarms-db-schema.sql

# Compilation

```
cd $GOPATH/src/github.com/open-falcon/falcon-plus/

# make all modules
make all

# make specified module
make agent

# pack all modules
make pack
```

* *after `make pack` you will got `open-falcon-vx.x.x.tar.gz`*
* *if you want to edit configure file for each module, you can edit `config/xxx.json` before you do `make pack`*

#  Unpack and Decompose

```
export WorkDir="$HOME/open-falcon"
mkdir -p $WorkDir
tar -xzvf open-falcon-vx.x.x.tar.gz -C $WorkDir
cd $WorkDir
```

# Start all modules in single host
```
cd $WorkDir
./open-falcon start

# check modules status
./open-falcon check

```

# Run More Open-Falcon Commands

for example:

```
# ./open-falcon [start|stop|restart|check|monitor|reload] module
./open-falcon start agent

./open-falcon check
        falcon-graph         UP           53007
          falcon-hbs         UP           53014
        falcon-judge         UP           53020
     falcon-transfer         UP           53026
       falcon-nodata         UP           53032
   falcon-aggregator         UP           53038
        falcon-agent         UP           53044
      falcon-gateway         UP           53050
          falcon-api         UP           53056
        falcon-alarm         UP           53063
```

* For debugging , You can check `$WorkDir/$moduleName/log/logs/xxx.log`

# Install Frontend Dashboard
- Follow [this](https://github.com/open-falcon/dashboard).

**NOTE: if you want to use grafana as the dashboard, please check [this](https://github.com/open-falcon/grafana-openfalcon-datasource).**

# Package Management

We use govendor to manage the golang packages. Please install `govendor` before compilation.

    go get -u github.com/kardianos/govendor

Most depended packages are saved under `./vendor` dir. If you want to add or update a package, just run `govendor fetch xxxx@commitID` or `govendor fetch xxxx@v1.x.x`, then you will find the package have been placed in `./vendor` correctly.

# Package Release

```
make clean all pack
```

# Q&A

- Any issue or question is welcome, Please feel free to open [github issues](https://github.com/open-falcon/falcon-plus/issues) :)
- [FAQ](https://book.open-falcon.org/zh_0_2/faq/)

