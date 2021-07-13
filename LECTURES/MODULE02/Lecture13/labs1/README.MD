# Тестова л.р, которую я сделал чтобы понимать разницу между зонами и возникающими маршрутами #

Картинка задания:
![](/LECTURES/MODULE02/Lecture13/pictures/67.jpg)

## Задание: ##
### 1.   настроить OSPF в трех зонах: 0, 1, 12 ###

конфиги настроек оборудования: [P1R1](1/P1R1.cfg), [P1R2](1/P1R2.cfg), [P1R3](1/P1R3.cfg), [P2R1](1/P2R1.cfg), [P2R2](1/P2R2.cfg), [P2R3](1/P2R3.cfg), [BB](1/BB.cfg).

![](/LECTURES/MODULE02/Lecture13/pictures/68.jpg)

Результат схождения - 
- маршруты IA - межзонные, появились в результате работы ABR P1R1, который транслировал в AREA 1 LSA 3

![](/LECTURES/MODULE02/Lecture13/pictures/70.jpg)

![](/LECTURES/MODULE02/Lecture13/pictures/69.jpg)

```
*Apr 19 19:49:06.283: OSPF-200 LRIB : Creating route 10.12.12.0/24 
*Apr 19 19:49:06.283: OSPF-200 LRIB :  Add path area 1, type Inter, dist 30,  forward 0, tag 0x0, via 192.168.1.17 Ethernet0/0, route flags (PartialSPF), path flags (none), source 10.1.1.1, spf 27, list-type route_type_list 
...
*Apr 19 19:49:06.283: OSPF-200 LRIB : Sync'ed 10.12.12.0/24 type Inter - change (Change, PathChange, HigherCost, ForcedSync): added 1 paths, deleted 0 paths, spf 27, route instance 27 
*Apr 19 19:49:06.283: OSPF-200 LRIB : Creating route 192.168.12.64/28 
*Apr 19 19:49:06.283: OSPF-200 LRIB :  Add path area 1, type Inter, dist 50,  forward 0, tag 0x0, via 192.168.1.17 Ethernet0/0, route flags (PartialSPF), path flags (none), source 10.1.1.1, spf 27, list-type route_type_list 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   IP route replace of 1 next hops succeeded for 192.168.12.64/28 (flags 0x0, type Inter, tag 0x0), retcode 0 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   Next hop via 192.168.1.17 on Ethernet0/0 (distance 50, source 10.1.1.1, label 1048578) installed 
*Apr 19 19:49:06.283: OSPF-200 LRIB : Sync'ed 192.168.12.64/28 type Inter - change (Change, PathChange, HigherCost, ForcedSync): added 1 paths, deleted 0 paths, spf 27, route instance 27 
...
*Apr 19 19:49:06.283: OSPF-200 LRIB : Creating route 192.168.12.48/28 
*Apr 19 19:49:06.283: OSPF-200 LRIB :  Add path area 1, type Inter, dist 40,  forward 0, tag 0x0, via 192.168.1.17 Ethernet0/0, route flags (PartialSPF), path flags (none), source 10.1.1.1, spf 27, list-type route_type_list 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   IP route replace of 1 next hops succeeded for 192.168.12.48/28 (flags 0x0, type Inter, tag 0x0), retcode 0 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   Next hop via 192.168.1.17 on Ethernet0/0 (distance 40, source 10.1.1.1, label 1048578) installed 
*Apr 19 19:49:06.283: OSPF-200 LRIB : Sync'ed 192.168.12.48/28 type Inter - change (Change, PathChange, HigherCost, ForcedSync): added 1 paths, deleted 0 paths, spf 27, route instance 27 
...
*Apr 19 19:49:06.283: OSPF-200 LRIB : Creating route 192.168.12.32/28 
*Apr 19 19:49:06.283: OSPF-200 LRIB :  Add path area 1, type Inter, dist 40,  forward 0, tag 0x0, via 192.168.1.17 Ethernet0/0, route flags (PartialSPF), path flags (none), source 10.1.1.1, spf 27, list-type route_type_list 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   IP route replace of 1 next hops succeeded for 192.168.12.32/28 (flags 0x0, type Inter, tag 0x0), retcode 0 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   Next hop via 192.168.1.17 on Ethernet0/0 (distance 40, source 10.1.1.1, label 1048578) installed 
*Apr 19 19:49:06.283: OSPF-200 LRIB : Sync'ed 192.168.12.32/28 type Inter - change (Change, PathChange, HigherCost, ForcedSync): added 1 paths, deleted 0 paths, spf 27, route instance 27 
...
*Apr 19 19:49:06.283: OSPF-200 LRIB : Creating route 192.168.12.16/28 
*Apr 19 19:49:06.283: OSPF-200 LRIB :  Add path area 1, type Inter, dist 40,  forward 0, tag 0x0, via 192.168.1.17 Ethernet0/0, route flags (PartialSPF), path flags (none), source 10.1.1.1, spf 27, list-type route_type_list 
*Apr 19 19:49:06.283: OSPF-200 GRIB :   IP route replace of 1 next hops succeeded for 192.168.12.16/28 (flags 0x0, type Inter, tag 0x0), retcode 0 
P1R2#
*Apr 19 19:49:06.283: OSPF-200 GRIB :   Next hop via 192.168.1.17 on Ethernet0/0 (distance 40, source 10.1.1.1, label 1048578) installed 
*Apr 19 19:49:06.283: OSPF-200 LRIB : Sync'ed 192.168.12.16/28 type Inter - change (Change, PathChange, HigherCost, ForcedSync): added 1 paths, deleted 0 paths, spf 27, route instance 27 
P1R2#
```

