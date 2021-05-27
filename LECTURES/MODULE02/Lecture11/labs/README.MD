# PBR офисе Чокурдах #

Схема офиса Чокурдах с нанесенным адресным пространством:

![](/LECTURES/MODULE02/Lecture10/pictures/26.jpg)

Настройка NAT
```
interface GigabitEthernet0/0.110
 ip nat outside

interface GigabitEthernet0/0.120
 ip nat outside

interface GigabitEthernet0/1.61
 ip nat inside

interface GigabitEthernet0/1.71
 ip nat inside
```

Создание route-map, который будет создавать сессии NAT для соответствующего выходного IF
```
route-map ISP1 permit 10
 match interface GigabitEthernet0/0.110
!
route-map ISP2 permit 10
 match interface GigabitEthernet0/0.120
!
!
ip nat inside source route-map ISP1 interface GigabitEthernet0/0.110 overload
ip nat inside source route-map ISP2 interface GigabitEthernet0/0.120 overload
```

Для реализации pbr, на ISP1 (Киторн) настроены следующие Loopback - адреса:
- Loopback1 8.8.4.4
- Loopback2 8.8.5.5

Реализации pbr выполнена с учетом возможности обрыва связи как на самом линке - подключении к провайдеру, так и на вышестоящих линках роутеров провайдера.


Настройка IP SLA на переключение маршрутов, в зависимости от состояния ISP1 - R26, доступность к которому проверяем с VLAN 110

```
ip sla 441  
 icmp-echo 8.8.4.4 source-interface GigabitEthernet0/0.110
 frequency 5
ip sla schedule 441 life forever start-time now
!
ip sla 5681
 icmp-echo 52.0.56.81 source-interface GigabitEthernet0/0.110
 frequency 5
ip sla schedule 5681 life forever start-time now
```

Трэкинг делаем составной, чтобы отловить как падение линкА до самого R26, так и падение его вышестоящих линкОв
```
track 1 ip sla 441 reachability
!
track 2 ip sla 5681 reachability
!
track 3 list boolean and
 object 1 
 object 2
 delay down 2 up 3
```

Настройка дефолтных маршрутов, в зависимости от состояния трека и добавление проверки 8.8.4.4 через ISP1 - R26
```
ip route 0.0.0.0 0.0.0.0 52.0.56.81 track 3
ip route 0.0.0.0 0.0.0.0 52.0.56.85 10
ip route 8.8.4.4 255.255.255.255 GigabitEthernet0/0.110 52.0.56.81
```
Чтобы реализовать распределение трафика по провайдерам, добавляем отслеживание второго ISP (track6)

```
ip sla 551  
 icmp-echo 8.8.5.5 source-interface GigabitEthernet0/0.120
 frequency 5
ip sla schedule 551 life forever start-time now
!
ip sla 5685
 icmp-echo 52.0.56.85 source-interface GigabitEthernet0/0.120
 frequency 5
ip sla schedule 5685 life forever start-time now
!
ip route 8.8.5.5 255.255.255.255 GigabitEthernet0/0.120 52.0.56.85
!
track 4 ip sla 551 reachability
!
track 5 ip sla 5685 reachability
!
track 6 list boolean and
 object 4 
 object 5
 delay down 2 up 3
```
Выделяем интересующий трафик из соответствующих подсетей:
```
ip access-list extended VLAN61
 permit ip 172.19.64.0 0.0.0.255 any
ip access-list extended VLAN71
 permit ip 172.19.70.0 0.0.0.63 any
```

После чего настраиваем route-map для каждого VLAN, чтобы использовать оба ISP:
   - VLAN61-ISP1(def)-ISP2(secondary)
   - VLAN71-ISP2(def)-ISP1(secondary)

```
route-map PBR-ISP1 permit 10
 match ip address VLAN61
 set ip next-hop verify-availability 52.0.56.81 10 track 3
 set ip next-hop verify-availability 52.0.56.85 20 track 6
!
route-map PBR-ISP2 permit 10
 match ip address VLAN71
 set ip next-hop verify-availability 52.0.56.85 10 track 6
 set ip next-hop verify-availability 52.0.56.81 20 track 3
```

Вешаем соответствующие роут-мапы на внутренние сабы
```
interface GigabitEthernet0/1.61
 ip policy route-map PBR-ISP1
!         
interface GigabitEthernet0/1.71
 ip policy route-map PBR-ISP2
```

Дополнительно настраиваем временный DHCP, чтобы клиенты автоматически получали IPv4.

[06-1-EDGE-R28](/LECTURES/MODULE02/Lecture10/labs/06-1-EDGE-R28-PBR.txt)