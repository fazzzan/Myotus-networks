# Основные протоколы сети интернет #
Домашнее задание: NAT, DNS, NTP;

Цель: Настроить DHCP в офисе Москва Настроить синхронизацию времени в офисе Москва Настроить NAT в офисе Москва, C.-Перетбруг и Чокурдах

1. Настроите NAT(PAT) на R14 и R15. Трансляция должна осуществляться в адрес автономной системы AS1001
2. Настроите NAT(PAT) на R18. Трансляция должна осуществляться в пул из 5 адресов автономной системы AS2042
- отсутствует 3. Настроите статический NAT для R20
- нет OSPF 4. Настроите NAT так, чтобы R19 был доступен с любого узла для удаленного управления
5. Настроите статический NAT(PAT) для офиса Чокурдах
6. Настроите DHCP сервер в офисе Москва на маршрутизаторах R12 и R13. VPC1 и VPC7 должны получать сетевые настройки по DHCP
7. Настроите NTP сервер на R12 и R13. Все устройства в офисе Москва должны синхронизировать время с R12 и R13
8. Все офисы в лабораторной работе должны иметь IP связность


Решение: 
Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

## Задание 1: Настроите NAT(PAT) на EDGE1 и EDGE2. Трансляция должна осуществляться в адрес автономной системы AS1001

Сначала отравим путь до AS1001 слева, чтбы сделать маршрут в AS 1001 симметричным
```
route-map AS-1001 permit 10
 set as-path prepend 1001 1001

router bgp 1001
 address-family ipv4
  neighbor 100.1.1.97 route-map AS-1001 out
 exit-address-family
 address-family ipv6
  neighbor 2000:AAAB:400::1 route-map AS-1001 out
 exit-address-family
```
Настройка PAT немного отличается от стандартной, так как нам надо подменить исходящие ip на ipv4 AS1001
```
interface GigabitEthernet0/1
 ip nat outside
!
interface GigabitEthernet0/2
 ip nat inside
!
ip access-list extended OSPF0
 permit ip 172.17.0.0 0.0.0.255 any
 permit ip 172.18.0.0 0.0.0.255 any
 permit ip 172.17.64.0 0.0.0.255 any

ip nat pool AS1001 35.10.10.10 35.10.10.10 netmask 255.255.255.0


ip nat inside source list OSPF0 pool AS1001 overload
```
Трафик успешно транслируется

![](/LECTURES/MODULE04/Lecture30/pictures/01.jpg)
![](/LECTURES/MODULE04/Lecture30/pictures/02.jpg)

## Задание 2: Настроите NAT(PAT) на EDGE-R31. Трансляция должна осуществляться в пул из 5 адресов автономной системы AS2042

Выполнена, трансляция работает
```
### Настройка PAT
!
interface GigabitEthernet0/0
 ip nat outside
!
interface GigabitEthernet0/2
 ip nat outside
!
interface GigabitEthernet0/1
 ip nat inside
!
interface GigabitEthernet0/3
 ip nat inside
!
no ip nat inside source route-map ISP1 interface GigabitEthernet0/0 overload
no ip nat inside source route-map ISP2 interface GigabitEthernet0/2 overload
!
ip access-list extended INSIDE
 permit ip 172.18.64.0 0.0.0.255 any
 permit ip 172.18.65.0 0.0.0.255 any


ip nat pool AS2042 50.50.96.10 50.50.96.15 netmask 255.255.255.0


ip nat inside source list INSIDE pool AS2042
```

## - Задание 3: Настроите статический NAT для R20
## - Задание 4: Настроите NAT так, чтобы R19 был доступен с любого узла для удаленного управления

## Задание 5: Настроите статический NAT(PAT) для офиса Чокурдах

Настройка NAT выполнена с учетом PBR и отслеживанием оставшегося в живых линкА
```
interface GigabitEthernet0/0.110
 ip nat outside

interface GigabitEthernet0/0.120
 ip nat outside

interface GigabitEthernet0/1.61
ip policy route-map PBR-ISP1
 ip nat inside

interface GigabitEthernet0/1.71
 ip policy route-map PBR-ISP2
 ip nat inside

ip nat inside source route-map ISP1 interface GigabitEthernet0/0.110 overload
ip nat inside source route-map ISP2 interface GigabitEthernet0/0.120 overload

ip access-list extended VLAN61
 permit ip 172.19.64.0 0.0.0.255 any
ip access-list extended VLAN71
 permit ip 172.19.70.0 0.0.0.63 any

route-map PBR-ISP2 permit 10
 match ip address VLAN71
 set ip next-hop verify-availability 52.0.56.105 10 track 6
 set ip next-hop verify-availability 52.0.56.101 20 track 3
!
route-map PBR-ISP1 permit 10
 match ip address VLAN61
 set ip next-hop verify-availability 52.0.56.101 10 track 3
 set ip next-hop verify-availability 52.0.56.105 20 track 6

route-map ISP2 permit 10
 match interface GigabitEthernet0/0.120
!         
route-map ISP1 permit 10
 match interface GigabitEthernet0/0.110
```

## Задание 6: Настроите DHCP сервер в офисе Москва на маршрутизаторах R12 и R13. VPC1 и VPC7 должны получать сетевые настройки по DHCP

