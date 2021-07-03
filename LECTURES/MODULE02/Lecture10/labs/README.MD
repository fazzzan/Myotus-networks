# Разбиение адресного пространства #

Цель:
- разработать и задокументировать адресное пространство (ipv4 и ipv6) для лабораторного стенда.
- настроить ipv4 и ipv6-адреса на каждом активном порту
- настроить каждый VPC в каждом офисе в своем VLAN.
- настроить VLAN управления для сетевых устройств
- настроить сети офисов так, чтобы не возникало broadcast штормов, а использование линков было максимально оптимизировано

Cхема сети ipv4

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

##  Задание 1: разработать и задокументировать адресное пространство (ipv4 и ipv6) для лабораторного стенда

### 1.1 Адреса публичных сетей

![](/LECTURES/MODULE02/Lecture10/pictures/34.jpg)

IPv4

|     Офис   |       Подсеть | 
|------------|---------------|
| WAN TRIADA | 50.0.56.0/24  |
| WAN KITORN | 100.1.1.0/24  |
| WAN LIMAS  | 30.1.35.0/24  | 

IPv6

|     Офис   |       Диапазон адресов         | 
|------------|--------------------------------|
| WAN TRIADA | 2000:AAAA::/32  |
| WAN KITORN | 100.1.1.0/24 - 100.1.1.255 /24 |
| WAN LIMAS  | 30.1.35.0/24 - 30.1.35.255/24  | 


### 1.2 Адреса внутренних сетей IPv4


### 1.3 Адреса внутренних сетей IPv6

##  Задание 2: настроить адреса (ipv4 и ipv6) на каждом активном порту
##  Задание 3: настроить VLAN управления для сетевых устройств
##  Задание 4: настроить сети офисов так, чтобы не возникало broadcast штормов, а использование линков было максимально оптимизировано
Всего перед нами 4 сегмента распределенной сети предприятия:
1. ЦО/ЦОД - Москва
2. Бранч СПб
3. Бранч Чокурдах
4. Бранч Лабытнанги

Исходя из количества оборудования и предполагая запас на рост предприятия, выбираем сеть класса B 172.16.0.0 /12. Данную подсеть легко разбить на нужные сегменты.
| Офис  | Диапазон подсетей  | 
|-------|--------------------|
| ЦО/ЦОД - Москва  | 172.17.0.0/16 - 172.17.255.255/16  |
| Бранч СПб  | 172.18.0.0/16 - 172.18.255.255/16 |
| Бранч Чокурдах  | 172.19.0.0/16 - 172.19.255.255/16 | 
| Бранч Лабытнанги  | 172.20.0.0/16 - 172.20.255.255/16 |

Для визуализации разбиения используем представление адресного пространства в виде квадрата, где цвет соответствует занятому диапазону. Далее будем использовать аналогичный способ:

![](/LECTURES/MODULE02/Lecture10/pictures/32.jpg)

Каждую из выделенных подсетей также легко разбить на нужные сегменты, при этом будут соблюдены принципы последующей суммаризации сегментов, отвечающих за тот или иной участок, например: серверный сегмент,  сегменты принтеров, поэтажные пользовательские сегменты  и т.д.

![](/LECTURES/MODULE02/Lecture10/pictures/33.jpg)

Настройки WAN представлены в pdf-файле

[AddressSpace20210528.pdf](/LECTURES/MODULE02/Lecture10/labs/AddressSpace20210528.pdf)

Настройки оборудования, в том числе для подсети управления пока выполнены для ipv4.

[01-ISP1](/LECTURES/MODULE02/Lecture10/labs/01-ISP1.txt)
[02-ISP2](/LECTURES/MODULE02/Lecture10/labs/02-ISP2.txt)
[03-01-EDGE1](/LECTURES/MODULE02/Lecture10/labs/03-01-EDGE1.txt)
[03-01-EDGE2](/LECTURES/MODULE02/Lecture10/labs/03-01-EDGE2.txt)
[03-01-EDGEOSPF1](/LECTURES/MODULE02/Lecture10/labs/03-01-EDGEOSPF1.txt)
[03-02-DSWWAN1](/LECTURES/MODULE02/Lecture10/labs/03-02-DSWWAN1.txt)
[03-02-DSWWAN2](/LECTURES/MODULE02/Lecture10/labs/03-02-DSWWAN2.txt)
[03-03-CORE1](/LECTURES/MODULE02/Lecture10/labs/03-03-CORE1.txt)
[03-03-CORE2](/LECTURES/MODULE02/Lecture10/labs/03-03-CORE2.txt)
[03-04-AGGRSWDC1](/LECTURES/MODULE02/Lecture10/labs/03-04-AGGRSWDC1.txt)
[03-04-AGGRSWDC2](/LECTURES/MODULE02/Lecture10/labs/03-04-AGGRSWDC2.txt)
[03-05-DSWACC1](/LECTURES/MODULE02/Lecture10/labs/03-05-DSWACC1.txt)
[03-05-DSWACC2](/LECTURES/MODULE02/Lecture10/labs/03-05-DSWACC2.txt)
[03-10-ASW1](/LECTURES/MODULE02/Lecture10/labs/03-10-ASW1.txt)
[03-10-ASW2](/LECTURES/MODULE02/Lecture10/labs/03-10-ASW2.txt)
[03-11-DCSW1](/LECTURES/MODULE02/Lecture10/labs/03-11-DCSW1.txt)
[03-11-DCSW2](/LECTURES/MODULE02/Lecture10/labs/03-11-DCSW2.txt)
[04-R23](/LECTURES/MODULE02/Lecture10/labs/04-R23.txt)
[04-R24](/LECTURES/MODULE02/Lecture10/labs/04-R24.txt)
[04-R25](/LECTURES/MODULE02/Lecture10/labs/04-R25.txt)
[04-R26](/LECTURES/MODULE02/Lecture10/labs/04-R26.txt)
[05-1-EDGE-R31](/LECTURES/MODULE02/Lecture10/labs/05-1-EDGE-R31.txt)
[05-1-EDGEEIGRP-R32](/LECTURES/MODULE02/Lecture10/labs/05-1-EDGEEIGRP-R32.txt)
[05-2-DSWCOLCORE16](/LECTURES/MODULE02/Lecture10/labs/05-2-DSWCOLCORE16.txt)
[05-2-DSWCOLCORE17](/LECTURES/MODULE02/Lecture10/labs/05-2-DSWCOLCORE17.txt)
[05-5-ASW3](/LECTURES/MODULE02/Lecture10/labs/05-5-ASW3.txt)
[05-5-ASW4](/LECTURES/MODULE02/Lecture10/labs/05-5-ASW4.txt)
[06-1-EDGE-R28](/LECTURES/MODULE02/Lecture10/labs/06-1-EDGE-R28.txt)
[06-5-ASW29](/LECTURES/MODULE02/Lecture10/labs/06-5-ASW29.txt)
[07-1-EDGE-R27](/LECTURES/MODULE02/Lecture10/labs/07-1-EDGE-R27.txt)
