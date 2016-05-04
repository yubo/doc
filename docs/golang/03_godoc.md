## go tool


## go tool
```shell
$go tool
addr2line
api
asm
cgo
compile
cover
dist
doc
fix
link
nm
objdump
pack
pprof
trace
vet
yacc
```

##godoc
```
godoc fmt             #documentation for package fmt
godoc fmt Printf      #documentation for fmt.Printf
godoc cmd/go          #force documentation for the go command
godoc -src fmt        #fmt package interface in Go source form
godoc -src fmt Printf #implementation of fmt.Printf
```

也可以用来查询,godoc首先会查询localhost:6060,然后 http://golang.org(被墙)

```
godoc -q Reader
godoc -q math.Sin
godoc -server=:6060 -q sin   #可以指定服务器
```

如果访问不golang.org,可以自建服务器
```
godoc -http=:6060
```