Выполнено:
```
ip dhcp excluded-address 172.17.64.1 172.17.64.10
ip dhcp excluded-address 172.17.64.254
ip dhcp excluded-address 172.17.70.1 172.17.70.10
ip dhcp excluded-address 172.17.70.254
ip dhcp excluded-address 172.17.70.62
ip dhcp excluded-address 172.17.65.1 172.17.65.10
ip dhcp excluded-address 172.17.65.254
ip dhcp excluded-address 172.17.70.65 172.17.70.75
ip dhcp excluded-address 172.17.70.126
!
ip dhcp pool PC-FLOOR1
 network 172.17.64.0 255.255.255.0
 default-router 172.17.64.254 
 dns-server 172.17.64.254 
!
ip dhcp pool PRN-FLOOR1
 network 172.17.70.0 255.255.255.192
 default-router 172.17.70.62 
 dns-server 172.17.70.62 
!
ip dhcp pool PC-FLOOR2
 network 172.17.65.0 255.255.255.0
 default-router 172.17.65.254 
 dns-server 172.17.65.254 
!
ip dhcp pool PRN-FLOOR2
 network 172.17.70.64 255.255.255.192
 default-router 172.17.70.126 
 dns-server 172.17.70.126 
```
На промежуточных L3 - Access SW настроен соответствующий ip-helper, для нужного VLAN
```
### Назначение ip-helper
interface Vlan61
 ip helper-address 172.17.16.1
 ip helper-address 172.17.17.1 
 no shutdown
!
interface Vlan71
 ip helper-address 172.17.16.1
 ip helper-address 172.17.17.1 
 no shutdown
!
```

![](/LECTURES/MODULE04/Lecture30/pictures/03.jpg)

## Задание 7: Настроите NTP сервер на R12 и R13. Все устройства в офисе Москва должны синхронизировать время с R12 и R13
Сервер
```
clock set 02:39:00 23 July 2021
#Заходим в режим конфигурации
conf t
clock timezone MSK 3
ntp master 2
ntp update-calendar
ntp server 0.pool.ntp.org
ntp server 1.pool.ntp.org
```

Клиент
```
###интерфейса-источника ntp server 10.0.3.31, 32

clock timezone MSK 3
ntp server 10.0.3.31
ntp server 10.0.3.31
```

## Задание 8: Все офисы в лабораторной работе должны иметь IP связность

Все внешние узлы видят друг друга

Задание выполнено


- Киторн (01):
   - [01-ISP1](/LECTURES/MODULE04/Lecture20/labs/configs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE04/Lecture20/labs/configs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE04/Lecture20/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE04/Lecture20/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE04/Lecture20/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE04/Lecture20/labs/configs/04-R26.txt)
- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE04/Lecture20/labs/configs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE04/Lecture20/labs/configs/03-01-EDGE2.txt)
      - [03-01-EDGEOSPF1](/LECTURES/MODULE04/Lecture20/labs/configs/03-01-EDGEOSPF1.txt)
   - Distribution UP: 
      - [03-02-DSWWAN1](/LECTURES/MODULE04/Lecture20/labs/configs/03-02-DSWWAN1.txt)
      - [03-02-DSWWAN2](/LECTURES/MODULE04/Lecture20/labs/configs/03-02-DSWWAN2.txt)
   - CORE:
      - [03-03-CORE1](/LECTURES/MODULE04/Lecture20/labs/configs/03-03-CORE1.txt)
      - [03-03-CORE2](/LECTURES/MODULE04/Lecture20/labs/configs/03-03-CORE2.txt)
   - Aggregation
      - [03-04-AGGRSWDC1](/LECTURES/MODULE04/Lecture20/labs/configs/03-04-AGGRSWDC1.txt)
      - [03-04-AGGRSWDC2](/LECTURES/MODULE04/Lecture20/labs/configs/03-04-AGGRSWDC2.txt)
         - ACCESS
            - [03-11-DCSW1](/LECTURES/MODULE04/Lecture20/labs/configs/03-11-DCSW1.txt)
            - [03-11-DCSW2](/LECTURES/MODULE04/Lecture20/labs/configs/03-11-DCSW2.txt)
   - Distribution DOWN
      - [03-05-DSWACC1](/LECTURES/MODULE04/Lecture20/labs/configs/03-05-DSWACC1.txt)
      - [03-05-DSWACC2](/LECTURES/MODULE04/Lecture20/labs/configs/03-05-DSWACC2.txt)
         - ACCESS
            - [03-10-ASW1](/LECTURES/MODULE04/Lecture20/labs/configs/03-10-ASW1.txt)
            - [03-10-ASW2](/LECTURES/MODULE04/Lecture20/labs/configs/03-10-ASW2.txt)
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE04/Lecture20/labs/configs/05-1-EDGE-R31.txt)
      - [05-01-EDGEEIGRP-R32](/LECTURES/MODULE04/Lecture20/labs/configs/05-1-EDGEEIGRP-R32.txt)
   - CollapsedCORE
      - [05-02-DSWCOLCORE16](/LECTURES/MODULE04/Lecture20/labs/configs/05-2-DSWCOLCORE16.txt)
      - [05-02-DSWCOLCORE17](/LECTURES/MODULE04/Lecture20/labs/configs/05-2-DSWCOLCORE17.txt)
   - ACCESS
      - [05-10-ASW3](/LECTURES/MODULE04/Lecture20/labs/configs/05-5-ASW3.txt)
      - [05-10-ASW4](/LECTURES/MODULE04/Lecture20/labs/configs/05-5-ASW4.txt)
- Чокурдах (06)
   - EDGE
      - [06-1-EDGE-R28](/LECTURES/MODULE04/Lecture20/labs/configs/06-1-EDGE-R28.txt)
   - ACCESS
      - [06-5-ASW29](/LECTURES/MODULE04/Lecture20/labs/configs/06-5-ASW29.txt)
- Лабытнанги (07)
   - EDGE
      - [07-1-EDGE-R27](/LECTURES/MODULE04/Lecture20/labs/configs/07-1-EDGE-R27.txt)

