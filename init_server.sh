#!/bin/bash 
# *******************************************************
# 
#       Filename: init_server.sh
#
#         Author: meronmee
#        Version: v0.2.1.m3
#         Create: 2017-09-19 20:05:22
#  Last Modified: 2017-09-20 10:14:04
#    Description: 初始化falcon服务端各种配置信息
#    本脚本适用条件：所有服务端组件都部署在一台服务器上
# *******************************************************


# =============以下配置项只能修改，不能删除============
# 工作目录
home=/mnt/local/monitor
workspace=$home/open-falcon

cd $workspace;

# 本机hostname
hostname=test.192.168.1.100
# 本机IP，设为空字符串Agent会自动探测本机IP
hostip=""

# 数据库配置信息
db_host=192.168.1.100
db_port=3306
db_user=root
db_password=123456

# redis 配置信息
redis_host=192.168.1.100
redis_port=6379
redis_password=123456

#API Token
api_token="default-token-used-in-server-side";

# 报警消息api(路径中的斜杠/必须转义)
alarm_msg_api_wx="http:\/\/192.168.1.100\/api\/wxmsg.json"
alarm_msg_api_sms="http:\/\/192.168.1.100\/api\/sms.json"
alarm_msg_api_mail="http:\/\/192.168.1.100\/api\/mail.json"

# 各组件端口
port_agent=1988
port_api=9080
port_dashboard=9081
port_nodata=6090
port_aggregator=6055
port_alarm=9912

port_graph_http=6071
port_graph_rpc=6070

port_gateway_http=16060
port_gateway_rpc=18433
port_gateway_socket=14444

port_transfer_http=6060
port_transfer_rpc=8433
port_transfer_socket=4444

port_hbs_http=6031
port_hbs_rpc=6030

port_judge_http=6081
port_judge_rpc=6080


# ===================以下代码请勿修改====================
# 配置文件路径
cfg_agent=$workspace/agent/config/cfg.json
cfg_aggregator=$workspace/aggregator/config/cfg.json
cfg_alarm=$workspace/alarm/config/cfg.json
cfg_api=$workspace/api/config/cfg.json
cfg_gateway=$workspace/gateway/config/cfg.json
cfg_graph=$workspace/graph/config/cfg.json
cfg_hbs=$workspace/hbs/config/cfg.json
cfg_judge=$workspace/judge/config/cfg.json
cfg_nodata=$workspace/nodata/config/cfg.json
cfg_transfer=$workspace/transfer/config/cfg.json

cfg_dashboard=$workspace/dashboard/rrd/config.py
cfg_dashboard_wsgi=$workspace/dashboard/wsgi.py
cfg_dashboard_gunicorn=$workspace/dashboard/gunicorn.conf


# 数据库配置信息统一修改
echo "配置数据库信息..."
grep -ilr "3306"  $workspace/ | xargs -n1 -- sed -i "s/root:@tcp(127.0.0.1:3306)/$db_user:$db_password@tcp($db_host:$db_port)/g";
# 单独修改方式如下：
# sed -i "/root:@tcp(127.0.0.1:3306)/s/root:@tcp(127.0.0.1:3306)/$db_user:$db_password@tcp($db_host:$db_port)/g" "$cfg_aggregator";

# 各组件配置信息修改
# ----------------------agent-----------------------------
echo "配置 agent 信息[$cfg_agent]..."
sed -i "/hostname/s/myhost/$hostname/g" "$cfg_agent";
sed -i "/myip/s/myip/$hostip/g" "$cfg_agent";
sed -i "/1988/s/1988/$port_agent/g" "$cfg_agent";
sed -i "/6030/s/6030/$port_hbs_rpc/g" "$cfg_agent";
sed -i "/8433/s/8433/$port_transfer_rpc/g" "$cfg_agent";

# ----------------------aggregator------------------------
echo "配置 aggregator 信息[$cfg_aggregator]..."
sed -i "/6055/s/6055/$port_aggregator/g" "$cfg_aggregator";
sed -i "/1988/s/1988/$port_agent/g" "$cfg_aggregator";
sed -i "/8080/s/8080/$port_api/g" "$cfg_aggregator";
sed -i "s/default-token-used-in-server-side/$api_token/g" "$cfg_aggregator";

# ----------------------alarm-----------------------------
echo "配置 alarm 信息[$cfg_alarm]..."
sed -i "/9912/s/9912/$port_alarm/g" "$cfg_alarm";
sed -i "/6379/s/127.0.0.1:6379/$redis_host:$redis_port/g" "$cfg_alarm";
sed -i "/redispass/s/redispass/$redis_password/g" "$cfg_alarm";
sed -i "/8080/s/8080/$port_api/g" "$cfg_alarm";
sed -i "/8081/s/8081/$port_dashboard/g" "$cfg_alarm";
sed -i "/http.*wechat/s/http.*wechat/$alarm_msg_api_wx/g" "$cfg_alarm";
sed -i "/http.*sms/s/http.*sms/$alarm_msg_api_sms/g" "$cfg_alarm";
sed -i "/http.*mail/s/http.*sms/$alarm_msg_api_mail/g" "$cfg_alarm";
sed -i "s/default-token-used-in-server-side/$api_token/g" "$cfg_alarm";

