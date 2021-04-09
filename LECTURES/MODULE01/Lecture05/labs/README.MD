
# Lab - Внедрение DHCPv4
## Задание: [docx](7.4.2_Lab-Implement_DHCPv4.docx)

##  Задание:
1. Создание сети, настройка основных параметров устройств
2. Настройка 2 DHCPv4 на R1
3. Настроить DHCP Relay на R2

###  Решение:
1. Графическая схема до начал работы, с нанесенной информацией о ip-адресации

![](/LECTURES/MODULE01/Lecture05/pictures/41.jpg)

2. Разбиение адресного пространства, согласно заданию.

![](/LECTURES/MODULE01/Lecture05/pictures/43.jpg)

![](/LECTURES/MODULE01/Lecture05/pictures/42.jpg)

3. Конфигурация настроек выполнена с применением логина/пароля otus/class

Настройка SW выполнена в соответствии с описанием в файлах
- [SA-1](cfg/SA-1.cfg), 
- [SB-1](cfg/SB-1.cfg), 
- [RA-1](cfg/RA-1.cfg),
- [RB-1](cfg/RB-1.cfg).

Были выполнены базовые настройки безопасности на портах SA-1, SA-2:
```
int ra Gi0/0 - 3, gi1/0 - 3, gi2/0 - 3, gi3/0 - 3
 switchport mode access
 switchport access vlan 999
 swi port-sec
 swi port-sec max 4
 swi port-sec mac-addr stick
 swi port-sec viol shutdown
 spanning-tree portfast
 spanning-tree bpduguard enable
 no negotiation auto
```
а именно:
1. Все порты по-умолчанию сотнесены с VLAN 999, который не входит в доверенные на транковом порту/аплинке ```switchport access vlan 999```
2. Включен port-sec на всех портах, с максимальным значением 4 разрешенных MAC-адресов ```swi port-sec max 4```, 
3. MAC-адреса на порту будут появляться динамически и заноситься в startup-config ```swi port-sec mac-addr stick```. В результате чего, после получения DHCP в конфигурацию попали MAC-адреса подключенных к access-портам клиентов
```
interface GigabitEthernet0/1
...
 switchport port-security mac-address sticky 0050.7966.6800
```
4. При включении 5-го клиента, порт будет блокироваться ```swi port-sec viol shutdown```
5. Оптимизирован режим работы STP на access-IF ```spanning-tree portfast```
6. Включен на всех IF режим блокировки порта при несанкционированном включении SW - ```spanning-tree bpduguard enable```

Были выполнены базовые настройки безопасности на uplink SA-1, SA-2:
```
interface GigabitEthernet0/0
 switchport trunk allowed vlan 100,200,1000
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 1000
 switchport mode trunk
 no negotiation auto
 spanning-tree guard root
 ip dhcp snooping trust
```
а именно:
1. заданы разрешенный VLAN ```switchport trunk allowed vlan 100,200,1000```
2. Задан native VLAN ```switchport trunk native vlan 1000```, которому не соответствует ip-адрес на RA-1
3. Для протокола STP жестко закрепили Uplink - линком в ROOT ```spanning-tree guard root```
4. Задали доверенный DHCP- порт ```ip dhcp snooping trust```

### получение IP-адреса
в результате настроек DHCP на RA-1, и relay (ip helper address 10.0.0.1) на inside IF RA-2, оба клиента оказались в состоянии получить ip-адреса:
```
RA-1#sho ip dhcp bind
Bindings from all pools not associated with VRF:
IP address          Client-ID/              Lease expiration        Type
                    Hardware address/
                    User name
192.168.1.11        0100.5079.6668.00       Apr 06 2021 09:44 PM    Automatic
192.168.1.101       0100.5079.6668.01       Apr 06 2021 09:54 PM    Automatic
...
RA-1#sho ip dhcp server statistics 
Memory usage         42078
Address pools        2
Database agents      0
Automatic bindings   2
Manual bindings      0
Expired bindings     0
Malformed messages   0
Secure arp entries   0

Message              Received
BOOTREQUEST          0
DHCPDISCOVER         4
DHCPREQUEST          2
DHCPDECLINE          0
DHCPRELEASE          0
DHCPINFORM           0

Message              Sent
BOOTREPLY            0
DHCPOFFER            2
DHCPACK              2
DHCPNAK              0
```
### Выводы 
Оба клиента с первого рпаза получили ip-адреса. 
Схема подходит для использованию внутри локальной сети, в случае, если DHCP - сервер небольшой компании обеспечивает работу нескольких маршрутизируемых сегментов, скажем RA-1 - LAN, RB-1 - Wi-Fi

Для большой компании рекомендуется поднимать кластер DHCP на базе Windows server, или какого-либо решения Linux.




