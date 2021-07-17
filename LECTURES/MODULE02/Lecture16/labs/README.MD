# Базовая настройка ISIS 
- http://www.labminutes.com/rs0045_ipv6_isis_1
- http://www.labminutes.com/rs0046_ipv6_isis_2

![](/LECTURES/MODULE02/Lecture16/pictures/16.jpg)

![](/LECTURES/MODULE02/Lecture16/pictures/26.jpg)


Задание

![](/LECTURES/MODULE02/Lecture16/pictures/17.jpg)

## Выполнение задания

Включаем ISIS (R1-R3 в AREA 13.0000) и задаем ппассивные IF. Настройку начинать с R1. Помнить, что настройка функционала ipv6 всегда делается в отдельном ```address-family ipv6 unicast```

![](/LECTURES/MODULE02/Lecture16/pictures/27.jpg)

R1
```
router isis 0001
 net 13.0000.0000.0000.0001.00
exit

### задаем на IF, смежном с STUB level-1
interface GigabitEthernet0/0
 ip router isis 0001
 ipv6 router isis 0001
 isis circuit-type level-1
 exit

### задаем на IF BB level-2-only
interface GigabitEthernet0/1
 ip router isis 0001
 ipv6 router isis 0001
 isis circuit-type level-2-only
 exit

### Разрешаем отправку Lo0
router isis 0001
passive-int lo0
exit
```

R3 - Обязательно задаем тип ___is-type level-1___

```
### Включаем ISIS (R1-R3 AREA 13.0000). Настройку начинать с R1
router isis 0003
 net 13.0000.0000.0000.0003.00
 is-type level-1
exit

### активируем на IF isis
ipv6 unicast-routing

interface GigabitEthernet0/0
 ip router isis 0003
 ipv6 router isis 0003
 exit

### Разрешаем отправку Lo0
router isis 0003
passive-int lo0
exit
```

Не забываем что между AREA ___level-2-only___. Также не забываем что метка ISIS не имеет значения, а вот часть ___net___ отвечающая за одинаковые AREA должна совпадать ___net 13.0000___

Проверка:
- ___do sho ipv6 route isis___ - из соседней AREA по L2 прилетели маршруты Lo0 и ___13-го___ адресного простратства

![](/LECTURES/MODULE02/Lecture16/pictures/18.jpg)

А вот в R3 = L1-сосед попадает дефолтный маршрут и опубликованный на R2 lo0

![](/LECTURES/MODULE02/Lecture16/pictures/25.jpg)

- ___do sho clns nei___ - соседи, тип соседства

![](/LECTURES/MODULE02/Lecture16/pictures/19.jpg)

- ___do sho isis nei___ - соседи IPv4

![](/LECTURES/MODULE02/Lecture16/pictures/20.jpg)

- ___do sho clns int gi 0/0___ - Метрика, приоритет, тип соседства

![](/LECTURES/MODULE02/Lecture16/pictures/21.jpg)

- ___do sho isis database___ - просмотр базы данных ISIS

![](/LECTURES/MODULE02/Lecture16/pictures/24.jpg)

Проверка доступности Lo0 соседа R1

![](/LECTURES/MODULE02/Lecture16/pictures/22.jpg)

Проверка на R3

![](/LECTURES/MODULE02/Lecture16/pictures/23.jpg)

Полезные задания:
- в ISIS: distance <116> - [___116___/11]
- в ISIS: maximum-path
- на IF: isis priority <60> (60<64 => другой R always DR)
- на IF: isis metric <XXXX>  - [116/___11___]


## Задание 3 - на дефолтный маршрут

![](/LECTURES/MODULE02/Lecture16/pictures/28.jpg)

Задание по доступности всех Lo на R3 было указано как задать дефлотный маршрут на R2 через R1. То есть R2-R3 - STUB, поэтому адвертайзим с R1 default
```
### Рассылаем маршрут к R2 как default в обоих контекстах - Pv4/IPv6
router isis 2222
default-information originate
address-family ipv6 unicast
 default-information originate
exit
```
при этом можно сюда же повесить route-map, чтобы default улетал только на определенных соседей (из определенных подсетей). Проверить можно задав запрос на подсеть, которая явно не задавалась  ```sho ipv6 route 2001:2::2```

![](/LECTURES/MODULE02/Lecture16/pictures/29.jpg)

![](/LECTURES/MODULE02/Lecture16/pictures/30.jpg)

## Задание 4 на фильтрацию

![](/LECTURES/MODULE02/Lecture16/pictures/31.jpg)

![](/LECTURES/MODULE02/Lecture16/pictures/32.jpg)

R3
```
### Для задания 3 - разрешаем рассылку lo3
router isis 0003
passive-int lo3
exit
```

В результате подсеть lo3 прилетает везде, в обоих контекстах

![](/LECTURES/MODULE02/Lecture16/pictures/33.jpg)

![](/LECTURES/MODULE02/Lecture16/pictures/34.jpg)

Теперь чтобы отфильтровать данный префикс Lo3, надо на R1 запретить редистрибуцию маршрута
```
### Задание 3 - зададим фильтрацию подсети R3/Lo3: срежем маршрут в направлении к R2 в обоих контекстах - Pv4/IPv6

IPv4
ip prefix-list L1_TO_L2_IPv4 deny 2.3.2.1/24
ip prefix-list L1_TO_L2_IPv4 permit 0.0.0.0/0 le 32
route-map L1_TO_L2_IPv4 permit 10
match ip address prefix-list L1_TO_L2_IPv4

IPv6
ipv6 prefix-list L1_TO_L2_IPv6 deny 2001:3:0:2::1/64
ipv6 prefix-list L1_TO_L2_IPv6 permit ::/0 le

router isis 0001
redistribute isis ip level-2 into level-1 route-map L1_TO_L2_IPv4
address-family ipv6 unicast
 redistribute isis level-1 into level-2 distribute-list L1_TO_L2_IPv6
exit
```

просмотреть prefix-list, убедиться что они работают
```
do sho ip prefix-list detail 
do sho ipv6 prefix-list detail 
```
![](/LECTURES/MODULE02/Lecture16/pictures/37.jpg)

![](/LECTURES/MODULE02/Lecture16/pictures/36.jpg)

### Задание 4 - Route Leak
![](/LECTURES/MODULE02/Lecture16/pictures/38.jpg)
![](/LECTURES/MODULE02/Lecture16/pictures/39.jpg)

До этого слева у нас был только default маршрут

![](/LECTURES/MODULE02/Lecture16/pictures/40.jpg)

```
### Задание 4 - обуспечим Route Leaking ___АДРЕСА R2/Lo0___ к R3 в обоих контекстах - Pv4/IPv6

ip prefix-list L2_TO_L1_IPv4 permit 22.0.0.2/32
route-map L2_TO_L1_IPv4 permit 10
 match ip address prefix-list L2_TO_L1_IPv4

ipv6 prefix-list L2_TO_L1_IPv6 permit 2001::2/128

router isis 0001
redistribute isis ip level-2 into level-1 route-map L2_TO_L1_IPv4
address-family ipv6 unicast
 redistribute isis level-2 into level-1 distribute-list L2_TO_L1_IPv6
exit

### Проверка
do sho ipv6 prefix-list detail
```

после настройка Leaking, получаем, что и есть результат выполнения работы

![](/LECTURES/MODULE02/Lecture16/pictures/41.jpg)
