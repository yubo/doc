# confd

[confd](https://github.com/kelseyhightower/confd) is a lightweight configuration management tool focused on:

* keeping local configuration files up-to-date using data stored in [etcd](https://github.com/coreos/etcd),
  [consul](http://consul.io), [dynamodb](http://aws.amazon.com/dynamodb/), [redis](http://redis.io),
  [vault](https://vaultproject.io), [zookeeper](https://zookeeper.apache.org) or env vars and processing [template resources](docs/template-resources.md).
* reloading applications to pick up new config file changes

resources

* [quick start guide](https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md)

## add keys
```shell
etcdctl --endpoint http://10.235.116.23:2379 set /myapp/database/url db.example.com
etcdctl --endpoint http://10.235.116.23:2379 set /myapp/database/user rob
etcdctl --endpoint http://10.235.116.23:2379 set /myapp/database/json '{"str":"hello,world","int":1234,"bool":true,"arr":["a","b","c"],"struct":{"str":"HELLO,WORLD","int":234,"bool":false,"arr":["A","B","C"]}}'
```

## Create the confidir
sudo mkdir -p /etc/confd/{conf.d,templates}

## Create a template resource config
/etc/confd/conf.d/myconfig.toml
```
[template]
src = "myconfig.conf.tmpl"
dest = "/tmp/myconfig.conf"
prefix = "/myapp/database"
keys = [
	"/url",
	"/user",
	"/json",
]
check_cmd = "echo {{.src}} >> /tmp/check_cmd.log"
reload_cmd = "cat /tmp/myconfig.conf >> /tmp/reload_cmd.log"
```

## Create the source template
/etc/confd/templates/myconfig.conf.tmpl
```
[myconfig]
database_url = {{getv "/url"}}
database_user = {{getv "/user"}}
[json]
json = {{getv "/json"}}
{{$json := json (getv "/json")}}
json.str = {{$json.str}}
json.int = {{$json.int}}
json.bool = {{$json.bool}}
{{if $json.bool}}
{{range $json.arr}}{{printf "[%s]\n" .}}{{end}}
{{end}}

json.struct.str = {{$json.struct.str}}
json.struct.bool = {{$json.struct.bool}}
{{range $json.struct.arr}}{{printf "[%s]\n" .}}{{end}}
```

## Process the template
```
confd -onetime -backend etcd -node http://10.235.116.23:2379
```


## note

* `template.Process()`
  - `t.setVars()` # 从etcd取数据
  - `t.createStageFile()` # 创建临时目标文件
  - `t.sync()` #临时文件与目标文件做对比,做相应处理(check/rename/reload)
	* `sameConfig()` # 对文件的 uid, gid, mode, md5 比较

## watch
使用-watch开启后,interval参数失效,做到实时更新配置文件,使用长连接减小服务端的查询量

confd在启动时,初始化所有的配置文件,之后发起`GET /v2/keys/?recursive=true&wait=true&waitIndex=0 HTTP/1.1`请求,被服务端阻塞,直到etcd有数据更新为止,内容如下[confd_watch.cap](cap/confd_watch.cap?raw=true)

```
GET /v2/keys/?recursive=true&wait=true&waitIndex=0 HTTP/1.1
Host: 10.235.116.23:2379
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip

HTTP/1.1 200 OK
Content-Type: application/json
X-Etcd-Cluster-Id: 7e27652122e8b2ae
X-Etcd-Index: 23897
X-Raft-Index: 400126
X-Raft-Term: 2
Date: Fri, 08 Apr 2016 08:19:22 GMT
Transfer-Encoding: chunked

cd 
{"action":"set","node":{"key":"/myapp/database/url","value":"4","modifiedIndex":23898,"createdIndex":23898},"prevNode":{"key":"/myapp/database/url","value":"3","modifiedIndex":23897,"createdIndex":23897}}

0
```
confd会根据etcd回复的内容(key,modifiedIndex,createdIndex),更新相应key的配置文件,如果没有需要更新的配置,会直接发起wait请求


## usage
```
Usage of confd:
  -app-id string
    	Vault app-id to use with the app-id backend (only used with -backend=vault and auth-type=app-id)
  -auth-token string
    	Auth bearer token to use
  -auth-type string
    	Vault auth backend type to use (only used with -backend=vault)
  -backend string
    	backend to use (default "etcd")
  -basic-auth
    	Use Basic Auth to authenticate (only used with -backend=etcd)
  -client-ca-keys string
    	client ca keys
  -client-cert string
    	the client cert
  -client-key string
    	the client key
  -confdir string
    	confd conf directory (default "/etc/confd")
  -config-file string
    	the confd config file
  -interval int
    	backend polling interval (default 600)
  -keep-stage-file
    	keep staged files
  -log-level string
    	level which confd should log messages
  -node value
    	list of backend nodes (default [])
  -noop
    	only show pending changes
  -onetime
    	run once and exit
  -password string
    	the password to authenticate with (only used with vault and etcd backends)
  -prefix string
    	key path prefix
  -scheme string
    	the backend URI scheme for nodes retrieved from DNS SRV records (http or https) (default "http")
  -srv-domain string
    	the name of the resource record
  -srv-record string
    	the SRV record to search for backends nodes. Example: _etcd-client._tcp.example.com
  -sync-only
    	sync without check_cmd and reload_cmd
  -table string
    	the name of the DynamoDB table (only used with -backend=dynamodb)
  -user-id string
    	Vault user-id to use with the app-id backend (only used with -backend=value and auth-type=app-id)
  -username string
    	the username to authenticate as (only used with vault and etcd backends)
  -version
    	print version and exit
  -watch
    	enable watch support
```