### 2. Настроить суммаризацию в AREA 1 ###

```
P1R1(config)#router ospf 200
P1R1(config-router)#area 1 range 192.168.1.0 255.255.255.0
```

В результате этого, уже на BB1 информация о мршрутах AREA1 обознчена только 1 записью типа ___O IA___

![](/LECTURES/MODULE02/Lecture13/pictures/71.jpg)

при выполнении аналогичных действий справа, на ABR P2R1, получим

```
P2R1(config)#router ospf 200
P2R1(config-router)#area 12 range 192.168.12.0 255.255.255.0
```
![](/LECTURES/MODULE02/Lecture13/pictures/72.jpg)

И на P1R2 видим удаление всех частных маршрутов в сети 192.168.12.XX и замена их одним маршрутом
```
*Apr 19 20:06:26.476: OSPF-200 LRIB : Creating route 192.168.12.0/24 
*Apr 19 20:06:26.476: OSPF-200 LRIB :  Add path area 1, type Inter, dist 40,  forward 0, tag 0x0, via 192.168.1.17 Ethernet0/0, route flags (PartialSPF), path flags (none), source 10.1.1.1, spf 29, list-type route_type_list 
*Apr 19 20:06:26.476: OSPF-200 GRIB :   IP route replace of 1 next hops succeeded for 192.168.12.0/24 (flags 0x0, type Inter, tag 0x0), retcode 0 
*Apr 19 20:06:26.476: OSPF-200 GRIB :   Next hop via 192.168.1.17 on Ethernet0/0 (distance 40, source 10.1.1.1, label 1048578) installed 
*Apr 19 20:06:26.476: OSPF-200 LRIB : Sync'ed 192.168.12.0/24 type Inter - change (Change, PathChange, HigherCost, ForcedSync): added 1 paths, deleted 0 paths, spf 29, route instance 29 
...
*Apr 19 20:06:26.477: OSPF-200 GRIB :   Route 192.168.12.64/28: delete primary path via 192.168.1.17 on Ethernet0/0, source 10.1.1.1 succeeded 
*Apr 19 20:06:26.477: OSPF-200 LRIB : Sync'ed 192.168.12.64/28 type Inter - change (RtDelete, RthDelete, PathChange): added 0 paths, deleted 1 paths, spf 29, route instance 27 
*Apr 19 20:06:26.477: OSPF-200 GRIB :   Route 192.168.12.16/28: delete primary path via 192.168.1.17 on Ethernet0/0, source 10.1.1.1 succeeded 
*Apr 19 20:06:26.477: OSPF-200 LRIB : Sync'ed 192.168.12.16/28 type Inter - change (RtDelete, RthDelete, PathChange): added 0 paths, deleted 1 paths, spf 29, route instance 27 
*Apr 19 20:06:26.477: OSPF-200 GRIB :   Route 192.168.12.32/28: delete primary path via 192.168.1.17 on Ethernet0/0, source 10.1.1.1 succeeded 
*Apr 19 20:06:26.477: OSPF-200 LRIB : Sync'ed 192.168.12.32/28 type Inter - change (RtDelete, RthDelete, PathChange): added 0 paths, deleted 1 paths, spf 29, route instance 27 
*Apr 19 20:06:26.477: OSPF-200 GRIB :   Route 192.168.12.48/28: delete primary path via 192.168.1.17 on Ethernet0/0, source 10.1.1.1 succeeded 
P1R2#
*Apr 19 20:06:26.477: OSPF-200 LRIB : Sync'ed 192.168.12.48/28 type Inter - change (RtDelete, RthDelete, PathChange): added 0 paths, deleted 1 paths, spf 29, route instance 27 
```
И сделано все это было 1-й LSU

