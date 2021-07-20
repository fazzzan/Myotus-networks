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

##  Задание 5: Настроен iBGP внутри ISP Триада 

Пример представлен для R24.

```
router bgp 520
 no bgp default ipv4-unicast
 neighbor 2000:AAAA:1:2::2 remote-as 301
 neighbor 52.0.56.70 remote-as 301
 neighbor 2000:AAAA:400::2 remote-as 2042
 neighbor 52.0.56.94 remote-as 2042
 neighbor 2000:AAAA::1 remote-as 520
 neighbor 52.0.56.1 remote-as 520
 neighbor 2000:AAAA::a remote-as 520
 neighbor 52.0.56.10 remote-as 520
 neighbor 2000:AAAA::1a remote-as 520
 neighbor 52.0.56.26 remote-as 520


 !
 address-family ipv4
 neighbor 52.0.56.10 activate
 neighbor 52.0.56.26 activate
  neighbor 52.0.56.70 activate
  neighbor 52.0.56.1 activate
  neighbor 52.0.56.94 activate
 exit-address-family
 !
 address-family ipv6
neighbor 2000:AAAA::a activate
 neighbor 2000:AAAA::1a activate
  neighbor 2000:AAAA:1:2::2 activate
  neighbor 2000:AAAA::1 activate
  neighbor 2000:AAAA:400::2 activate
 exit-address-family

router bgp 520
 address-family ipv4
  network 52.0.56.68 mask 255.255.255.252
  network 52.0.56.0 mask 255.255.255.248
  network 52.0.56.92 mask 255.255.255.252 
 address-family ipv6
  network 2000:AAAA:1:2::/64
  network 2000:AAAA::/126
  network 2000:AAAA:400::/126
```
Все офисы видят друг друга, даже при отключенных ISP линкАх, но ввиду того что Триада внутри не имеет полной IGP - связности, перерыв связи между R23 и R25 приводит к недоступности бранчей Лабытнанги и Чокурдах  



Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.

- Киторн (01):
   - [01-ISP1](/LECTURES/MODULE03/Lecture24/labs/configs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE03/Lecture24/labs/configs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE03/Lecture24/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE03/Lecture24/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE03/Lecture24/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE03/Lecture24/labs/configs/04-R26.txt)
- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE03/Lecture24/labs/configs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE03/Lecture24/labs/configs/03-01-EDGE2.txt)
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE03/Lecture24/labs/configs/05-1-EDGE-R31.txt)

