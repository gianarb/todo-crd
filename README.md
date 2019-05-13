This is an example about how to extend Kubernetes with a Custom Resource
Definition.

I have used [code-generator](https://github.com/kubernetes/code-generator) to
generate types, clients and informers for this CRD. The `cmd/main.go` starts a
shared informer to extend capabilities with your business code.

## Run on kubernetes

1. Start minikube
2. Deploy CRD, apps
```
kubectl apply -f artifacts/crd.yaml
kubectl apply -f artifacts/app.yaml
```
3. Tail the logs from the pod to see what the application does
4. Create your first item: `kubectl apply -f artifacts/todo.yaml`

## Dependency Management
The project uses `go mod` but it is requited by `code-generator` for the project
to be in the `GOPATH`. You should export `GO111MODULE=on` to be sure that the
project uses `go mod` even if it is inside the `GOPATH`.

## Generate code
Checkout the project in your GOPATH because `code-generator` still uses
`GOPATH`. And this is the command I used to generate the code inside
`pkg/client`.

```
~/go/src/k8s.io/code-generator/generate-groups.sh all \
    github.com/gianarb/todo-crd/pkg/client \
    github.com/gianarb/todo-crd/pkg/apis todoexample:v1
```

## Run locally 
You can start minkube, register the crd with `kubectl apply -f
artifacts/crd.yaml` and run `go run ./cmd/main.go` to start the shared informer
app:

```
go run cmd/main.go
{"level":"info","msg":"The todo operator started."}
```

This the expected log. As you can see in `./cmd/main.go` I have just initialized
the Shared Informer without implementing any method. When you create a new todo
item from `./artifacts/todo.yaml` you should see logs from the application:

```
$ go run cmd/main.go
{"level":"info","msg":"The todo operator started."}
{"level":"info","msg":"new key received","message_key":"default/buy-book"}
{"level":"info","msg":"new key received","message_key":"default/buy-book"}
```

## Credits
Some of the project and articles I read to make this to work:

* https://github.com/kubernetes/sample-controller
* https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
* https://github.com/kubernetes/client-go/blob/master/INSTALL.md#go-modules