# -----------------------api------------------------------
echo "配置 api 信息[$cfg_api]..."
sed -i "/8080/s/8080/$port_api/g" "$cfg_api";
sed -i "/6070/s/6070/$port_graph_rpc/g" "$cfg_api";
sed -i "s/default-token-used-in-server-side/$api_token/g" "$cfg_api";

# ----------------------gateway---------------------------
echo "配置 gateway 信息[$cfg_gateway]..."
sed -i "/16060/s/16060/$port_gateway_http/g" "$cfg_gateway";
sed -i "/18433/s/18433/$port_gateway_rpc/g" "$cfg_gateway";
sed -i "/14444/s/14444/$port_gateway_socket/g" "$cfg_gateway";
sed -i "/t1.*8433/s/8433/$port_transfer_rpc/g" "$cfg_gateway";

# -----------------------graph----------------------------
echo "配置 graph 信息[$cfg_graph]..."
sed -i "/6071/s/6071/$port_graph_http/g" "$cfg_graph";
sed -i "/6070/s/6070/$port_graph_rpc/g" "$cfg_graph";

# ------------------------hsb-----------------------------
echo "配置 hsb 信息[$cfg_hbs]..."
sed -i "/6030/s/6030/$port_hbs_rpc/g" "$cfg_hbs";
sed -i "/6031/s/6031/$port_hbs_http/g" "$cfg_hbs";

# ------------------------judge---------------------------
echo "配置 judge 信息[$cfg_judge]..."
sed -i "/6081/s/6081/$port_judge_http/g" "$cfg_judge";
sed -i "/6080/s/6080/$port_judge_rpc/g" "$cfg_judge";
sed -i "/6030/s/6030/$port_hbs_rpc/g" "$cfg_judge";
sed -i "/6379/s/127.0.0.1:6379/$redis_host:$redis_port/g" "$cfg_judge";
sed -i "/redispass/s/redispass/$redis_password/g" "$cfg_judge";

# ------------------------nodata-----------------------------
echo "配置 nodata 信息[$cfg_nodata]..."
sed -i "/6090/s/6090/$port_nodata/g" "$cfg_nodata";
sed -i "/6060/s/6060/$port_transfer_http/g" "$cfg_nodata";
sed -i "/8080/s/8080/$port_api/g" "$cfg_nodata";
sed -i "s/default-token-used-in-server-side/$api_token/g" "$cfg_nodata";

# ------------------------transfer---------------------------
echo "配置 transfer 信息[$cfg_transfer]..."
sed -i "/6060/s/6060/$port_transfer_http/g" "$cfg_transfer";
sed -i "/8433/s/8433/$port_transfer_rpc/g" "$cfg_transfer";
sed -i "/4444/s/4444/$port_transfer_socket/g" "$cfg_transfer";
sed -i "/6080/s/6080/$port_judge_rpc/g" "$cfg_transfer";
sed -i "/6070/s/6070/$port_graph_rpc/g" "$cfg_transfer";

# -----------------------dashboard---------------------------
echo "配置 dashboard 信息[$cfg_dashboard]..."
sed -i "/8081/s/8081/$port_dashboard/g" "$cfg_dashboard_wsgi";
sed -i "/8081/s/8081/$port_dashboard/g" "$cfg_dashboard_gunicorn";
sed -i "/8080/s/8080/$port_api/g" "$cfg_dashboard";
sed -i "/PORTAL_DB_HOST/s/127.0.0.1/$db_host/g" "$cfg_dashboard";
sed -i "/PORTAL_DB_PORT/s/3306/$db_port/g" "$cfg_dashboard";
sed -i "/PORTAL_DB_USER/s/root/$db_user/g" "$cfg_dashboard";
sed -i "/PORTAL_DB_PASS/s/password/$db_password/g" "$cfg_dashboard";
sed -i "/ALARM_DB_HOST/s/127.0.0.1/$db_host/g" "$cfg_dashboard";
sed -i "/ALARM_DB_PORT/s/3306/$db_port/g" "$cfg_dashboard";
sed -i "/ALARM_DB_USER/s/root/$db_user/g" "$cfg_dashboard";
sed -i "/ALARM_DB_PASS/s/password/$db_password/g" "$cfg_dashboard";


echo "配置完成！"