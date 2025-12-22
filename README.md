# Небольшой DevOps-проект.

## Содержание
- [Структура и описание проекта](#project_description)
- [Hello world!](#hello_world)
- [Dockerfile](#dockerfile)
- [CI](#ci)
- [Как запустить локально](#starting)
- [Проверка](#checkig_work)
- [Kubernetes](#kuber)

### <a name="project_description"></a>Структура и описание проекта
Небольшой проект для укрепления навыков и изучения Github Action.  
Проект состоит из обычного приложения "Hello world!", Dockerfile для этого приложения и простого CI

**Было реализовано:**
- Dockerfile для Python-приложения
- Автоматическая сборка Docker-образа при push в репозиторий
- CI pipeline на GitHub Actions
- Локальный Kubernetes-кластер (kind), поднимаемый в CI
- Kubernetes Deployment с 3 репликами
- readinessProbe для проверки готовности приложения
- Service для доступа к приложению
- Автоматический деплой в Kubernetes через GitHub Actions (kind cluster используется для CI)
- Infrastructure: Terraform поднимает VPC, subnet, VM
- Monitoring с помощью Prometheus и Grafana

readinessProbe используется для контроля готовности приложения и исключения pod’ов из Service при ошибках.

### <a name="hello_world"></a>Hello world!
Это простое Python-приложение, реализующее минимальный HTTP‑сервер, предназначенный для учебных целей и демонстрации работы readiness / liveness probes в Kubernetes.   
  
  Приложение:
  - запускает HTTP‑сервер на порту 9000
  - обрабатывает входящие GET‑запросы
  - предоставляет отдельный health‑endpoint для Kubernetes

#### Поведение приложения
1. Health‑endpoint
```GET /health```
- Возвращает HTTP статус 200 OK
- Используется Kubernetes для проверки готовности или живости контейнера  

  Пример ответа:
  ```OK```


2. Основной endpoint
```GET / ``` (и любые другие пути)
- Возвращает HTTP статус 200 OK
- Используется как основной ответ приложения

  Пример ответа:
  ```Hello world! Don't  sleep! Time to work!```

### <a name="dockerfile"></a>Dockerfile
Dockerfile для hello_world.py, создает docker образ приложения.

### <a name="сi"></a>CI
Пайплайн CI для Github Action, изучение Github Actions.

### <a name="starting"></a>Как запустить локально
Перед запуском необходимо установить docker, helm и kind на сервер.

```
git pull
docker build -t doc-hello-world-im -f Dockerfile_hello_world .
kind create cluster --config kind-config.yaml
kind load docker-image doc-hello-world-im:latest --name devops-infra-lab
kubectl create namespace monitoring
helm install monitoring prometheus-community/kube-prometheus-stack --namespace monitoring
kubectl apply -f ./k8s
```
#### Проброс портов 
```
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090
kubectl port-forward svc/app-service 9000:80
```

### <a name="checkig_work"></a>Проверка 
```
kubectl get pods
kubectl get svc
```

### <a name="kuber">Kubernetes

Проект использует Kubernetes в двух контекстах:

### CI environment
В CI используется локальный Kubernetes-кластер на базе **kind**:
- kind cluster поднимается внутри GitHub Actions
- Docker-образы загружаются в кластер через `kind load docker-image`
- используется для тестирования Deployment и Service

### Runtime / Cloud environment
В облаке используется **k3s**, установленный на VM, созданной Terraform’ом:
- container runtime: containerd
- Docker напрямую не используется

### Работа с Docker-образами в k3s
Так как k3s использует containerd, локально собранные Docker-образы
не видны Kubernetes по умолчанию.

Для загрузки образа используется:

```bash
docker save doc-hello-world-im:latest -o app-image.tar
sudo k3s ctr images import app-image.tar
```

### Monitoring
- Prometheus собирает метрики
- Grafana визуализирует состояние приложения
