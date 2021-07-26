# OSPF #

Цель: Настроить OSPF офисе Москва Разделить сеть на зоны. Настроить фильтрацию между зонами.

Начальное ТЗ

- Маршрутизаторы R14-R15 находятся в зоне 0 - backbone
- Маршрутизаторы R12-R13 находятся в зоне 10. Дополнительно к маршрутам должны получать маршрут по-умолчанию
- Маршрутизатор R19 находится в зоне 101 и получает только маршрут по умолчанию
- Маршрутизатор R20 находится в зоне 102 и получает все маршруты, кроме маршрутов до сетей зоны 101
- Настройка для IPv6 повторяет логику IPv4

Конечное ТЗ:
- Зоне 0 - backbone, образована основным оборудованием, включающим в себя EDGE, DSWWAN, CORE, AGGRSW, DSWACC
- Зона 1 - Должен получать ТОЛЬКО маршрут по-умолчанию
- Зона 2 - выделяется оборудование образующее серверный сегмент: получает только маршрут ТОЛЬКО по-умолчанию
- Зона 3 - выделяется оборудование access уровня: получает все маршруты, кроме маршрутов до сетей зоны 1
- Настройка для IPv6 повторяет логику IPv4

Дополнительно реализован DHCP сервер для ACCESS уровня

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

![](/LECTURES/MODULE02/Lecture14/pictures/79.jpg)

##  Задание 1: Зоне 0 - backbone, образована основным оборудованием, включающим в себя EDGE, DSWWAN, CORE, AGGRSW, DSWACC

Типовая настройка оборудования схожа как для R, так и для L3 SW. Пример представлен для EDGE1: 

```
### Включаем OSPF, назначаем RID, выключаем на всех IF, кроме Gi0/2
router ospf 1
 router-id 1.1.1.1
 passive-interface default
 no passive-interface GigabitEthernet0/2

### Активируем OSPF на IF
interface GigabitEthernet0/2
 ip ospf 1 area 0

### Вбрасываем дефолтный маршрут в OSPF IPv4
###2.5.1 Propagate a Default Static Route in OSPFv2
router ospf 1
 default-information originate

do sho ip int br
do sho ip proto
do sho ip route ospf
do sho ip ospf databas
do sho ip ospf int gi 0/2


### Включаем OSPFv3, назнчаем RID
ipv6 router ospf 1
router-id 1.1.1.1
exit


### Активируем OSPFv3 на IF
interface GigabitEthernet0/2
 ipv6 ospf 1 area 0
exit

do sho ipv6 int br
do sho ipv6 proto
do sho ipv6 route ospf
do sho ipv6 ospf databas
sho ip ospf int gi 0/0
```

##  Задание 2: Зона 1 - Должен получать ТОЛЬКО маршрут по-умолчанию
Зона 1, смещается на GI0/3 DSWWAN1,2. То есть ABR будет выступать не MOWOSPF1, а DSWWAN1,2.
DSWWAN 1
```
interface GigabitEthernet0/3
 ip ospf 1 area 1
 exit
interface GigabitEthernet0/3
 ipv6 ospf 1 area 1
 exit


router ospf 1
area 1 stub
area 1 stub no-summary
exit

ipv6 router ospf 1
area 1 stub
area 1 stub no-summary
exit

```
Полностью получение маршрута возможно только в Totally-stub area. Настройка типовая для STUB-ABR:
```
### OSPF AREA2 - Totally STUB
router ospf 1
area 1 stub
exit

ipv6 router ospf 1
area 1 stub
exit
```

##  Задание 3: Зона 2 - выделяется оборудование образующее серверный сегмент: получает только маршрут ТОЛЬКО по-умолчанию

Аналогично заданию 2. Настройка ABR роутеров:
```
### OSPF AREA2 - Totally STUB
router ospf 1
area 2 stub
area 2 stub no-summary
exit

ipv6 router ospf 1
area 2 stub
area 2 stub no-summary
exit
```

Настройка всех остальных L3 SW
```
### OSPF AREA2 - Totally STUB
router ospf 1
area 2 stub
exit

ipv6 router ospf 1
area 2 stub
exit
```
##  Задание 4: Зона 3 - выделяется оборудование access уровня: получает все маршруты, кроме маршрутов до сетей зоны 1 
Наиболее интересно задение. Из-за свежей прошивки для IPv4 понадобилось настраивать OSPFv3 в дополнение к OSPFv2. Только после этого удалось реализовать редистрибуцию с фильтрацией маршрутов, чтобы запретить маршруты до сетей зоны 1.

Два процесса OSPFv3 для address-family IPv4, IPv6
```
router ospfv3 2
 router-id 1.1.1.4
 !
 address-family ipv4 unicast
  redistribute ospf 3
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute ospf 3
 exit-address-family
router ospfv3 3
 router-id 1.1.1.4
 !
 address-family ipv4 unicast
  redistribute ospf 1 route-map AREA0-to-AREA3-IPV4
  redistribute ospf 2
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute ospf 2 route-map AREA0-to-AREA3-IPV6
 exit-address-family
```
Настройка фильтрации показана ниже:

