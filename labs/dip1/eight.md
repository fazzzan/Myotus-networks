router eigrp 1
```
eigrp router-id 3.3.3.3
```
network 2.0.0.0 0.0.0.255
```
no auto-summary
```
#sh ip route eigrp | begin Gateway - лайфхак

ip default-network A.B.C.D - Данная команда нужна для того, чтобы добавить в свою таблицу маршрутизации кандидата на дефолтный маршрут.
Так можно надобавлять промежуточные некстхопы, не забывая дополнять обратными маршрутами

```
R1#sh ip route eigrp | begin Gateway
Gateway of last resort is 1.1.1.2 to network 2.0.0.0

D*    2.0.0.0/8 [90/2681856] via 1.1.1.2, 00:20:08, Serial1/0
D     20.0.0.0/8 [90/2195456] via 1.1.1.2, 00:30:57, Serial1/0
```

Если нужно передать дефолтный маршрут в сторону R1, это делается при помощи команды rediscribute static в режиме конфигурации eigrp:

R2(config-router)#redistribute static

Готово, теперь идем на R1, смотрим таблицу маршрутизации и пытаемся пингануть адрес 30.1.1.1:
```
R1#sh ip route eigrp 
... 
Gateway of last resort is 1.1.1.2 to network 0.0.0.0

D*EX  0.0.0.0/0 [170/2681856] via 1.1.1.2, 00:00:20, Serial1/0
D     2.0.0.0/8 [90/2681856] via 1.1.1.2, 00:43:32, Serial1/0
D     20.0.0.0/8 [90/2195456] via 1.1.1.2, 00:54:21, Serial1/0

R1#ping 30.1.1.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 30.1.1.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 19/19/20 ms
```
удобная функция - суммирование маршрутов для этого надо заанонсировать суперсеть с маршрутизатора R3 в сторону R2:
— рассчитываем суммарную сеть для диапазона 192.168.0.0/24 — 192.168.7.0/24. Она будет выглядеть так: 192.168.0.0 255.255.248.0 (192.168.0.0/21)
— после выяснения суммарной сети, на R3 выбираем IF в сторону EIGRP-соседа. Допустим IF Serial1/0. Пропишем команду на IF в сторону EIGRP-соседа 
```
ip summary-address eigrp autonomous-system network netmask
```
Получится:
```
R3(config)#int s1/0
R3(config-if)#ip summary-address eigrp 100 192.168.0.0 255.255.248.0
R3(config-if)#end
R3#
*Nov 13 14:48:55.365: %DUAL-5-NBRCHANGE: EIGRP-IPv4 100: Neighbor 2.2.2.1 (Serial1/0) is resync: summary configured
```
После этого таблицы маршрутизации на устройствах будут
```
R3#sh ip route | i 192.168
D     192.168.0.0/21 is a summary, 00:02:09, Null0
      192.168.0.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.0.0/24 is directly connected, Loopback1
L        192.168.0.1/32 is directly connected, Loopback1
... 
      192.168.7.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.7.0/24 is directly connected, Loopback8
L        192.168.7.1/32 is directly connected, Loopback8
```
На самом R3 появляетсясуммарная запись в таблице маршрутизации, которая ссылается на интерфейс Null0.
```
D     192.168.0.0/21 is a summary, 00:02:09, Null0
```
Это означает, что суммарный маршрут успешно создан и распространен по автономной системе EIGRP.
Таблица маршрутизации на соседе - R2:
```
R2#sh ip route | begin Gateway
Gateway of last resort is 2.2.2.2 to network 0.0.0.0

S*    0.0.0.0/0 [1/0] via 2.2.2.2
      1.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        1.0.0.0/8 is directly connected, Serial1/0
L        1.1.1.2/32 is directly connected, Serial1/0
...
C        20.0.0.0/8 is directly connected, Ethernet0/0
L        20.1.1.1/32 is directly connected, Ethernet0/0
D     192.168.0.0/21 [90/2297856] via 2.2.2.2, 00:42:00, Serial1/1
```
Проверка:
```
R2#ping 192.168.5.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.5.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 8/9/10 ms
R2#ping 192.168.2.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.2.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 9/9/10 ms
```
Как видим, теперь в таблице маршрутизации есть только одна суперсеть, вместо восьми маленьких, как это было ранее. И даже Loopback-интерфейсы пингуются.
Аналогично на R1:
```
R1#sh ip route | begin Gateway
Gateway of last resort is 1.1.1.2 to network 0.0.0.0

D*EX  0.0.0.0/0 [170/2681856] via 1.1.1.2, 01:12:21, Serial1/0
      1.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
C        1.0.0.0/8 is directly connected, Serial1/0
L        1.1.1.1/32 is directly connected, Serial1/0
D     2.0.0.0/8 [90/2681856] via 1.1.1.2, 01:12:21, Serial1/0
      10.0.0.0/8 is variably subnetted, 2 subnets, 2 masks
...
D     192.168.0.0/21 [90/2809856] via 1.1.1.2, 00:45:05, Serial1/0

R1#
R1#ping 192.168.0.1           
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.0.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 18/19/20 ms
R1#ping 192.168.7.1           
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 192.168.7.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 19/19/20 ms
```






