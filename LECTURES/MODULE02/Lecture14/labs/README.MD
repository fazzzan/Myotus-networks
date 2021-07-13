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
- Зона 1 - Дополнительно к маршрутам MOWOSPF1 должен получать маршрут по-умолчанию
- Зона 2 - выделяется оборудование образующее серверный сегмент: получает только маршрут по умолчанию
- Зона 3 - выделяется оборудование access уровня: получает все маршруты, кроме маршрутов до сетей зоны 1
- Настройка для IPv6 повторяет логику IPv4

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

##  Задание 1: Зона 0

Типовая настройка оборудования схожа как для R, так и для L3 SW. Пример представлен для EDGE1: 

```
### Включаем OSPF, назнчаем RID, выключаем на всех IF, кроме Gi0/2
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

##  Задание 3: Зона 1
Не смог формализовать задачу, поэтому предполагаю, что Зона 1, должна сместиться на DSWWAN1,2. То есть ABR будет выступать не MOWOSPF1, а DSWWAN1,2.

Необходимо обсудить

##  Задание 3: Зона 2

Полностью получение маршрута возможно только в Totally-stub area. Настройка ABR роутеров:
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
##  Задание 4: Зона 3 
Требуется уточнение задания: сейчас это обычная зона, со всеми LSA. Думаю что понадобится произвести фильтрацию маршрутов, чтобы запретить маршруты до сетей зоны 1



##  Задание 5: Настройка для IPv6 повторяет логику IPv4

Реализовано. Базовые настройки приведены выше.




Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.

- Киторн (01):
   - [01-ISP1](/LECTURES/MODULE02/Lecture14/labs/configs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE02/Lecture14/labs/configs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE02/Lecture14/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE02/Lecture14/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE02/Lecture14/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE02/Lecture14/labs/configs/04-R26.txt)
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
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE02/Lecture14/labs/configs/05-1-EDGE-R31.txt)
      - [05-01-EDGEEIGRP-R32](/LECTURES/MODULE02/Lecture14/labs/configs/05-1-EDGEEIGRP-R32.txt)
   - CollapsedCORE
      - [05-02-DSWCOLCORE16](/LECTURES/MODULE02/Lecture14/labs/configs/05-2-DSWCOLCORE16.txt)
      - [05-02-DSWCOLCORE17](/LECTURES/MODULE02/Lecture14/labs/configs/05-2-DSWCOLCORE17.txt)
   - ACCESS
      - [05-10-ASW3](/LECTURES/MODULE02/Lecture14/labs/configs/05-5-ASW3.txt)
      - [05-10-ASW4](/LECTURES/MODULE02/Lecture14/labs/configs/05-5-ASW4.txt)
- Чокурдах (06)
   - EDGE
      - [06-1-EDGE-R28](/LECTURES/MODULE02/Lecture14/labs/configs/06-1-EDGE-R28.txt)
   - ACCESS
      - [06-5-ASW29](/LECTURES/MODULE02/Lecture14/labs/configs/06-5-ASW29.txt)
- Лабытнанги (07)
   - EDGE
      - [07-1-EDGE-R27](/LECTURES/MODULE02/Lecture14/labs/configs/07-1-EDGE-R27.txt)

