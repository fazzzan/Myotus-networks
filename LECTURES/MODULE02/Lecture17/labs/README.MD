# IS-IS #

Цель: Настроить IS-IS офисе Триада.

ТЗ:
- R23 и R25 находятся в зоне 2222
- R24 находится в зоне 24
- R26 находится в зоне 26

Настройка осуществляется одновременно для IPv4 и IPv6

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

![](/LECTURES/MODULE02/Lecture17/pictures/40.jpg)

##  Задание 1, 2, 3: Зона 2222

Типовая настройка оборудования схожа для всех R TRIADA. Объявляем IF не участвующие в ISIS-обмене пассивными. Пример представлен для R23: 

```
router isis 2222
 net 49.2222.2323.2323.2323.00
 passive-interface gi 0/0
 redistribute static ip

interface GigabitEthernet0/0
 ip router isis 2222
 ipv6 router isis 2222
 exit

interface GigabitEthernet0/1
 ip router isis 2222
 ipv6 router isis 2222
 isis circuit-type level-2-only
 exit

interface GigabitEthernet0/2
 ip router isis 2222
 ipv6 router isis 2222
 isis circuit-type level-2-only
 exit
```
Видно, что маршруты в другие сети пойдут "буквой П", через вышестоящие R25, R23

![](/LECTURES/MODULE02/Lecture17/pictures/41.jpg)


##  Задание 4: Настройка для IPv6 повторяет логику IPv4

Реализовано. Базовые настройки приведены выше.


Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.

- Триада (04): 
   - [04-R23](/LECTURES/MODULE02/Lecture17/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE02/Lecture17/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE02/Lecture17/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE02/Lecture17/labs/configs/04-R26.txt)
