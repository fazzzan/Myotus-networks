20210709 Ansible

![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture38/pictures/01.jpg)

![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture38/pictures/02.jpg)

С точкми зрения Ansible вывод может быть нечитаемым, но для ПК - то, что надо

![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture38/pictures/03.jpg)

Установка: centos 8.3

![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture38/pictures/04.jpg)

установка модуля для подключения по SSH
![](pictures/05.jpg)

Описание хостов - файл cisco.ini - объект ___INVENTORY___
![](pictures/06.jpg)

Описываем все группы устройств, но обращаемся к ним по имени родительской группы.

![](pictures/07.jpg)

![](pictures/08.jpg)

![](pictures/09.jpg)

результат

![](pictures/10.jpg)

Дополнительно заносим параметры в файл hosts.ini

![](pictures/11.jpg)

Результат - вызов module ad-hoc
![](pictures/12.jpg)

## Ansible.cfg ##

![](pictures/13.jpg)

В файле указываются дополнительные настройки по-умолчанию:

![](pictures/14.jpg)

Можно указать что сделать с "фактами" explicit и с запретом на подключение без импорта fingerprint ssh подключения

![](pictures/15.jpg)

## Модули ##

![](pictures/16.jpg)

![](pictures/17.jpg)

- core - пишут RedHAT
- network - домашние заготовки
- certified - сам производитель
- community - 

docs.ansible.com

AWX tower - создание некоего репозитория с типовыми task для выполнения разных действий сотрудниками предприятия.