# Lab - Внедрение DHCPv6
## Задание: [docx](8.5.1_Lab-Configure_DHCPv6.docx)

##  Задание:
1. Создание сети, настройка основных параметров устройств
2. Проверка работы SLAAC: назначение адресов от R1
3. Настроить и проверить Stateless DHCPv6 на R1
4. Настроить и проверить Statefull DHCPv6 на R1
5. Настроить и проверить DHCPv6 relay на R2

###  Решение:
1. Графическая схема до начал работы, с нанесенной информацией о ip-адресации

![](/LECTURES/MODULE01/Lecture05/pictures/44.jpg)

Также хорошая картинка для примера настройки IPv6 
![](/LECTURES/MODULE01/Lecture05/pictures/45.jpg)

Настройка SW выполнена в соответствии с описанием в файлах
- [SA-11](cfg/SA-11.cfg), 
- [SB-11](cfg/SB-11.cfg), 
- [RA-11](cfg/RA-11.cfg),
- [RB-11](cfg/RB-11.cfg).

2. Настроим SW1 (создаем SVI 200, глушим все порты, задаем access, trunk), R1 (SUBif, WAN if), проверим работу SLAAC

SW1: Настройка Access - портов, Настройка Uplinks 
```
interface Vlan200
 no ip address
 ipv6 address FE80::2 link-local
 ipv6 address 2001:DB8:ACAD:200::2/64
...
interface Gi0/1
 switchport access vlan 100
no shut
exit
...
interface Gi0/0
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 100,200,1000
 switchport trunk native vlan 1000
 spanning-tree guard root
 no negotiation auto 
 no shut
exit 
```

RA-11: SUBif, WAN if, ipv6 unicast-routing - рассылка RA (флаги A=1;O=0;M=0 по-умолчанию) для SLAAC
```
interface Ethernet0/0
 description ### TO WAN ###
 ipv6 address 2001:db8:acad:2::1/64 
 ipv6 address fe80::1 link-local
no shut
exit
!
interface Ethernet0/1
no shut
exit
!

interface Ethernet0/1.100
description ### Link to LAN ###
 encapsulation dot1Q 100
 ipv6 address fe80::1 link-local
 ipv6 address 2001:db8:acad:100::1/64
 ipv6 unicast-routing - рассылка RA (флаги A=1;O=0;M=0 по-умолчанию)
 no shut 
exit
!
! 
interface Ethernet0/1.200
description ### Link to MGM ###
 encapsulation dot1Q 200
 ipv6 address fe80::1 link-local
 ipv6 address 2001:db8:acad:200::1/64
 no shut  
exit
!

interface Ethernet0/1.1000
 description ### Native ###
 encapsulation dot1Q 1000
 no shut
```

В конфиге SA-11 указал ipv6 - адрес на MGM VLAN 200 и ничего про маршрутизацию, при этом ping до RA-11 заработал. После включения PCa1 - ПК получил создал самостоятельно IPv6 адрес и оказался в состоянии достучаться до RA-11.
Также PCa1 заменил Win7. Процедура SLAAC получения  - IPv6-адреса представлена ниже

![](/LECTURES/MODULE01/Lecture05/pictures/46.jpg)

Проверка связности:

![](/LECTURES/MODULE01/Lecture05/pictures/47.jpg)

2. Настроим RB-11 (SUBif, WAN if), настроим на RA-11 маршрут до правой части сети, проверим  ip-связность

```
RB-11: 
interface Ethernet0/0
 description ### TO WAN ###
 ipv6 address 2001:db8:acad:2::2/64 
 ipv6 address fe80::2 link-local
 duplex auto
 no shut
!
interface Ethernet0/1
 no ip address
 duplex auto
 no shut
!
interface Ethernet0/1.1
 description ### LAN-B ###
 encapsulation dot1Q 1
 ipv6 address 2001:db8:acad:3::1/64
 ipv6 helper-address 10.0.0.1
 no shut 
!
interface Ethernet0/1.1000
 description ### Native ###
 encapsulation dot1Q 1000 native
 no shut

ipv6 route 2001:DB8:ACAD:1::/64 2001:DB8:ACAD:2::1

RA-11
ipv6 route 2001:db8:acad:1::0/64 2001:db8:acad:2::1
```

после настроек PCA1 смог достучаться до правой части сети

![](/LECTURES/MODULE01/Lecture05/pictures/48.jpg)


3. Настроим RA-11 на DHCPv6 Stateless (pool, SubIF e0/1.100), проверим получение PCA1 ipv6 и связность

