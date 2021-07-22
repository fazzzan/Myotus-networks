# iBGP #

Цель: Настроить iBGP в офисе Москва; Настроить iBGP в сети провайдера Триада; Организовать полную IP связанность всех сетей.

Первоначальное ТЗ:
- Настроите iBGP в офисе Москва между маршрутизаторами R14 и R15;
- Настроите iBGP в провайдере Триада;
- Настройте офиса Москва так, чтобы приоритетным провайдером стал Ламас;
- Настройте офиса С.-Петербург так, чтобы трафик до любого офиса распределялся по двум линкам одновременно;
- Все сети в лабораторной работе должны иметь IP связность;

Конечное ТЗ:
- Настроите iBGP в офисе Москва между маршрутизаторами EDGE1 и EDGE2;
- Настроите iBGP в провайдере Триада;
- Настройте офиса Москва так, чтобы приоритетным провайдером стал Лимас;
- Настройте офиса С.-Петербург так, чтобы трафик до любого офиса распределялся по двум линкам одновременно;
- Все сети в лабораторной работе должны иметь IP связность;


Настройка осуществляется одновременно для IPv4 и IPv6

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)


##  Задание 1

Настройка симметричная для обоих EDGE:
```
### Инициируем Lo11, вбрасываем его в OSPF
interface Loopback11
 ip address 172.17.0.25 255.255.255.248
 ipv6 address 2000:AAAD:1:103::1/64
 no shut
interface Lo11
 ip ospf 1 area 0
 ipv6 ospf 1 area 0

###Добавляем забытое
ipv6 router ospf 1
 default-information originate

### Дополняем BGP настройками iBGP
router bgp 1001
 neighbor 2000:AAAD:1:102::1 remote-as 1001
 neighbor 172.17.0.17 remote-as 1001
 !
 address-family ipv4
  neighbor 172.17.0.17 activate
  neighbor 172.17.0.17 update-source Loopback11
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAD:1:102::1 activate
  neighbor 2000:AAAD:1:102::1 update-source Loopback11
 exit-address-family

```
Соседство поднялоcь на обоих стеках IPv4 и IPv6

![](/LECTURES/MODULE03/Lecture24/pictures/32.jpg)
![](/LECTURES/MODULE03/Lecture24/pictures/30.jpg)
![](/LECTURES/MODULE03/Lecture24/pictures/31.jpg)

##  Задание 2

В предыдущем задании в провайдере ТРИАДА был настроен eBGP, на физических IF. Пришло время это изменить. eBGP поднимем на Lo11 роутеров и назначим R23 Route-Reflector: 

Используем ранее зарезервированную подсеть IPv6, а также частный диапазон адресов IPv4:

<details>
<summary>TRIADA: PRIVATE ADDR</summary>

| ТРИАДА, PRIVATE IPv4 |     | ТРИАДА, GUA IPv6 |      |                          |            |
|----------------------|-----|------------------|------|--------------------------|------------|
| NET Address          | NET |                  |      | Description              | примечание |
| LAN0 192.168.1.0 /24 |     |                  |      |                          |            |
| NET Address          | NET |                  |      | Description/Device(port) | примечание |
| 192.168.1.0          | /24 |                  |      |                          |            |
| 192.168.1.1          | /24 |                  |      |                          |            |
| …                    |     |                  |      |                          |            |
| 192.168.1.23         | /24 | 2000:AAAA::23    | /126 | R23 Lo11                 | R23 Lo11   |
| 192.168.1.24         | /24 | 2000:AAAA::24    | /126 | R24 Lo11                 | R24 Lo11   |
| 192.168.1.25         | /24 | 2000:AAAA::25    | /126 | R25 Lo11                 | R25 Lo11   |
| 192.168.1.26         | /24 | 2000:AAAA::26    | /126 | R26 Lo11                 | R26 Lo11   |
| …                    | /29 |                  |      |                          |            |
| 192.168.1.255        | /29 |                  |      |                          |            |
</details>

