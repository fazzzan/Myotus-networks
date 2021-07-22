# iBGP #

Цель: Настроить фильтрацию для офиса в Москве; Настроить фильтрацию для офиса в С.-Петербург.

Первоначальное ТЗ:
- Настроите фильтрацию в офисе Москва так, чтобы не появилось транзитного трафика (As-path);
- Настроите фильтрацию в офисе С.-Петербург так, чтобы не появилось транзитного трафика (Prefix-list);
- Настроите провайдера Киторн так, чтобы в офис Москва отдавался только маршрут по-умолчанию;
- Настроите провайдера Ламас так, чтобы в офис Москва отдавался только маршрут по-умолчанию и префикс офиса С.-Петербург;
- Все сети в лабораторной работе должны иметь IP связность;

Настройка осуществляется одновременно для IPv4 и IPv6

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)


##  Задание 1

Ранее внедренные разрешения только на default маршруты позволили сразу получить необходимую картину. 

```
### Настраиваем default и ловим префикс от AS301

ip as-path access-list 1 permit ^301$

ip prefix-list DEFAULT-ONLY seq 10 permit 0.0.0.0/0
ip prefix-list DEFAULT-ONLY seq 20 deny 0.0.0.0/0 le 32

ipv6 prefix-list DEFAULT-ONLY-V6 seq 10 permit ::/0
ipv6 prefix-list DEFAULT-ONLY-V6 seq 20 deny ::/0 le 128

route-map FILTER-DEFAULT-V4 permit 10
 match ip address prefix-list DEFAULT-ONLY
 match as-path 1
 set local-preference 150
route-map FILTER-DEFAULT-V4 permit 20
 match ip address prefix-list DEFAULT-ONLY

route-map FILTER-DEFAULT-V6 permit 10
 match ipv6 address prefix-list DEFAULT-ONLY-V6
 match as-path 1
 set local-preference 150
route-map FILTER-DEFAULT-V6 permit 20
 match ip address prefix-list DEFAULT-ONLY-V6

router bgp 1001
 address-family ipv4
  neighbor 30.1.35.97 prefix-list DEFAULT-ONLY in
  neighbor 30.1.35.97 route-map FILTER-DEFAULT-V4 in
 exit-address-family
 address-family ipv6
  neighbor 2000:AAAC:400::1 prefix-list DEFAULT-ONLY-V6 in
  neighbor 2000:AAAC:400::1 route-map FILTER-DEFAULT-V6 in
 exit-address-family
```

Транзитного трафика через Московский офис нет. Видно, что на провайдерах есть префиксы IPv4, IPv6 только самой AS 1001

![](/LECTURES/MODULE03/Lecture25/pictures/28.jpg)
![](/LECTURES/MODULE03/Lecture25/pictures/29.jpg)

![](/LECTURES/MODULE03/Lecture25/pictures/30.jpg)

При необходимости использовал бы filter-list
```
EDGE1(config)#ip as-path access-list 1 permit ^$
EDGE1(config)#ipv6 as-path access-list 1 deny .*

И в контексте BGP донастроил бы
EDGE1(config-router)# address-family ipv4
EDGE1(config-router-af)#neighbor 100.1.1.97 filter-list 1 out
EDGE1(config-router-af)#neighbor 100.1.1.97 filter-list 1 out
EDGE1(config-router)# address-family ipv6
EDGE1(config-router-af)#neighbor 2000:AAAB:400::1 filter-list 1 out
EDGE1(config-router-af)#neighbor 2000:AAAB:400::1 filter-list 1 out
```

##  Задание 2

Аналогичная картина для офиса СПб. Транзитных маршрутов нет за счет фильтрации трафика на ISP и R31

