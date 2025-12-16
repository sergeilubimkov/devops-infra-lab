# Небольшой DevOps-проект для демонстрации навыков Docker и CI/CD.

## Содержание
- [Структура и описание проекта](#project_description)
- [Hello world!](#hello_world)
- [Dockerfile](#dockerfile)
- [CI](#ci)
- [Как запустить локально](#starting)

### <a name="project_description"></a>Структура и описание проекта
Небольшой проект для укрепления навыков и изучения Github Action.  
Проект состоит из обычного приложения "Hello world!", Dockerfile для этого приложения и простого CI

**Было реализовано:**
- Dockerfile
- Автоматическая сборка образа при push
- проверка сборки
- проверка старта контейнера

### <a name="hello_world"></a>Hello world!
Простое приложение hello_world.py написанное на Python.   
Выводит сообщение на экран "Hello world! Don't  sleep! Time to work"

### <a name="dockerfile"></a>Dockerfile
Dockerfile для hello_world.py, создает docker образ приложения.

### <a name="сi"></a>CI
Пайплайн CI для Github Action, изучение Github Action.

### <a name="starting"></a>Как запустить локально
Перед запуском необходимо проверить устновлен docker на машине

```
git pull
docker build -t hello-world-app -f Dockerfile_hello_world .
docker run hello-world-app:latest
```