```
### Инициируем ISIS на Lo11
interface Loopback11
 ip address 192.168.1.23 255.255.255.255
 ipv6 address 2000:AAAA::23/126
 no shut

router isis 2222
 no passive-interface GigabitEthernet0/0
 passive-int lo11
exit

### Заменим принципы eBGB на iBGP для AS 520, сделаем R23 RR

router bgp 520
 no bgp default ipv4-unicast
 no neighbor 2000:AAAA::2 remote-as 520
 no neighbor 52.0.56.2 remote-as 520
 no neighbor 2000:AAAA::a remote-as 520
 no neighbor 52.0.56.10 remote-as 520
 no neighbor 2000:AAAA::1a remote-as 520
 no neighbor 52.0.56.26 remote-as 520


neighbor RRC_520 peer-group
neighbor RRC_520 remote-as 520
neighbor RRC_520 update-source loopback11
neighbor 192.168.1.24 peer-group RRC_520
neighbor 192.168.1.25 peer-group RRC_520
neighbor 192.168.1.26 peer-group RRC_520

neighbor RRC_520_v6 peer-group
neighbor RRC_520_v6 remote-as 520
neighbor RRC_520_v6 update-source loopback11
neighbor 2000:AAAA::24 peer-group RRC_520_v6
neighbor 2000:AAAA::25 peer-group RRC_520_v6
neighbor 2000:AAAA::26 peer-group RRC_520_v6


neighbor 2000:AAAA:1:1::2 remote-as 101
neighbor 52.0.56.66 remote-as 101

 !
address-family ipv4
neighbor RRC_520 route-reflector-client
 neighbor 192.168.1.24 activate
 neighbor 192.168.1.25 activate
 neighbor 192.168.1.26 activate
 neighbor 52.0.56.66 activate
exit-address-family
 !
address-family ipv6
neighbor RRC_520_v6 route-reflector-client
  neighbor 2000:AAAA::24 activate
  neighbor 2000:AAAA::25 activate
  neighbor 2000:AAAA::26 activate
  neighbor 2000:AAAA:1:1::2 activate
 exit-address-family


router bgp 520
 address-family ipv4
  network 52.0.56.0 mask 255.255.255.248
  network 52.0.56.8 mask 255.255.255.248
  network 52.0.56.64 mask 255.255.255.252
 exit-address-family
 !
 address-family ipv6
  network 2000:AAAA::/126
  network 2000:AAAA::8/126
  network 2000:AAAA:1:1::/64
 exit-address-family
 !
```

Настройка соседних роутеров R24, R25, R26 - чуть короче, приведен пример для R24
```
### Немного изменим ISIS и Инициируем ISIS на Lo11
interface Loopback11
 ip address 192.168.1.24 255.255.255.255
 ipv6 address 2000:AAAA::24/128
 no shut

router isis 0024
 no passive-interface GigabitEthernet0/0
 no passive-interface GigabitEthernet0/3
 passive-int lo11
exit


### Заменим принципы eBGB на iBGP для AS 520, сделаем R23 RR
router bgp 520
 no bgp default ipv4-unicast
 no neighbor 2000:AAAA::1 remote-as 520
 no neighbor 52.0.56.1 remote-as 520
 no neighbor 2000:AAAA::a remote-as 520
 no neighbor 52.0.56.10 remote-as 520
 no neighbor 2000:AAAA::1a remote-as 520
 no neighbor 52.0.56.26 remote-as 520

 neighbor 192.168.1.23 remote-as 520
 neighbor 192.168.1.23 update-source Loopback11
 neighbor 2000:AAAA::23 remote-as 520
 neighbor 2000:AAAA::23 update-source Loopback11

 neighbor 2000:AAAA:1:2::2 remote-as 301
 neighbor 52.0.56.70 remote-as 301
 neighbor 2000:AAAA:400::2 remote-as 2042
 neighbor 52.0.56.94 remote-as 2042

 !
address-family ipv4
no neighbor 52.0.56.1 activate
no neighbor 52.0.56.10 activate
no neighbor 52.0.56.26 activate

 neighbor 192.168.1.23 activate
 neighbor 52.0.56.70 activate
 neighbor 52.0.56.94 activate
 exit-address-family
 !
address-family ipv6
no neighbor 2000:AAAA::1 activate
no neighbor 2000:AAAA::a activate
no neighbor 2000:AAAA::1a activate

 neighbor 2000:AAAA::23 activate
 neighbor 2000:AAAA:1:2::2 activate
 neighbor 2000:AAAA:400::2 activate
exit-address-family

router bgp 520
 address-family ipv4
  network 52.0.56.68 mask 255.255.255.252
  network 52.0.56.0 mask 255.255.255.248
  network 52.0.56.92 mask 255.255.255.252
 exit-address-family
 !
 address-family ipv6
  network 2000:AAAA:1:2::/64
  network 2000:AAAA::/126
  network 2000:AAAA:400::/126
 exit-address-family
```