```
### Вбрасываем default маршруты в R31 слева
router bgp 520
 address-family ipv4
  neighbor 52.0.56.94 default-originate
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAA:400::2 default-originate
 exit-address-family

### От R31 принимаем только AS
ip prefix-list ALLOW_2024_V4 seq 5 permit 50.50.96.0/24
ipv6 prefix-list ALLOW_2024_V6 seq 5 permit 2000:AAAD:2::/48

router bgp 520
 address-family ipv4
  neighbor 52.0.56.94  prefix-list ALLOW_2024_V4 in
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAA:400::2  prefix-list ALLOW_2024_V6 in
 exit-address-family
```

![](/LECTURES/MODULE03/Lecture25/pictures/31.jpg)
![](/LECTURES/MODULE03/Lecture25/pictures/32.jpg)


##  Задание 3: Настроите провайдера Киторн так, чтобы в офис Москва отдавался только маршрут по-умолчанию

Настроен ранее
```
### Вбрасываем default маршруты в EDGE1
router bgp 101
 address-family ipv4
  neighbor 100.1.1.98  default-originate
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAB:400::2  default-originate
 exit-address-family
```
Фильтруем маршруты на EDGE

Полученная таблица маршрутизации обоих EDGE
![](/LECTURES/MODULE03/Lecture25/pictures/33.jpg)

При этом в самой таблице префиксов BGP - префикса 2, но дефолтный - ЛИМАС
![](/LECTURES/MODULE03/Lecture24/pictures/35.jpg)

##  Задание 4: Настроите провайдера Лимас так, чтобы в офис Москва отдавался только маршрут по-умолчанию и префикс офиса С.-Петербург;

До настройки

![](/LECTURES/MODULE03/Lecture24/pictures/36.jpg)

Настройку выполняем как на ISP, так и вносим изменения в настройку EDGE2

Сначала заставили ISP2 вбрасывать дефолт + AS 2042 маршруты в BGP
```
ip prefix-list DEFAULT-VS-SPB-V4 seq 5 permit 0.0.0.0/0
ip prefix-list DEFAULT-VS-SPB-V4 seq 10 permit 50.50.96.0/24

ipv6 prefix-list DEFAULT-VS-SPB-V6 seq 5 permit ::/0
ipv6 prefix-list DEFAULT-VS-SPB-V6 seq 10 permit 2000:AAAD:1::/48


router bgp 301
 address-family ipv4
  neighbor 30.1.35.98 prefix-list DEFAULT-VS-SPB-V4 out
  neighbor 30.1.35.98 default-originate
 exit-address-family
 !
 address-family ipv6
  neighbor 2000:AAAC:400::2 prefix-list DEFAULT-VS-SPB-V6 out
  neighbor 2000:AAAC:400::2 default-originate
 exit-address-family
```
Теперь на EDGE2 включаем дополнительно добави контролю AS-PATH 2042 

```
ip as-path access-list 1 permit ^301$
ip as-path access-list 1 permit _2042$

ip prefix-list DEFAULT-ONLY seq 10 permit 0.0.0.0/0
ip prefix-list DEFAULT-ONLY seq 15 permit 50.50.96.0/24
ip prefix-list DEFAULT-ONLY seq 20 deny 0.0.0.0/0 le 32

ipv6 prefix-list DEFAULT-ONLY-V6 seq 10 permit ::/0
ipv6 prefix-list DEFAULT-ONLY-V6 seq 15 permit 2000:AAAD:2::/48
ipv6 prefix-list DEFAULT-ONLY-V6 seq 20 deny ::/0 le 128

route-map FILTER-DEFAULT-V4 permit 10
 match ip address prefix-list DEFAULT-ONLY
 match as-path 1
 set local-preference 150
route-map FILTER-DEFAULT-V4 permit 20
 match ip address prefix-list DEFAULT-ONLY

route-map FILTER-DEFAULT-V6 permit 10
 match ipv6 address prefix-list DEFAULT-ONLY-V6
 match as-path 1
 set local-preference 150
route-map FILTER-DEFAULT-V6 permit 20
 match ip address prefix-list DEFAULT-ONLY-V6

router bgp 1001
 address-family ipv4
  neighbor 30.1.35.97 prefix-list DEFAULT-ONLY in
  neighbor 30.1.35.97 route-map FILTER-DEFAULT-V4 in
 exit-address-family
 address-family ipv6
  neighbor 2000:AAAC:400::1 prefix-list DEFAULT-ONLY-V6 in
  neighbor 2000:AAAC:400::1 route-map FILTER-DEFAULT-V6 in
 exit-address-family
```