![](/LECTURES/MODULE02/Lecture13/pictures/73.jpg)

### 3. Настроить AREA 1 - STUB ### 
Чтобы проверить как работает STUB-зона с маршрутами от ASBR, инжектируем статический маршрут на крайнем правом P2R3:

```
P2R3(config)#int lo 0
P2R3(config-if)#ip address 172.20.1.1 255.255.255.0
P2R3(config-if)#no shut
P2R3(config-if)#ip ospf 200 area 12

P2R3(config)#ip route 8.8.8.0 255.255.255.0 lo 0

P2R3(config-if)#router ospf 200
P2R3(config-router)#redistribute static metric 100
```

На BB  этот маршрут появился в виде записи:
 ```
 O E2     8.8.8.0 [110/100] via 10.12.12.1, 00:04:49, Ethernet1/0
 ```

А в AREA1 прилетел LSA 5  и в таблице маршрутизации появилась запись ___O E2___:
```
      8.0.0.0/24 is subnetted, 1 subnets
O E2     8.8.8.0 [110/100] via 192.168.1.17, 00:02:28, Ethernet0/0
```

![](/LECTURES/MODULE02/Lecture13/pictures/74.jpg)


На всех R AREA1 в контексте OSPF команда ```area 1 stub```, что привело к тому, что AREA1 стала описываться как ___STUB___

```
P1R2(config-router)#do sho ip ospf
...
 Reference bandwidth unit is 100 mbps
    Area 1
        Number of interfaces in this area is 3
        It is a stub area
        Area has no authentication
        SPF algorithm last executed 00:02:10.632 ago
        SPF algorithm executed 4 times
        Area ranges are
        Number of LSA 13. Checksum Sum 0x05FA25
        Number of opaque link LSA 0. Checksum Sum 0x000000
        Number of DCbitless LSA 0
        Number of indication LSA 0
        Number of DoNotAge LSA 0
        Flood list length 0
```

при этом запись __O E2 ___ - исчезла, а таблица маршрутизации пополнилась записями на 2 DEFAULT маршрута:
```
Gateway of last resort is 192.168.1.17 to network 0.0.0.0
...
O*IA  0.0.0.0/0 [110/11] via 192.168.1.17, 00:05:39, Ethernet0/0
```

### 4. Настроить AREA 1 - T-STUB (cisco-железо) ### 