Соседи BGP R24 - Видно что их только 3, так как включен RR:

![](/LECTURES/MODULE03/Lecture24/pictures/29.jpg)

Также видно что маршруты на OUTSIDE префиксы расположены за Lo11 каждого роутера

![](/LECTURES/MODULE03/Lecture24/pictures/28.jpg)

##  Задание 3: Приоритетный провайдер Москвы - ЛИМАС

Одинаково боремся со всеми влетающими от ISP маршрутами
```
ip prefix-list DEFAULT-IN-PERMIT seq 5 permit 0.0.0.0/0
ipv6 prefix-list DEFAULT-IN-PERMIT-V6 seq 5 permit ::/0
router bgp 1001
 address-family ipv4
  neighbor 30.1.35.97 prefix-list DEFAULT-IN-PERMIT in 
 exit-address-family
 address-family ipv6
  neighbor 2000:AAAC:400::1 prefix-list DEFAULT-IN-PERMIT-V6 in
 exit-address-family
```
Настроен отлов AS-PATH 301 провайдера ЛИМАС
```
ip as-path access-list 1 permit ^301$

route-map FILTER-DEFAULT-V4 permit 10
 match as-path 1
 set local-preference 150

route-map FILTER-DEFAULT-V6 permit 10
 match as-path 1
 set local-preference 50

router bgp 1001
 address-family ipv4
  neighbor 100.1.1.97 route-map FILTER-DEFAULT-V4 in
 exit-address-family
 address-family ipv6
  neighbor 2000:AAAB:400::1 route-map FILTER-DEFAULT-V6 in
 exit-address-family
```
На EDGE1 была получена ошибка в RIB, которая происходила из-за того что нулевка прилетала по OSPF от EDGE2. Пришлось на обоих EDGE настроить большую AD у iBGP, чем OSPF.
```
router bgp 1001
  address-family ipv4
   distance bgp 20 50 110
 exit-address-family
 !
 address-family ipv6  
   distance bgp 20 50 110
 exit-address-family
```

Полученная таблица маршрутизации обоих EDGE
![](/LECTURES/MODULE03/Lecture24/pictures/33.jpg)
![](/LECTURES/MODULE03/Lecture24/pictures/34.jpg)

При этом в самой таблице префиксов BGP - префикса 2, но дефолтный - ЛИМАС
![](/LECTURES/MODULE03/Lecture24/pictures/35.jpg)

##  Задание 4: Донастроить СПб и заставить трафик бегать по обоим линкАм

Сначала заставили R26 вбрасывать дефолтные маршруты в BGP
```
### Вбрасываем default маршруты в R31 справа
router bgp 520
 address-family ipv4
  neighbor 52.0.56.98 default-originate
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAA:401::2 default-originate
 exit-address-family
```
Затем в EIGRP настроили редистрибуцию BGP в EIGRP и отфильтровали нулевку

```
router eigrp NG
 !
 address-family ipv4 unicast autonomous-system 100
  topology base
  redistribute bgp 2042 metric 100 1 255 1 1500
  exit-af-topology
 address-family ipv6 unicast autonomous-system 100 
  topology base
  redistribute bgp 2042 metric 100 1 255 1 1500
  exit-af-topology
```

