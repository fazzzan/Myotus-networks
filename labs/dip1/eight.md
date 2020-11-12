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
удобная функция - суммирование маршрутов 
