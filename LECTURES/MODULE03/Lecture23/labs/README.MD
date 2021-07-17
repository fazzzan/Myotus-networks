# BGP. Основы #

Цель: Настроить BGP между автономными системами Организовать доступность между офисами Москва и С.-Петербург

ТЗ:
- Настроите eBGP между офисом Москва и двумя провайдерами - Киторн и Ламас;
- Настроите eBGP между провайдерами Киторн и Ламас;
- Настроите eBGP между Ламас и Триада;
- eBGP между офисом С.-Петербург и провайдером Триада;
- Организуете IP доступность между офисами Москва и С.-Петербург;

Настройка осуществляется одновременно для IPv4 и IPv6

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)


##  Задание 1,2,3,4

Типовая настройка оборудования схожа для всех R, типовая настройка представлена для ISP2: 

```
router bgp 301
 bgp router-id 10.0.2.2
 no bgp default ipv4-unicast
 neighbor 2000:AAAC:400::2 remote-as 1001
 neighbor 30.1.35.98 remote-as 1001
 neighbor 2000:AAAB:1:1::1 remote-as 101
 neighbor 100.1.1.65 remote-as 101
 neighbor 2000:AAAA:1:2::1 remote-as 520
 neighbor 52.0.56.69 remote-as 520

 !
 address-family ipv4
  neighbor 30.1.35.98 activate
  neighbor 100.1.1.65 activate
  neighbor 52.0.56.69 activate
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAC:400::2 activate
  neighbor 2000:AAAB:1:1::1 activate
  neighbor 2000:AAAA:1:2::1 activate
 exit-address-family

router bgp 301
 address-family ipv4
 network 30.1.35.96 mask 255.255.255.252
 network 100.1.1.64 mask 255.255.255.252
 network 52.0.56.68 mask 255.255.255.252
 address-family ipv6
  network 2000:AAAC:400::/64
  network 2000:AAAB:1:1::/64
  network 2000:AAAA:1:2::/64
```

Соседи BGP ISP2:

![](/LECTURES/MODULE03/Lecture23/pictures/26.jpg)

маршруты на ISP2

![](/LECTURES/MODULE03/Lecture23/pictures/27.jpg)


##  Задание 5: Настроен eBGP внутри ISP Триада 

Пример представлен для R24. Настройка на физических IF

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
   - [01-ISP1](/LECTURES/MODULE03/Lecture23/labs/configs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE03/Lecture23/labs/configs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE03/Lecture23/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE03/Lecture23/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE03/Lecture23/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE03/Lecture23/labs/configs/04-R26.txt)
- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE03/Lecture23/labs/configs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE03/Lecture23/labs/configs/03-01-EDGE2.txt)
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE03/Lecture23/labs/configs/05-1-EDGE-R31.txt)

