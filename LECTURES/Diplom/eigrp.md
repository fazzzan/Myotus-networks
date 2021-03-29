# Настройка EIRP
```
router eigrp 1
eigrp router-id 3.3.3.3
network 2.0.0.0 0.0.0.255
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
ip summary-address eigrp autonomous-system  <network> <netmask>
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
На самом R3 появляется суммарная запись в таблице маршрутизации, которая ссылается на интерфейс Null0.
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
# Редистрибьюция static маршрутов
Врядли в наши планы входит задание на каждом роутере default-network, особенно если их пара сотен. Вместо этого можно инжектировать данный маршрут, задав его на одном, пограничном роутере. 
На пограничном R2 прописываем дефолтный static маршрут в сторону R3, указав в качестве next-hop адреса его IF s1/0:
```
R2(config)#ip route 0.0.0.0 0.0.0.0 2.2.2.2
R2(config)#exit
R2#ping 30.1.1.1
Type escape sequence to abort.
Sending 5, 100-byte ICMP Echos to 30.1.1.1, timeout is 2 seconds:
!!!!!
Success rate is 100 percent (5/5), round-trip min/avg/max = 8/9/10 ms

```
Передадим этот маршрут в сторону внутренних роутеров, включая R1: rediscribute static в режиме настройки eigrp:
```
R2(config-router)#redistribute static
```
Теперь на R1, табл. маршр-ции выглядит:
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
В таблице маршрутизации, появляется маршрут, помеченный символом «звездочка» с пометкой EX. EX означает, что данный маршрут был принят от устройства, которое получило информацию о данной сети не из запущенного экземпляра EIGRP (путем редистрибьюции из другого протокола маршрутизации/другого экземпляра EIGRP).


# Балансировка трафика на каналах с одинаковой стоимостью
В EIGRP можно пустить весь трафик, или его часть по определенному каналу.
Допустим, что между устройствами EIGRP-соседство:
```
R2#sh ip route eigrp | begin Gateway
Gateway of last resort is not set

D     10.0.0.0/8 [90/2195456] via 2.2.2.1, 00:07:21, Serial1/0
                 [90/2195456] via 1.1.1.1, 00:07:21, Serial1/1
```
Это значит что до сети 10.0.0.0/8 у нас есть 2 маршрута с одинаковой метрикой и административной дистанцией (FD). Трассировка с R2 до адреса 10.1.1.1:
```
R2#traceroute 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.1.1.1
VRF info: (vrf in name/id, vrf out name/id)
  1 1.1.1.1 10 msec
    2.2.2.1 11 msec * 

... 

R2#traceroute 10.1.1.1
Type escape sequence to abort.
Tracing the route to 10.1.1.1
VRF info: (vrf in name/id, vrf out name/id)
  1 2.2.2.1 10 msec
    1.1.1.1 10 msec * 
```
Трейсы идут через разные IF: EIGRP, понимает что между ними 2 равноправных маршрута и посылает трафик поочередно через разные каналы в сторону R1.
EIGRP default добавляет в таблицу маршрутизации до 4 маршрутов с одинаковой стоимостью для каждой подсети. Команда maximum-path <number>  (number от 1 до 32) в режиме конфигурации eigrp меняет это количество:
```
R2(config)#router eigrp 100
R2(config-router)#maximum-path 1
R2(config-router)#end

R2#sh ip route eigrp | begin Gateway
Gateway of last resort is not set

D     10.0.0.0/8 [90/2195456] via 1.1.1.1, 00:06:24, Serial1/1
```

В таблице маршрутизации из 2 остался 1 маршрут, но в таблице топологии по-прежнему их 2:
```
R2#sh ip eigrp topology           
EIGRP-IPv4 Topology Table for AS(100)/ID(2.2.2.2)
Codes: P - Passive, A - Active, U - Update, Q - Query, R - Reply,
       r - reply Status, s - sia Status 

P 2.0.0.0/8, 1 successors, FD is 2169856
        via Connected, Serial1/0
P 10.0.0.0/8, 1 successors, FD is 2195456
        via 1.1.1.1 (2195456/281600), Serial1/1
        via 2.2.2.1 (2195456/281600), Serial1/0
P 1.0.0.0/8, 1 successors, FD is 2169856
        via Connected, Serial1/1
P 20.0.0.0/8, 1 successors, FD is 281600
        via Connected, Ethernet0/0
```
# EIGRP-балансировка трафика на каналах с разной стоимостью

Поменяем «стоимость»  какого-либо канала:
```
R2(config)#int s1/0
R2(config-if)#bandwidth 800
``
# bandwidth несет исключительно информационный характер для протоколов динамической маршрутизации. Скорость на интерфейсе она не ограничивает.

Теперь таблица маршрутизации содержит один, «лучший», маршрут, пропускная способность которого оказалась выше:
```
R2#sh ip route eigrp | begin Gateway
Gateway of last resort is not set

D     10.0.0.0/8 [90/2195456] via 1.1.1.1, 00:00:17, Serial1/1
```
А в топологи eigrp для сети 10.0.0.0/8 маршрута - два, но с разной FD:
```
R2#sh ip eigrp topology | section 10.0.0.0/8
P 10.0.0.0/8, 1 successors, FD is 2195456
        via 1.1.1.1 (2195456/281600), Serial1/1
        via 2.2.2.1 (3737600/281600), Serial1/0
```
По таблицы топологии видно, что лучшая административная дистанция (FD, возможное расстояния) = 2195456, именно поэтому путь через s1/1 попал в таблицу маршрутизации.
Теперь давайте попробуем сделать так, чтобы оба маршрута попали в таблицу маршрутизации, делается это командой variance в режиме настройки роутера:

R2(config)#router eigrp 100
R2(config-router)#variance 2

Давайте разберемся, для чего нужна variance: как известно, в таблицу маршрутизации попадает лучший маршрут, но в реальной жизни значения метрики маршрутов бывают близки, но все же не равны, поскольку она может исчисляться миллионами, и полное совпадение метрик маловероятно. Для того, чтобы близкие по стоимости маршруты могли попадать в таблицу маршрутизации и используется команда variance — она позволяет считать равными маршруты с относительно близкими значениями метрики, а следовательно, добавлять в таблицу маршрутизации несколько маршрутов неравной метрики к той же подсети.
В режиме конфигурирования EIGRP с помощью команды variance multiplier можно указать число в диапазоне от 1 до 128 (параметр вариации метрики).  Маршрутизатор после указания variance умножает FD (метрику оптимального маршрута) на это число и получает диапазон метрики маршрутов, которые могут быть добавлены в таблицу маршрутизации.
В нашем примере multiplier = 2, это означает, что диапазон метрик будет от 2195456 до 2195456*2=4390912. В таком случае второй маршрут до сети 10.0.0.0/8 с метрикой 3737600 попадает в указанный нами диапазон, что позволяет ему быть успешно добавленным в таблицу маршрутизации:


R2#sh ip route eigrp | begin Gateway
Gateway of last resort is not set

D     10.0.0.0/8 [90/3737600] via 2.2.2.1, 00:00:53, Serial1/0
                 [90/2195456] via 1.1.1.1, 00:00:53, Serial1/1

Отсюда видно, что вопреки разной стоимости путей в таблицу маршрутизации попали оба маршрута до сети 10.0.0.0/8
