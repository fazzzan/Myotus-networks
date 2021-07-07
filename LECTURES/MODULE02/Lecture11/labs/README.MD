# PBR #
Домашнее задание: PBR
Цель: Настроить политику маршрутизации в офисе Чокурдах Распределить трафик между 2 линками

1. Настроите политику маршрутизации для сетей офиса
2. Распределите трафик между двумя линками с провайдером
3. Настроите отслеживание линка через технологию IP SLA
4. Настройте для офиса Лабытнанги маршрут по-умолчанию

Решение: 
Схема офиса Чокурдах с нанесенным адресным пространством:

![](/LECTURES/MODULE02/Lecture11/pictures/26.jpg)


Для реализации pbr, на ISP1 (Киторн) настроены следующие Loopback - адреса:
- Loopback1 8.8.4.4
- Loopback2 8.8.5.5

Реализации pbr выполнена с учетом возможности обрыва связи как на самом линке - подключении к провайдеру, так и на вышестоящих линках роутеров провайдера.

Итак, чтобы заработали п.п. 1,3 задания, настроим IP SLA на переключение маршрутов, в зависимости от состояния ISP1 - R26, доступность к которому проверяем с VLAN 110

```
ip sla 441  
 icmp-echo 8.8.4.4 source-interface GigabitEthernet0/0.110
 frequency 5
ip sla schedule 441 life forever start-time now
!
ip sla 5681
 icmp-echo 52.0.56.101 source-interface GigabitEthernet0/0.110
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
ip route 0.0.0.0 0.0.0.0 52.0.56.101 track 3
ip route 0.0.0.0 0.0.0.0 52.0.56.105 10
ip route 8.8.4.4 255.255.255.255 GigabitEthernet0/0.110 52.0.56.101
```

Чтобы реализовать распределение трафика по провайдерам (Задание 2), добавляем отслеживание второго ISP (track6)

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
ip route 8.8.5.5 255.255.255.255 GigabitEthernet0/0.120 52.0.56.105
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
 set ip next-hop verify-availability 52.0.56.101 10 track 3
 set ip next-hop verify-availability 52.0.56.105 20 track 6
!
route-map PBR-ISP2 permit 10
 match ip address VLAN71
 set ip next-hop verify-availability 52.0.56.105 10 track 6
 set ip next-hop verify-availability 52.0.56.101 20 track 3
```

Вешаем соответствующие роут-мапы на внутренние сабы
```
interface GigabitEthernet0/1.61
 ip policy route-map PBR-ISP1
!         
interface GigabitEthernet0/1.71
 ip policy route-map PBR-ISP2
```
Как видно, трафик идет по разным ISP, что отвечает поставленной задаче:
```
PC9> trace 8.8.8.8
trace to 8.8.8.8, 8 hops max, press Ctrl+C to stop
 1   172.19.64.1   110.267 ms  22.317 ms  76.945 ms
 2   52.0.56.101   139.019 ms  68.685 ms  20.690 ms
 3   52.0.56.17   61.091 ms  49.784 ms  46.869 ms
 4   52.0.56.70   79.873 ms  59.380 ms  87.090 ms
 5   *100.1.1.65   82.443 ms (ICMP type:3, code:3, Destination port unreachable)

PC10> trace 8.8.8.8
trace to 8.8.8.8, 8 hops max, press Ctrl+C to stop
 1   172.19.70.1   76.921 ms  22.837 ms  31.511 ms
 2   52.0.56.105   108.101 ms  116.033 ms  74.044 ms
 3   52.0.56.9   70.794 ms  112.346 ms  64.655 ms
 4   *52.0.56.66   139.099 ms (ICMP type:3, code:3, Destination port unreachable
```

Конечная цель задач 1,2,3 - настроить NAT на бранче, так чтобы иметь возможность направлять трафик соответствующего VLAN через конкретного провайдера.

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



Работу NAT демонстрируеуется содержимым таблицы трансляции на R:
```
EDGE-R28#sho ip nat tran
Pro Inside global      Inside local       Outside local      Outside global
icmp 52.0.56.102:55094 172.19.64.11:55094 8.8.8.8:55094      8.8.8.8:55094
icmp 52.0.56.102:55350 172.19.64.11:55350 8.8.8.8:55350      8.8.8.8:55350
icmp 52.0.56.102:55606 172.19.64.11:55606 8.8.8.8:55606      8.8.8.8:55606
icmp 52.0.56.102:56118 172.19.64.11:56118 8.8.8.8:56118      8.8.8.8:56118
icmp 52.0.56.102:56374 172.19.64.11:56374 8.8.8.8:56374      8.8.8.8:56374
```

Дополнительно был настроенный временный DHCP, чтобы клиенты автоматически получали IPv4.

```
Настройка DHCP для внутренних пользователей
!
ip dhcp excluded-address 172.19.64.1 172.19.64.10
ip dhcp excluded-address 172.19.70.1 172.19.70.2
!
ip dhcp pool PC-FLOOR1
 network 172.19.64.0 255.255.255.0
 default-router 172.19.64.1 
 dns-server 172.19.64.1 
!
ip dhcp pool PRN-FLOOR1
 network 172.19.70.0 255.255.255.192
 default-router 172.19.70.1 
 dns-server 172.19.70.1 
!        
```

задача 4 - настройка маршрутов в офисе Лабытнанги

```
ip route 0.0.0.0 0.0.0.0 52.0.56.109
```

Проверка:
```
R27(config)#do ping 8.8.8.8
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 8.8.8.8, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 32/48/62 ms
R27(config)#do trace 8.8.8.8
Type escape sequence to abort.
Tracing the route to 8.8.8.8
VRF info: (vrf in name/id, vrf out name/id)
  1 52.0.56.109 39 msec 60 msec 19 msec
  2 52.0.56.9 37 msec 57 msec 72 msec
  3 52.0.56.66 54 msec 46 msec 30 msec

R27#sho ip nat translations 
Pro Inside global      Inside local       Outside local      Outside global
icmp 52.0.56.110:1     172.20.0.1:1       8.8.8.8:1          8.8.8.8:1  
```

Изменения в конфигурациях оборудованияЖ
- [06-1-EDGE-R28](/LECTURES/MODULE02/Lecture11/labs/configs/06-1-EDGE-R28-PBR.txt)
- [07-1-EDGE-R27](/LECTURES/MODULE02/Lecture11/labs/configs/07-1-EDGE-R27.txt)

Задание выполнено