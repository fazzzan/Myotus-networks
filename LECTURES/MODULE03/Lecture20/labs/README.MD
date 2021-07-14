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

Преобразуем в NAMED EIGRP

```
router eigrp 100
eigrp upgrade-cli NG

ipv6 router eigrp 100
eigrp upgrade-cli NG6
```

##  Задание 2: EDGEEIGRP-R32 получает только маршрут по-умолчанию

Так как не анонсировались ::/0, то и в списке маршрутов ipv6 их нет. Надо думать.

```
#### Создадим prefix-list для IPv4 и IPv6

(config)#ip prefix-list ONLYZERO seq 5 permit 0.0.0.0/0
(config)#ipv6 prefix-list ONLYZEROV6 seq 5 permit ::/0

#### Укажем prefix-list в конфигурации EIGRP на маршрутизаторе для фильтрации префиксов 0.0.0.0.0 и ::/0
router eigrp NG
address-family ipv4 unicast autonomous-system 100
topology base
distribute-list prefix ONLYZERO in

router eigrp NG6
address-family ipv6 unicast autonomous-system 100
topology base
distribute-list prefix-list ONLYZEROV6 in
```

##  Задание 3: R16-17 анонсируют только суммарные префиксы

```
### R16-17 анонсируют только суммарные префиксы для ACCESS подсетей 

int gi 0/2
ip summary-address eigrp 100 172.18.64.0 255.255.192.0
ipv6 summary-address eigrp 100 2000:AAAD:2:600::0/56
```
Таблица маршрутизации после применения команды на  16, 17:

![](/LECTURES/MODULE03/Lecture20/pictures/49.jpg)


##  Задание 4: Использовать EIGRP named-mode для настройки сети

На L3 имиджах протестирована команда
```
### Преобразуем в NAMED EIGRP
router eigrp 100
eigrp upgrade-cli NG

ipv6 router eigrp 100
eigrp upgrade-cli NG6
```

![](/LECTURES/MODULE03/Lecture20/pictures/48.jpg)

Пока не получилось для L2 имиджей

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