Заставляем машрутизатор R31 фильтравать префиксы по-умолчанию через префикс-лист:
```

ip prefix-list ONLYZERO seq 5 permit 0.0.0.0/0
ipv6 prefix-list ONLYZEROV6 seq 5 permit ::/0

router eigrp NG
address-family ipv4 unicast autonomous-system 100
topology base
distribute-list prefix DEFAULT-ONLY out

address-family ipv6 unicast autonomous-system 100
topology base
distribute-list prefix-list DEFAULT-ONLY-V6 out
```
после этого удаляем старые нулевки с трекингом
```
no ip route 0.0.0.0 0.0.0.0 52.0.56.93 track 3
no ip route 0.0.0.0 0.0.0.0 52.0.56.97 10
```

Включаем поддержку одновременно 2 префиксов - через обоих ISP
```
router bgp 2042
 address-family ipv4
  maximum-path 2
 exit-address-family
 address-family ipv6
  maximum-path 2
 exit-address-family
```
Замечен недостаток: в случае если отваливается активный канал - BGP достаточно долго реагирует - таймер 180 секунд, трогать пока не стал. Также проблмы с NAT - после отвала ISP надо принудительно разорвать трансляцию, чтобы трафик пошел уже через нового ISP.

##  Задание 5: Связность IP-сетей 

Все офисы видят друг друга, даже при частично отключенных ISP линкАх, но ввиду того что Триада внутри не имеет полной IGP - связности, перерыв связи между R23 и R25 приводит к недоступности бранчей Лабытнанги и Чокурдах. На примере видно что R31 отвечает из диапазона своей AS запросу из AS 1001

![](/LECTURES/MODULE03/Lecture24/pictures/36.jpg)

Ниже представлено IPv6 взаимодейтсвие между EDGE1 и AS101 EIGRP офиса СПб

![](/LECTURES/MODULE03/Lecture24/pictures/37.jpg)

Проверка доступности из МСК IPv6 адресов из споуков:

![](/LECTURES/MODULE03/Lecture24/pictures/39.jpg)

Маршруты в ЛИМАС в наличии

![](/LECTURES/MODULE03/Lecture24/pictures/40.jpg)

Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.


- Киторн (01):
   - [01-ISP1](/LECTURES/MODULE03/Lecture24/labsconfigs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE03/Lecture24/labsconfigs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE03/Lecture24/labsconfigs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE03/Lecture24/labsconfigs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE03/Lecture24/labsconfigs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE03/Lecture24/labsconfigs/04-R26.txt)
- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE03/Lecture24/labsconfigs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE03/Lecture24/labsconfigs/03-01-EDGE2.txt)
      - [03-01-EDGEOSPF1](/LECTURES/MODULE03/Lecture24/labsconfigs/03-01-EDGEOSPF1.txt)
   - Distribution UP: 
      - [03-02-DSWWAN1](/LECTURES/MODULE03/Lecture24/labsconfigs/03-02-DSWWAN1.txt)
      - [03-02-DSWWAN2](/LECTURES/MODULE03/Lecture24/labsconfigs/03-02-DSWWAN2.txt)
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE03/Lecture24/labsconfigs/05-1-EDGE-R31.txt)
      - [05-01-EDGEEIGRP-R32](/LECTURES/MODULE03/Lecture24/labsconfigs/05-1-EDGEEIGRP-R32.txt)
   - CollapsedCORE
      - [05-02-DSWCOLCORE16](/LECTURES/MODULE03/Lecture24/labsconfigs/05-2-DSWCOLCORE16.txt)
      - [05-02-DSWCOLCORE17](/LECTURES/MODULE03/Lecture24/labsconfigs/05-2-DSWCOLCORE17.txt)
- Чокурдах (06)
   - EDGE
      - [06-1-EDGE-R28](/LECTURES/MODULE03/Lecture24/labsconfigs/06-1-EDGE-R28.txt)
- Лабытнанги (07)
   - EDGE
      - [07-1-EDGE-R27](/LECTURES/MODULE03/Lecture24/labsconfigs/07-1-EDGE-R27.txt)

