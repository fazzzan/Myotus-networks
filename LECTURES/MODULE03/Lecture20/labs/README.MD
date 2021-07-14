# EIGRP #

Цель: Настроить EIGRP в С.-Петербург; Использовать named EIGRP

ТЗ: 
- В офисе С.-Петербург настроить EIGRP
- EDGEEIGRP-R32 получает только маршрут по-умолчанию
- R16-17 анонсируют только суммарные префиксы
- Использовать EIGRP named-mode для настройки сети

Настройка осуществляется одновременно для IPv4 и IPv6

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

![](/LECTURES/MODULE03/Lecture20/pictures/45.jpg)

##  Задание 1

Типовая настройка оборудования схожа для всех R SPb. Пример представлен для DSWCOLCORE17: 

```
hostname DSWCOLCORE17
!
### Включаем EIGRP, назначаем RID, выключаем на всех IF, кроме Gi0/2, Gi0/3, Gi2/0, Gi2/1,  Po1 задаем сети
!
router eigrp 100
eigrp router-id 0.0.0.17
 passive-interface default
 no passive-interface GigabitEthernet0/2
 no passive-interface GigabitEthernet0/3
 no passive-interface GigabitEthernet2/0
 no passive-interface GigabitEthernet2/1
 no passive-interface Port-channel1
 network 172.18.0.0 0.0.0.7
 network 172.18.0.16 0.0.0.7
 network 172.18.0.48 0.0.0.7
 network 172.18.0.56 0.0.0.7
 network 172.18.0.64 0.0.0.7

### Включаем EIGRP IPv6

ipv6 router eigrp 100
eigrp router-id 0.0.0.17

interface GigabitEthernet0/2
ipv6 eigrp 100
exit
interface GigabitEthernet0/3
ipv6 eigrp 100
exit
interface GigabitEthernet2/0
ipv6 eigrp 100
exit
interface GigabitEthernet2/1
ipv6 eigrp 100
exit
interface Port-channel1
ipv6 eigrp 100
exit
```
Соседи R-32

![](/LECTURES/MODULE03/Lecture20/pictures/47.jpg)

прилетевшие маршруты на R-32

![](/LECTURES/MODULE03/Lecture20/pictures/46.jpg)



##  Задание 2: EDGEEIGRP-R32 получает только маршрут по-умолчанию

попробовал безуспешно командой на обоих DSWCOLCORE17, 16
```
### EDGEEIGRP-R32 получает только маршрут по-умолчанию
interface gi0/3
ip summary-address eigrp 100 0.0.0.0 0.0.0.0
ipv6 summary-address eigrp 100 0::0/0
```
##  Задание 3: R16-17 анонсируют только суммарные префиксы

Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.

- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE03/Lecture20/labs/configs/05-1-EDGE-R31.txt)
      - [05-01-EDGEEIGRP-R32](/LECTURES/MODULE03/Lecture20/labs/configs/05-1-EDGEEIGRP-R32.txt)
   - CollapsedCORE
      - [05-02-DSWCOLCORE16](/LECTURES/MODULE03/Lecture20/labs/configs/05-2-DSWCOLCORE16.txt)
      - [05-02-DSWCOLCORE17](/LECTURES/MODULE03/Lecture20/labs/configs/05-2-DSWCOLCORE17.txt)
   - ACCESS
      - [05-10-ASW3](/LECTURES/MODULE03/Lecture20/labs/configs/05-5-ASW3.txt)
      - [05-10-ASW4](/LECTURES/MODULE03/Lecture20/labs/configs/05-5-ASW4.txt)
- Чокурдах (06)
   - EDGE
      - [06-1-EDGE-R28](/LECTURES/MODULE03/Lecture20/labs/configs/06-1-EDGE-R28.txt)
   - ACCESS
      - [06-5-ASW29](/LECTURES/MODULE03/Lecture20/labs/configs/06-5-ASW29.txt)
- Лабытнанги (07)
   - EDGE
      - [07-1-EDGE-R27](/LECTURES/MODULE03/Lecture20/labs/configs/07-1-EDGE-R27.txt)