```
ipv6 dhcp pool R1-STATELESS
dns-server 2001:db8:acad::254
domain-name fz.otus.local

interface Ethernet0/1.100
description ### Link to LAN ###
 ipv6 nd other-config-flag
 ipv6 dhcp server R1-STATELESS
exit
```
Проверка:
```
RA-11#sho ipv6 dhcp interface 
Ethernet0/1.100 is in server mode
  Using pool: R1-STATELESS
  Preference value: 0
  Hint from client: ignored
  Rapid-Commit: disabled
```

Cвойства IF ПК до STATELESS

![](/LECTURES/MODULE01/Lecture05/pictures/49.jpg)

и после - появился DNS-сервер, DNS-суффикс

![](/LECTURES/MODULE01/Lecture05/pictures/50.jpg)

3. Настроим RA-11 на DHCPv6 Statefull (pool, SubIF e0/1.100), проверим получение PCA1 ipv6 и связность

```
ipv6 dhcp pool R1-STATEFUL
address prefix 2001:db8:acad:100::/64
dns-server 2001:db8:acad::254
domain-name fz1.otus.local

interface Ethernet0/1.100
description ### Link to LAN ###
 no ipv6 nd other-config-flag
 no ipv6 dhcp server IPV6-STATELESS
 ipv6 nd managed-config-flag - (флаг M=1)
 ipv6 nd prefix default no-advertise - (флага A=0)
 ipv6 dhcp server R1-STATEFUL
exit
```

Проверка:
```
RA-11#sho ipv6 dhcp interface 
Ethernet0/1.100 is in server mode
  Using pool: R1-STATEFUL
  Preference value: 0
  Hint from client: ignored
  Rapid-Commit: disabled
```

Процесс получения адреса, полученный адрес, диапазоны пулов и арендованные ipv6-адрес представлены на рисунке ниже

![](/LECTURES/MODULE01/Lecture05/pictures/51.jpg)

проверка ipv6-связности до правой части

![](/LECTURES/MODULE01/Lecture05/pictures/52.jpg)

4. Настроим RB-11 на DHCPv6 Statefull (pool, IF e0/0), SB-11, проверим получение ipv6 с правой стороны и связность

![](/LECTURES/MODULE01/Lecture05/pictures/54.jpg)

SB-11
```
interface Vlan1
 ipV6 address 2001:db8:acad:3::2/64
 no shut
exit 

interface Gi0/0
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 1,1000
 switchport trunk native vlan 1000
 spanning-tree guard root
 no negotiation auto 
no shut
 exit

interface Gi0/1
 switchport access vlan 1  
```

RB-11
```
interface Ethernet0/0
 description ### TO WAN ###
 ipv6 address 2001:db8:acad:2::2/64 
 ipv6 address fe80::2 link-local
 duplex auto
 no shut

interface Ethernet0/1
 no ip address
 duplex auto
 no shut
!
interface Ethernet0/1.1
 description ### LAN-B ###
 encapsulation dot1Q 1
 ipv6 address 2001:db8:acad:3::1/64
 ipv6 dhcp relay destination 2001:DB8:ACAD:2::1 Ethernet0/0
 no shut 
!
interface Ethernet0/1.1000
 description ### Native ###
 encapsulation dot1Q 1000 native
 no shut
!
ipv6 route 2001:db8:acad:100::0/64 2001:db8:acad:2::1
```
RA-11 на новый   pool, который повесим на WAN-IF
```
ipv6 dhcp pool R2-STATEFUL
address prefix 2001:db8:acad:3::/64 - задаем сегмент
dns-server 2001:db8:acad::254
domain-name fz3.otus.local

interface Ethernet0/0
 ipv6 nd managed-config-flag - (флаг M=1)
 ipv6 dhcp server R2-STATEFUL

exit
```
В результате, после подключения клиентом Win7, на DHCPv6, выдались ipv6 через relay

```
RA-11#sho ipv6 dhcp binding 
Client: FE80::B03A:F97B:44EC:CC1B 
  DUID: 000100011E996657500000010000
  Username : unassigned
  VRF : default
  IA NA: IA ID 0x0E500000, T1 43200, T2 69120
    Address: 2001:DB8:ACAD:100:8045:D5F0:C5BA:4C5B
            preferred lifetime 86400, valid lifetime 172800
            expires at Apr 11 2021 11:15 PM (169034 seconds)
Client: FE80::B03A:F97B:44EC:CC1B 
  DUID: 000100011E996657500000010000
  Username : unassigned
  VRF : default
  IA NA: IA ID 0x0E500000, T1 43200, T2 69120
    Address: 2001:DB8:ACAD:3:DC34:C07F:95A5:5F17
            preferred lifetime 86400, valid lifetime 172800
            expires at Apr 12 2021 12:09 AM (172245 seconds)
```

![](/LECTURES/MODULE01/Lecture05/pictures/53.jpg)