![](/LECTURES/MODULE03/Lecture25/pictures/35.jpg)


##  Задание 5: Связность IP-сетей 

Все офисы видят друг друга, даже при частично отключенных ISP линкАх, но ввиду того что Триада внутри не имеет полной IGP - связности, перерыв связи между R23 и R25 приводит к недоступности бранчей Лабытнанги и Чокурдах. На примере видно что R31 отвечает из диапазона своей AS запросу из AS 1001

![](/LECTURES/MODULE03/Lecture24/pictures/36.jpg)

Ниже представлено IPv6 взаимодейтсвие между EDGE1 и AS101 EIGRP офиса СПб

![](/LECTURES/MODULE03/Lecture24/pictures/37.jpg)

Проверка доступности из МСК IPv6 адресов из споуков:

![](/LECTURES/MODULE03/Lecture24/pictures/39.jpg)

Маршруты в ЛИМАС в наличии

![](/LECTURES/MODULE03/Lecture24/pictures/40.jpg)

Настройки оборудования представлены по соответствующим ссылкам ниже как для ipv4, так и для ipv6.


- Киторн (01):
   - [01-ISP1](/LECTURES/MODULE02/Lecture10/labs/configs/01-ISP1.txt)
- Лимас (02):
   - [02-ISP2](/LECTURES/MODULE02/Lecture10/labs/configs/02-ISP2.txt)
- Триада (04): 
   - [04-R23](/LECTURES/MODULE02/Lecture10/labs/configs/04-R23.txt)
   - [04-R24](/LECTURES/MODULE02/Lecture10/labs/configs/04-R24.txt)
   - [04-R25](/LECTURES/MODULE02/Lecture10/labs/configs/04-R25.txt)
   - [04-R26](/LECTURES/MODULE02/Lecture10/labs/configs/04-R26.txt)
- Москва (03)
   - EDGE: 
      - [03-01-EDGE1](/LECTURES/MODULE02/Lecture10/labs/configs/03-01-EDGE1.txt)
      - [03-01-EDGE2](/LECTURES/MODULE02/Lecture10/labs/configs/03-01-EDGE2.txt)
      - [03-01-EDGEOSPF1](/LECTURES/MODULE02/Lecture10/labs/configs/03-01-EDGEOSPF1.txt)
   - Distribution UP: 
      - [03-02-DSWWAN1](/LECTURES/MODULE02/Lecture10/labs/configs/03-02-DSWWAN1.txt)
      - [03-02-DSWWAN2](/LECTURES/MODULE02/Lecture10/labs/configs/03-02-DSWWAN2.txt)
- СПб (05)
   - EDGE
      - [05-01-EDGE-R31](/LECTURES/MODULE02/Lecture10/labs/configs/05-1-EDGE-R31.txt)
      - [05-01-EDGEEIGRP-R32](/LECTURES/MODULE02/Lecture10/labs/configs/05-1-EDGEEIGRP-R32.txt)
   - CollapsedCORE
      - [05-02-DSWCOLCORE16](/LECTURES/MODULE02/Lecture10/labs/configs/05-2-DSWCOLCORE16.txt)
      - [05-02-DSWCOLCORE17](/LECTURES/MODULE02/Lecture10/labs/configs/05-2-DSWCOLCORE17.txt)
- Чокурдах (06)
   - EDGE
      - [06-1-EDGE-R28](/LECTURES/MODULE02/Lecture10/labs/configs/06-1-EDGE-R28.txt)
- Лабытнанги (07)
   - EDGE
      - [07-1-EDGE-R27](/LECTURES/MODULE02/Lecture10/labs/configs/07-1-EDGE-R27.txt)

