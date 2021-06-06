___Небольшая л/р BGP IPv4/IPv6___

![](/LECTURES/MODULE02/Lecture22/pictures/70.jpg)

AS64501 - Сначала базовый конфиг, затем IPv4, IPv6
```
ipv6 unicast-routing
ipv6 cef
!
router bgp 64501
 bgp router-id 2.2.2.1
 neighbor 101.0.0.2 remote-as 64500
 neighbor 101.0.0.6 remote-as 64502
 neighbor 101.0.0.10 remote-as 64503
 !
 no bgp default ipv4-unicast
 !
 neighbor 2001:1111::2 remote-as 64502
 !
 address-family ipv4
  network 104.0.0.0 mask 255.255.240.0
  neighbor 101.0.0.2 activate
  neighbor 101.0.0.6 activate
  neighbor 101.0.0.10 activate
 exit-address-family
 !
 address-family ipv6
  neighbor 2001:1111::2 activate
  network 2001:AAAA::1/128
 exit-address-family
```

AS 64502 - аналогично
```
ipv6 unicast-routing
ipv6 cef
!
router bgp 64502
 bgp router-id 2.2.2.2
 neighbor 101.0.0.5 remote-as 64501
 neighbor 102.0.0.2 remote-as 64500
 neighbor 102.0.0.10 remote-as 64503
 !
 no bgp default ipv4-unicast
 !
 neighbor 2001:1111::1 remote-as 64501
 !
 address-family ipv4
  network 105.0.0.0 mask 255.255.248.0
  neighbor 101.0.0.5 activate
  neighbor 102.0.0.2 activate
  neighbor 102.0.0.10 activate
 exit-address-family
 !
 address-family ipv6
  neighbor 2001:1111::1 activate
  network 2001:BBBB::1/128
 exit-address-family
```

пиринг поднимается:
```
AS64501#
*Jun  6 12:41:10.109: %BGP-5-ADJCHANGE: neighbor 2001:1111::2 Up 
*Jun  6 12:41:13.506: %BGP-5-ADJCHANGE: neighbor 101.0.0.6 Up 

AS64502(config-router)#
*Jun  6 12:41:09.462: %BGP-5-ADJCHANGE: neighbor 2001:1111::1 Up 
*Jun  6 12:41:12.860: %BGP-5-ADJCHANGE: neighbor 101.0.0.5 Up 
```

Сессии у нас 2, что не очень хорошо:
![](/LECTURES/MODULE02/Lecture22/pictures/71.jpg)

___Выполним второй вариант настройки___

В контексте BGP на обоих RR ```no address-family ipv6```

```
*Jun  6 12:46:11.981: %BGP_SESSION-5-ADJCHANGE: neighbor 2001:1111::2 IPv6 Unicast topology base removed from session  Neighbor deleted
*Jun  6 12:46:11.982: %BGP-5-ADJCHANGE: neighbor 2001:1111::2 Down Neighbor deleted
```

```
route-map INE permit
 set ipv6 next-hop 2001:1111::1
 exit 
!
router bgp 64501
address-family ipv6 unicast
 neighbor 101.0.0.6 activate
 neighbor 101.0.0.6 route-map INE out
 network 2001:aaaa::/64
 exit
 exit 
```

```
route-map INE permit
 set ipv6 next-hop 2001:1111::2
 exit 
!
router bgp 64502
address-family ipv6 unicast
 neighbor 101.0.0.5 activate
 neighbor 101.0.0.5 route-map INE out
 network 2001:bbbb::/64
 exit
 exit 
```
Проверка:
```
AS64501(config-router-af)#do sho ipv6 route bgp
...    B - BGP, HA - Home Agent, MR - Mobile Router, R - RIP
...
B   2001:BBBB::/64 [20/0]
     via FE80::EF7:38FF:FE17:6302, GigabitEthernet0/2

AS64501(config-router-af)#do ping ipv6 2001:bbbb::1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 2001:BBBB::1, timeout is 2 seconds:
!!!!!

...
AS64502(config-router-af)#do sho ipv6 route bgp
...
       B - BGP, HA - Home Agent, MR - Mobile Router, R - RIP
...
B   2001:AAAA::/64 [20/0]
     via FE80::EF7:38FF:FECA:8F02, GigabitEthernet0/2
```
Ниже представлен ответ от 64501 BGP-OPEN и внутри TCPv4 сессии указаны данные для IPv6

![](/LECTURES/MODULE02/Lecture22/pictures/74.jpg)

Далее представлено как 64502 анонсирует 2001:bbbb::/64 через корректный next-hop

![](/LECTURES/MODULE02/Lecture22/pictures/73.jpg)

Еще проверка:

![](/LECTURES/MODULE02/Lecture22/pictures/75.jpg)

![](/LECTURES/MODULE02/Lecture22/pictures/76.jpg)