Настроили ABR AREA 1 как T-STUB:
```
P1R1(config-router)#area 1 stub no-summary
```
Таблица маршрутов еще больше съежилась: из нее пропали в том числе все ___O IA___ - записи и остался только DEFAULT маршрут (при этом ip-связность до узлов в AREA 12 - сохрнилась):
```
Gateway of last resort is 192.168.1.17 to network 0.0.0.0

O*IA  0.0.0.0/0 [110/11] via 192.168.1.17, 00:00:44, Ethernet0/0
      192.168.1.0/24 is variably subnetted, 7 subnets, 2 masks
C        192.168.1.16/28 is directly connected, Ethernet0/0
L        192.168.1.18/32 is directly connected, Ethernet0/0
C        192.168.1.32/28 is directly connected, Ethernet0/1
L        192.168.1.33/32 is directly connected, Ethernet0/1
O        192.168.1.48/28 [110/20] via 192.168.1.66, 00:05:31, Ethernet1/0
                         [110/20] via 192.168.1.17, 00:05:21, Ethernet0/0
C        192.168.1.64/28 is directly connected, Ethernet1/0
L        192.168.1.65/32 is directly connected, Ethernet1/0
```
Действие по корректировки БД топологии прошло в 2 этапа: LSU c 8 LSA3 удалила все частные маршруты, а затем прилетела LSU LSA3 с DEFAULT маршрутом.
![](/LECTURES/MODULE02/Lecture13/pictures/75.jpg)

### 5. Настроить AREA 12- NSSA ### 
На всех R ввели 
```
area 12 nssa
```
Если честно. то особой разницы не заметил, разве что только на R AREA12 маршрут до 8ю.8.8.8 стал типа ___O N2___
```
O N2     8.8.8.0 [110/100] via 192.168.12.50, 00:01:36, Ethernet0/2
```

А  AREA 1 данный маршрут прилетел LSA 5

![](/LECTURES/MODULE02/Lecture13/pictures/76.jpg)

### 6. Настроить AREA 1 - T-NSSA ### 

Ну и наконец, настроим ABR P2R1

```
P2R1(config-router)#area 12 nssa no-summary
```

сразу внутри AREA12 на R исчезли записи до подсетей AREA1, осталась лишь запись шлюза

```
P2R2(config-router)#do sho ip route

Gateway of last resort is 192.168.12.33 to network 0.0.0.0

O*IA  0.0.0.0/0 [110/11] via 192.168.12.33, 00:03:09, Ethernet0/1
                [110/11] via 192.168.12.17, 00:02:59, Ethernet0/0
```

![](/LECTURES/MODULE02/Lecture13/pictures/76.jpg)

В AREA1 - маршруты без изменений, с указанием корректных маршрутов до AREA 12:

```
P1R2(config-router)#do sho ip route

Gateway of last resort is not set

      8.0.0.0/24 is subnetted, 1 subnets
O E2     8.8.8.0 [110/100] via 192.168.1.17, 00:03:50, Ethernet0/0
      10.0.0.0/24 is subnetted, 2 subnets
O IA     10.1.1.0 [110/20] via 192.168.1.17, 00:12:26, Ethernet0/0
O IA     10.12.12.0 [110/30] via 192.168.1.17, 00:12:26, Ethernet0/0
      172.20.0.0/32 is subnetted, 1 subnets
O IA     172.20.1.1 [110/41] via 192.168.1.17, 00:03:55, Ethernet0/0
      192.168.1.0/24 is variably subnetted, 7 subnets, 2 masks
C        192.168.1.16/28 is directly connected, Ethernet0/0
L        192.168.1.18/32 is directly connected, Ethernet0/0
C        192.168.1.32/28 is directly connected, Ethernet0/1
L        192.168.1.33/32 is directly connected, Ethernet0/1
O        192.168.1.48/28 [110/20] via 192.168.1.66, 00:12:26, Ethernet1/0
                         [110/20] via 192.168.1.17, 00:12:26, Ethernet0/0
C        192.168.1.64/28 is directly connected, Ethernet1/0
L        192.168.1.65/32 is directly connected, Ethernet1/0
      192.168.12.0/28 is subnetted, 4 subnets
O IA     192.168.12.16 [110/40] via 192.168.1.17, 00:12:26, Ethernet0/0
O IA     192.168.12.32 [110/40] via 192.168.1.17, 00:12:26, Ethernet0/0
O IA     192.168.12.48 [110/40] via 192.168.1.17, 00:12:26, Ethernet0/0
O IA     192.168.12.64 [110/50] via 192.168.1.17, 00:04:00, Ethernet0/0
```