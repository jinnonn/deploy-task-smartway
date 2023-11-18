# Тестовое задание на деплой проекта, SmartWay
### Описание задания:
![image](https://github.com/jinnonn/deploy-task-smartway/assets/146999555/80adf291-4413-4292-963c-c2079683b0fd)
---
### Описание стенда
Для проверки корректности деплоя использовались 3 ВМ в Yandex Cloud:
![image](https://github.com/jinnonn/deploy-task-smartway/assets/146999555/e180869c-72cb-431c-9ffa-ac5655ed53f8)
- **Ansible нода** использовалась как нода для управления конфигурацией ВМ и устанавливаемых сервисов.
- **Nginx-proxy нода** используется в качестве прокси для запросов к графане, всё обращение к сервису идёт через ноду с Nginx.
- **Grafana-postgres нода** используется для запуска контейнеров с Grafana и PostgreSQL.

P.S. Публичные адреса у ВМ кроме Ansible нужны лишь для установки сервисов через apt, в более "боевом" варианте предполагается наличие ноды с настроенным NAT и фаерволлом для обращения сервисов с серой адресацией в интернет.

---
### Процесс деплоя
- Перед началом деплоя необходимо отредактировать файл hosts.yml указав ip адреса с нодой nginx и нодой grafana-postgfes. Также стоит обратить внимание на переменные cloud_network (подсеть в облаке), owner, group и public_ip nginx'а и grafana_ip в defaults/main.yml, остальные переменные меняются на своё усмотрение.
- Для начала деплоя необходимо запустить плейбук (предварительно клонировав этот репо + установив Ansible) командой:
```
ansible-playbook ansible-playbook.yml -v
```
- Конфиг дашбордов графаны статичен и также находится в deploy-task-NgiGrafPSQL/files/psql_grafana/grafana/provisioning/dashboards
- Для генерации SSL сертификата в контейнере с PostgreSQL (и последующей активацией сертификата для БД) используется скрипт initbd.sh который с помощью docker-compose.yml передается в docker-entrypoint образа postgres.
- Конфиги nginx, datasouce для графаны, docker-compose.yml и custom.ini для графаны располагаются в templates роли и описаны с помощью jinja2.
