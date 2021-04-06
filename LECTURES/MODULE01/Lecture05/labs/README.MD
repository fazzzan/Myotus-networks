
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
![](/LECTURES/MODULE01/Lecture05/pictures/45. jpg)

В конфиге SA-11 указал ipv6 - адрес на VLAN 100, также указал маршрут ::0/0
```
SA-11(config)#int vlan 100
SA-11(config-if)#ipv6 address 2001:db8:acad:1::2/64
SA-11(config-if)#no shut

SA-11(config-if)#
*Apr  6 21:36:13.959: %LINK-3-UPDOWN: Interface Vlan100, changed state to up
*Apr  6 21:36:14.959: %LINEPROTO-5-UPDOWN: Line protocol on Interface Vlan100, changed state to upexit
...
SA-11(config)#ipv6 unicast-routing - пока не понятно зачем
SA-11(config)#do ping 2001:db8:acad:1::1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 2001:DB8:ACAD:1::1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 1/3/12 ms
SA-11(config)#ipv6 route ::/0 2001:db8:acad:1::1
```

И после этого обнаружил что ПК получил ipv6. Причем шзм6 получил как Win7, так и PCA1.

[Дамп получения ipv6 тут](DHCPv6-get.pcapng)