![](/LECTURES/MODULE02/Lecture14/pictures/80.jpg)

Процесс OSPFv2 для соседства с CORE только в address-family IPv4. Показана также редистрибуция маршрутов из процессов 2, 3.

```
router ospf 1
 router-id 1.1.1.4
 redistribute ospfv3 2 subnets
 redistribute ospfv3 3 subnets
 passive-interface default
 no passive-interface GigabitEthernet0/0
 no passive-interface GigabitEthernet0/1
 no passive-interface GigabitEthernet2/0
 no passive-interface GigabitEthernet2/1
 no passive-interface Port-channel1
```

Фильтрация в AREA 1 работает как в IPv4, так и в IPv6
```
O E2     172.17.0.200/29 
           [110/20] via 172.17.3.17, 00:17:46, GigabitEthernet0/1
           [110/20] via 172.17.3.1, 00:17:46, GigabitEthernet0/0
O E2     172.17.2.0/29 [110/20] via 172.17.3.17, 00:29:15, GigabitEthernet0/1
                       [110/20] via 172.17.3.1, 00:52:24, GigabitEthernet0/0

...

OE2 2000:AAAD:1:131::/64 [110/3]
     via FE80::E73:1FFF:FE47:708, GigabitEthernet0/1
     via FE80::E73:1FFF:FEED:C808, GigabitEthernet0/0
OE2 2000:AAAD:1:300::/64 [110/3]
     via FE80::E73:1FFF:FEED:C808, GigabitEthernet0/0
     via FE80::E73:1FFF:FE47:708, GigabitEthernet0/1
```

##  Задание 5: Настройка для IPv6 повторяет логику IPv4

Реализовано. Базовые настройки приведены выше.




Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.

- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE02/Lecture14/labs/configs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE02/Lecture14/labs/configs/03-01-EDGE2.txt)
      - [03-01-EDGEOSPF1](/LECTURES/MODULE02/Lecture14/labs/configs/03-01-EDGEOSPF1.txt)
   - Distribution UP: 
      - [03-02-DSWWAN1](/LECTURES/MODULE02/Lecture14/labs/configs/03-02-DSWWAN1.txt)
      - [03-02-DSWWAN2](/LECTURES/MODULE02/Lecture14/labs/configs/03-02-DSWWAN2.txt)
   - CORE:
      - [03-03-CORE1](/LECTURES/MODULE02/Lecture14/labs/configs/03-03-CORE1.txt)
      - [03-03-CORE2](/LECTURES/MODULE02/Lecture14/labs/configs/03-03-CORE2.txt)
   - Aggregation
      - [03-04-AGGRSWDC1](/LECTURES/MODULE02/Lecture14/labs/configs/03-04-AGGRSWDC1.txt)
      - [03-04-AGGRSWDC2](/LECTURES/MODULE02/Lecture14/labs/configs/03-04-AGGRSWDC2.txt)
         - ACCESS
            - [03-11-DCSW1](/LECTURES/MODULE02/Lecture14/labs/configs/03-11-DCSW1.txt)
            - [03-11-DCSW2](/LECTURES/MODULE02/Lecture14/labs/configs/03-11-DCSW2.txt)
   - Distribution DOWN
      - [03-05-DSWACC1](/LECTURES/MODULE02/Lecture14/labs/configs/03-05-DSWACC1.txt)
      - [03-05-DSWACC2](/LECTURES/MODULE02/Lecture14/labs/configs/03-05-DSWACC2.txt)
         - ACCESS
            - [03-10-ASW1](/LECTURES/MODULE02/Lecture14/labs/configs/03-10-ASW1.txt)
            - [03-10-ASW2](/LECTURES/MODULE02/Lecture14/labs/configs/03-10-ASW2.txt)
            - [DHCP](/LECTURES/MODULE02/Lecture14/labs/configs/DHCP.txt)




Доп. материалы: 
- http://www.labminutes.com/rs0044_ipv6_ospfv3_3
- https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16/iro-xe-16-book/OSPFv3-Route-Filter-Using-Dist-List.html
- https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16-10/iro-xe-16-10-book/OSPFv3-Route-Filter-Using-Dist-List.pdf
- https://www.learncisco.net/courses/icnd-1/introducing-ipv6/configuring-ospfv3.html
- http://4isp.blogspot.com/2013/10/ospf-inter-area-intra-area.html
- https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16-10/iro-xe-16-10-book/OSPFv3-Route-Filter-Using-Dist-List.html
- https://www.oreilly.com/library/view/cisco-ios-cookbook/0596527225/ch25s09.html
- https://www.cisco.com/c/en/us/td/docs/routers/crs/software/crs_r4-0/routing/command/reference/rr40crs1book_chapter5.html#wp1685952852
- https://packetlife.net/blog/2010/feb/10/ospf-filtering-inter-area-vs-intra-area/
- https://netcraftsmen.com/filtering-ospf-areas-in-ospf/
- http://www.audentia-gestion.fr/cisco/iro-xe-3s-book.pdf
- https://www.arista.com/en/um-eos/eos-open-shortest-path-first--version-3