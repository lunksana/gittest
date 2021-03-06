# Docker-proxy
## 构建shadowsocks+obfs代理容器
1. 基于alipine
2. shadowsocks-libev
3. simple-obfs

# 使用方法
## 1.拉取镜像
docker pull lunksana/docker-proxy

## 2.运行命令
docker run --name proxy -p 10000:10000 lunksana/docker-proxy:latest

## 3.变量说明

|   变量名    |    默认值    |    说明    |
|------------|-------------|------------|
|SERVER_HOST |0.0.0.0      |服务器地址   |
|SERVER_PORT |10000        |服务器端口   |
|PASSWORD    |password     |验证密码     |
|METHOD      |chacha20-ietf-poly1305|加密方式    |
|PLUGIN      |obfs-server  |混淆插件    |
|PLUGIN_OPTS |             |混淆参数，可选obfs=http、obfs=tls|
|PLUGIN_OPTS_LOCAL|              |客户端混淆参数  |
|ENABLE_OBFS |false        |是否启用混淆 |
|SS_MOD      |ss-server    |SS模式，可选ss-server、ss-local,暂时只提供此两种模式|

以上变量根据实际需求进行调整

## 4.容器端口
10000、10000\udp

## 5.模式设置
SS运行模式通过SS_MOD变量进行控制，默认是服务端模式，即ss-server
### 模式

|  SS_MOD  |  ENABLE_OBFS  |  执行命令  |
|----------|---------------|-----------|
|ss-server |false          |ss-server -p 8388 -k password -m chacha20-ietf-ploy1305 -l 1080 -u |
|ss-server |true           |ss-server -p 8388 -k password -m chacha20-ietf-ploy1305 -l 1080 -u --plugin obfs-server --plugin-opts obfs=http|
|ss-local  |false          |ss-local -s 123.123.123.123 -p 8388 -k password -m chacha20-ietf-ploy1305 -l 1080 -u|
|ss-local  |true           |ss-local -s 123.123.123.123 -p 8388 -k password -m chacha20-ietf-ploy1305 -l 1080 -u --plugin obfs-local --plugin-opts 'obfs=http;obfs-host=www.icloud.com'|

容器端口根据模式复用