#  Виртуальная частные сети - VPN  #
Домашнее задание: NAT, DNS, NTP;

Цель: Настроить GRE между офисами Москва и С.-Петербург Настроить DMVPN между офисами Москва и Чокурдах, Лабытнанги

1. Настроите GRE между офисами Москва и С.-Петербург
2. Настроите DMVMN между Москва и Чокурдах, Лабытнанги
3. Все узлы в офисах в лабораторной работе должны иметь IP связность

Решение: 
Cхема сети ipv4, ipv6

![](/LECTURES/MODULE04/Lecture33/pictures/42.jpg)

## Задание 1: Настроите GRE между офисами Москва и С.-Петербург10727

Немного поменял концепцию маршрутизации: теперь каждый EDGE имеет свой дефолтный маршрут, но EDGE 1 фильтрует входящие от EDGE2 маршруты:
```
router ospf 1
 router-id 1.1.1.1
...
 distribute-list prefix FILTER-0.0.0.0_FROM_EDGE1 in

ip prefix-list FILTER-0.0.0.0_FROM_EDGE1: 2 entries
   seq 5 deny 0.0.0.0/0
   seq 10 permit 0.0.0.0/0 le 32

router bgp 1001
 neighbor 172.17.0.25 remote-as 1001
 neighbor 172.17.0.25 update-source Loopback11
 !
 address-family ipv4
  neighbor 172.17.0.25 activate
  neighbor 172.17.0.25 route-map BLOCK-PREFIX-SPB in


ip prefix-list PREFIX-SPB: 1 entries
   seq 5 permit 50.50.96.0/24
```

Настройка GRE на туннеле c ip-адресом Loopback из диапазона нашей AS 1001 и активация на нем OSPF AREA19. Пример - для EDGE1, аналогично для EDGE2, только без дополнительной фильтрации.
```
interface Tunnel110501
 description 1-EDGE-R31-1
 bandwidth 11000
 ip address 172.17.15.33 255.255.255.248
 ipv6 enable
 ipv6 address FE80::1 link-local
 ip mtu 1400
 tunnel source Loo1001
 tunnel destination 50.50.96.1
no shut

router ospf 1
 no passive-interface Tunnel110501

ipv6 router ospf 1
 passive-interface Tunnel110501

interface Tunnel110501
 ip ospf network point-to-point
 ip ospf dead-interval 3
 ip ospf hello-interval 2
 ip ospf retransmit-interval 4
 ip ospf 1 area 19
 ipv6 ospf 1 area 19
no shut
```

Настройка ответных туннелей на EDGE-R31 СПб. Настройка представлена только для одного туннеля
```
### Loo с которого пойдут оба туннеля
interface Loopback2042
 ip address 50.50.96.1 255.255.255.255
 ipv6 address 2000:AAAD:2::1/128

### Настройка GRE с EDGE1
interface Tunnel110351
 description 1-EDGE1-1
 bandwidth 3500
 ip address 172.17.15.34 255.255.255.248
 ipv6 enable
 ipv6 address 3FFE:11::2/64
 ip mtu 1400
 tunnel source Loopback2042
 tunnel destination 35.10.10.1
no shut

router ospf 5
router-id 10.0.5.15
passive-interface default
no passive-interface Tunnel110351
redistribute eigrp 100 metric-type 1

ipv6 router ospf 5
router-id 10.0.5.15
no passive-interface Tunnel110351
exit

interface Tunnel110351
ipv6 enable
 ip ospf network point-to-point
 ip ospf 5 area 19
 ipv6 ospf 5 area 19
 ip ospf dead-interval 3
 ip ospf hello-interval 2
 ip ospf retransmit-interval 4
no shut
```

Маршруты успешно транслируются

![](/LECTURES/MODULE04/Lecture33/pictures/43.jpg)

И на нижнем DSWWAN1
![](/LECTURES/MODULE04/Lecture33/pictures/44.jpg)


## Задание 2: Настроите DMVMN между Москва и Чокурдах, Лабытнанги

Схема DMVPN представлена выше. DMVPN работает по схеме DUAL-HUB, поэтому на каждом из роутеров офисов - по два туннеля до соответствующего HUB. Растягиваем OSPF 0 на данные офисы. Настройка представлена для EDGE1, все остальные настройки - в конфигах устройств ниже
```
### Добавляем DMVPN
int Tunnel101
description ### DMVPN1 ###
tunnel mode gre multipoint
ip address 172.17.15.49 255.255.255.248
tunnel source Loo1001
ip mtu 1400
ip tcp adjust-mss 1360
ip nhrp network-id 101
ip nhrp authentication OTUS
ip nhrp map multicast dynamic

### Вбрасываем в туннель OSPF0
router ospf 1
 no passive-interface Tunnel101


interface Tunnel101
 ip ospf 1 area 0
 ip ospf network broadcast
 ip ospf dead-interval 3
 ip ospf hello-interval 2
 ip ospf retransmit-interval 4
no shut

```

## Задание 3: Все узлы в офисах в лабораторной работе должны иметь IP связность

Хосты получают IP от DHCP-сервера ЦО

![](/LECTURES/MODULE04/Lecture33/pictures/45.jpg)


У хостов есть свзность между собой через туннели
![](/LECTURES/MODULE04/Lecture33/pictures/46.jpg)

Задание выполнено


- Киторн (01):
   - [01-ISP1](/LECTURES/MODULE04/Lecture33/labs/configs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE04/Lecture33/labs/configs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE04/Lecture33/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE04/Lecture33/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE04/Lecture33/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE04/Lecture33/labs/configs/04-R26.txt)
- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE04/Lecture33/labs/configs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE04/Lecture33/labs/configs/03-01-EDGE2.txt)
      - [03-01-EDGEOSPF1](/LECTURES/MODULE04/Lecture33/labs/configs/03-01-EDGEOSPF1.txt)
   - Distribution UP: 
      - [03-02-DSWWAN1](/LECTURES/MODULE04/Lecture33/labs/configs/03-02-DSWWAN1.txt)
      - [03-02-DSWWAN2](/LECTURES/MODULE04/Lecture33/labs/configs/03-02-DSWWAN2.txt)
   - CORE:
      - [03-03-CORE1](/LECTURES/MODULE04/Lecture33/labs/configs/03-03-CORE1.txt)
      - [03-03-CORE2](/LECTURES/MODULE04/Lecture33/labs/configs/03-03-CORE2.txt)
   - Aggregation
      - [03-04-AGGRSWDC1](/LECTURES/MODULE04/Lecture33/labs/configs/03-04-AGGRSWDC1.txt)
      - [03-04-AGGRSWDC2](/LECTURES/MODULE04/Lecture33/labs/configs/03-04-AGGRSWDC2.txt)
         - ACCESS
            - [03-11-DCSW1](/LECTURES/MODULE04/Lecture33/labs/configs/03-11-DCSW1.txt)
            - [03-11-DCSW2](/LECTURES/MODULE04/Lecture33/labs/configs/03-11-DCSW2.txt)
   - Distribution DOWN
      - [03-05-DSWACC1](/LECTURES/MODULE04/Lecture33/labs/configs/03-05-DSWACC1.txt)
      - [03-05-DSWACC2](/LECTURES/MODULE04/Lecture33/labs/configs/03-05-DSWACC2.txt)
         - ACCESS
            - [03-10-ASW1](/LECTURES/MODULE04/Lecture33/labs/configs/03-10-ASW1.txt)
            - [03-10-ASW2](/LECTURES/MODULE04/Lecture33/labs/configs/03-10-ASW2.txt)
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE04/Lecture33/labs/configs/05-1-EDGE-R31.txt)
      - [05-01-EDGEEIGRP-R32](/LECTURES/MODULE04/Lecture33/labs/configs/05-1-EDGEEIGRP-R32.txt)
   - CollapsedCORE
      - [05-02-DSWCOLCORE16](/LECTURES/MODULE04/Lecture33/labs/configs/05-2-DSWCOLCORE16.txt)
      - [05-02-DSWCOLCORE17](/LECTURES/MODULE04/Lecture33/labs/configs/05-2-DSWCOLCORE17.txt)
   - ACCESS
      - [05-10-ASW3](/LECTURES/MODULE04/Lecture33/labs/configs/05-5-ASW3.txt)
      - [05-10-ASW4](/LECTURES/MODULE04/Lecture33/labs/configs/05-5-ASW4.txt)
- Чокурдах (06)
   - EDGE
      - [06-1-EDGE-R28](/LECTURES/MODULE04/Lecture33/labs/configs/06-1-EDGE-R28.txt)
   - ACCESS
      - [06-5-ASW29](/LECTURES/MODULE04/Lecture33/labs/configs/06-5-ASW29.txt)
- Лабытнанги (07)
   - EDGE
      - [07-1-EDGE-R27](/LECTURES/MODULE04/Lecture33/labs/configs/07-1-EDGE-R27.txt)

