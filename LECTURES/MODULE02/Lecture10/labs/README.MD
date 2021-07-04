# Разбиение адресного пространства #

Цель:
- разработать и задокументировать адресное пространство (ipv4 и ipv6) для лабораторного стенда.
- настроить ipv4 и ipv6-адреса на каждом активном порту
- настроить каждый VPC в каждом офисе в своем VLAN.
- настроить VLAN управления для сетевых устройств
- настроить сети офисов так, чтобы не возникало broadcast штормов, а использование линков было максимально оптимизировано

Cхема сети ipv4

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

##  Задание 1: разработать и задокументировать адресное пространство (ipv4 и ipv6) для лабораторного стенда

### 1.1 Адреса WAN, AS

![](/LECTURES/MODULE02/Lecture10/pictures/34.jpg)
<details>
<summary>ISP</summary>

|     Офис   |   ASN  |  Подсети IPv4 |   Подсети IPv6  |  Устройства  |
|------------|--------|---------------|-----------------|--------------|
| WAN TRIADA | AS520  | 50.0.56.0/24  | 2000:AAAA::/32  | R23, R24, R25, R26|
| WAN KITORN | AS101  | 100.1.1.0/24  | 2000:AAAB::/32  | R-ISP1  |
| WAN LIMAS  | AS301  | 30.1.35.0/24  | 2000:AAAC::/32  | R-ISP2  |
</details>

<details>
<summary>Офисы</summary>

|     Офис   |   ASN   |  Подсети IPv4 |   Подсети IPv6  |  Устройства  |
|------------|---------|---------------|-----------------|--------------|
|     MOW    | AS1001  | 35.10.10.0/24 | 2001:BBBB:200A::/48  |       |
|     SPb    | AS2042  | 50.50.96.0/24 | 2001:BBBB:200B::/48  |       |
</details>


### 1.2 Адреса LAN 

___Москва___

![](/LECTURES/MODULE02/Lecture10/pictures/35.jpg)

<details>
<summary>OSPF</summary>

|  SUMMARY IPv4 172.17.0.0/28      | SUMMARY IPv6 2000:AAAD:1::/48 = 256x256/56   |
|:---------------------------------|-----------------------------------------------|

| AREA0 IPv4 172.17.0.0 /28 = 31x172.17.0.0 /29 | AREA0 IPv6 2000:AAAD:1:100::/56 = 256 /64  |
|:-----------------------------------------|---------------------------------------|

| PREFIX                                  | MASK| PREFIX                                  | MASK| Description/Device(port) |
|:-----------------------------------------|-|---------------------------------------|-----|--------------------------|
| 172.17.0.0                              | /29 | 2000:AAAD:1:100::                     | /64 | EDGE1<->DSWWAN1          |
| 172.17.0.8                              | /29 | 2000:AAAD:1:101::                     | /64 | EDGE2<->DSWWAN2          |
| 172.17.0.16                             | /29 | 2000:AAAD:1:101::                     | /64 | REZERVED                 |
| …                                       |     | …                                     | /64 |                          |
| 172.17.0.40                             | /29 | 2000:AAAD:1:10f::                     | /64 | REZERVED                 |
| 172.17.0.48                             | /29 | 2000:AAAD:1:110::                     | /64 | DSWWAN1<->DSWWAN2        |
| 172.17.0.56                             | /29 | 2000:AAAD:1:111::                     | /64 | DSWWAN1<->CORE1          |
| 172.17.0.64                             | /29 | 2000:AAAD:1:112::                     | /64 | DSWWAN1<->CORE2          |
| 172.17.0.72                             | /29 | 2000:AAAD:1:113::                     | /64 | DSWWAN2<->CORE1          |
| 172.17.0.80                             | /29 | 2000:AAAD:1:114::                     | /64 | DSWWAN2<->CORE2          |
| 172.17.0.88                             | /29 | 2000:AAAD:1:115::                     | /64 | CORE1<->CORE2            |
| 172.17.0.96                             | /29 | 2000:AAAD:1:116::                     | /64 | CORE1<->DSWACC1          |
| 172.17.0.104                            | /29 | 2000:AAAD:1:117::                     | /64 | CORE1<->DSWACC2          |
| 172.17.0.112                            | /29 | 2000:AAAD:1:118::                     | /64 | CORE2<->DSWACC1          |
| 172.17.0.120                            | /29 | 2000:AAAD:1:119::                     | /64 | CORE2<->DSWACC2          |
| 172.17.0.128                            | /29 | …                                     | /64 | REZERVED                 |
| 172.17.0.136                            | /29 | 2000:AAAD:1:120::                     | /64 | DSWACC1<->DSWACC2        |
| 172.17.0.144                            | /29 | 2000:AAAD:1:121::                     | /64 | CORE1<->AGGRSWDC1        |
| 172.17.0.152                            | /29 | 2000:AAAD:1:122::                     | /64 | CORE1<->AGGRSWDC2        |
| 172.17.0.160                            | /29 | 2000:AAAD:1:123::                     | /64 | CORE2<->AGGRSWDC1        |
| 172.17.0.168                            | /29 | 2000:AAAD:1:124::                     | /64 | CORE2<->AGGRSWDC2        |
| 172.17.0.176                            | /29 | 2000:AAAD:1:125::                     | /64 | AGGRSWDC1<->AGGRSWDC2    |
| 172.17.0.184                            | /29 | …                                     | /64 | REZERVED                 |
| 172.17.0.192                            | /29 | 2000:AAAD:1:130::                     | /64 | MOWOSPF1<->DSWWAN1       |
| 172.17.0.200                            | /29 | 2000:AAAD:1:131::                     | /64 | MOWOSPF1<->DSWWAN2       |
| 172.17.0.208                            | /29 | 2000:AAAD:1:132::                     | /64 | REZERVED                 |
| …                                       |     | …                                     | /64 |                          |
| 172.17.0.248                            | /29 | 2000:AAAD:1:1ff::                     | /64 | REZERVED                 |
|                                         |     |                                       |     |                          |
| OSPF1 IPv4 SUMMARY 172.17.1.0 /24: 31x172.17.1.0 /29|| OSPF1 IPv6 SUMMARY 2000:AAAD:1:200::/56 = 256 /64  |||
| PREFIX                                  | MASK| PREFIX                                  | MASK| Description/Device(port) |
| 172.17.1.0                              | /29 | 2000:AAAD:1:200::                     | /64 | MOWOSPF1<->Lo0           |
| 172.17.1.8                              | /29 | 2000:AAAD:1:201::                     | /64 | REZERVED                 |
| …                                       | /29 | …                                     | /64 | REZERVED                 |
| 172.17.1.248                            | /29 | 2000:AAAD:1:2ff::/64                  | /64 | REZERVED                 |
| …                                       | /29 | …                                     | …   |                          |
|                                         |     |                                       |     |                          |
| OSPF2 IPv4 SUMMARY 172.17.2.0 /24: 31x172.17.2.0 /29|| OSPF2 IPv6 SUMMARY 2000:AAAD:1:300::/56 = 256 /64  |||
| PREFIX                                  | MASK| PREFIX                                  | MASK| Description/Device(port) |
| 172.17.2.0                              | /29 | 2000:AAAD:1:300::                     | /64 | AGGRSWDC1<->DCSW1        |
| 172.17.2.8                              | /29 | 2000:AAAD:1:301::                     | /64 | AGGRSWDC1<->DCSW2        |
| 172.17.2.16                             | /29 | 2000:AAAD:1:302::                     | /64 | AGGRSWDC2<->DCSW1        |
| 172.17.2.24                             | /29 | 2000:AAAD:1:303::                     | /64 | AGGRSWDC2<->DCSW2        |
| 172.17.2.32                             | /29 | 2000:AAAD:1:304::                     | /64 | REZERVED                 |
| …                                       |     | …                                     |     | REZERVED                 |
| 172.17.2.248                            | /29 | 2000:AAAD:1:3ff::/64                  | /64 | REZERVED                 |
| …                                       |     | …                                     |     |                          |
|                                         |     |                                       |     |                          |
| OSPF3 IPv4 SUMMARY 172.17.3.0 /24: 31x172.17.3.0 /29|| OSPF3 IPv6 SUMMARY 2000:AAAD:1:400::/56 = 256 /64  |||
| PREFIX                                  | MASK| PREFIX                                  | MASK| Description/Device(port) |
| 172.17.3.0                              | /29 | 2000:AAAD:1:400::                     | /64 | DSWACC1<->ASW1           |
| 172.17.3.8                              | /29 | 2000:AAAD:1:401::                     | /64 | DSWACC1<->ASW2           |
| 172.17.3.16                             | /29 | 2000:AAAD:1:402::                     | /64 | DSWACC2<->ASW1           |
| 172.17.3.24                             | /29 | 2000:AAAD:1:403::                     | /64 | DSWACC1<->ASW2           |
| 172.17.3.32                             | /29 | 2000:AAAD:1:404::                     | /64 | REZERVED                 |
| …                                       |     | …                                     |     |                          |
| 172.17.3.248                            | /29 | 2000:AAAD:1:4ff::/64                  | /64 | REZERVED                 |
</details>

<details>
<summary>Сервера </summary>

| SERVER 172.17.16-31.0 /24 |     | SERVER 2000:AAAD:1:500::/56 = 256 /64 |     |      |            |
|---------------------------|-----|---------------------------------------|-----|------|------------|
|PREFIX                    | MASK | PREFIX                               | MASK | VLAN | Description/Device(port) |
| 172.17.16.0               | /24 | 2000:AAAD:1:500::                     | /64 | 16   | SRV_NET1   |
| 172.17.17.0               | /24 | 2000:AAAD:1:501::                     | /64 | 17   | SRV_NET2   |
| 172.17.18.0               | /24 | 2000:AAAD:1:502::                     | /64 |      | REZERVED  |
| …                         |     | …                                     |     |      |            |
| 172.17.31.0               | /24 | 2000:AAAD:1:5ff::                     | /64 |      |REZERVED  |

</details>

<details>
<summary>Клиентские сети </summary>

| ACCESS 172.17.64-127.0 /26                   || ACCESS 2000:AAAD:1:600::/56 = 256 /64                                |    |||
|----------------------------------------------|-----|----------------------------------------------------------------------|-----|--------|------------------|
| ACCESS PC 172.17.64-69.0 /26                 |     | ACCESS PC: 15 networks 2000:AAAD:1:600::/64 - 2000:AAAD:1:60f::/64   |     |       |                  |
| PREFIX                                       | MASK | PREFIX                                                              | MASK | VLAN  | примечание       |
| 172.17.64.0                                  | /24 | 2000:AAAD:1:601::                                                    | /64 | VLAN61 | PC - Floor1      |
| 172.17.65.0                                  | /24 | 2000:AAAD:1:602::                                                    | /64 | VLAN62 | PC - Floor2      |
| 172.17.66.0                                  | /24 | 2000:AAAD:1:603::                                                    | /64 | VLAN63 | PC - Floor3      |
| 172.17.67.0                                  | /24 | 2000:AAAD:1:604::                                                    | /64 | VLAN64 | PC - Floor4      |
| 172.17.68.0                                  | /24 | 2000:AAAD:1:605::                                                    | /64 | VLAN65 | PC - Floor5      |
| 172.17.69.0                                  | /24 | …                                                                    | /64 | VLAN66 | PC - REZERVED    |
| ACCESS PRN 172.17.70.0 /24: 4x172.17.70.0/25 |     | ACCESS PRN 15 networks 2000:AAAD:1:610::/64 - 2000:AAAD:1:61f::/64   |     |        |                  |
| ACCESS PRN 172.17.71.0 /24: 4x172.17.71.0/25 |     |                                                                      |     |        |                  |
| PREFIX                                       | MASK | PREFIX                                                              | MASK | VLAN  | примечание       |
| 172.17.70.0                                  | /26 | 2000:AAAD:1:611::                                                    | /64 | VLAN71 | PRN - Floor1     |
| 172.17.70.64                                 | /26 | 2000:AAAD:1:612::                                                    | /64 | VLAN72 | PRN - Floor2     |
| 172.17.70.128                                | /26 | 2000:AAAD:1:613::                                                    | /64 | VLAN73 | PRN - Floor3     |
| 172.17.70.192                                | /26 | 2000:AAAD:1:614::                                                    | /64 | VLAN74 | PRN - Floor4     |
| 172.17.71.0                                  | /26 | 2000:AAAD:1:615::                                                    | /64 | VLAN75 | PRN - Floor5     |
| 172.17.71.64                                 | /26 | …                                                                    | /64 | VLAN76 | PRN - REZERVED   |
| 172.17.71.128                                | /26 | …                                                                    | /64 | VLAN77 | PRN - REZERVED   |
| 172.17.71.192                                | /26 | …                                                                    | /64 | VLAN78 | PRN - REZERVED   |
|                                              |     |                                                                      |     |        |                  |
| ACCESS PHONE 172.17.80-89.0 /24              |     | ACCESS PHONE 15 networks 2000:AAAD:1:620::/64 - 2000:AAAD:1:62f::/64 |     |        |                  |
| PREFIX                                       | MASK | PREFIX                                                              | MASK | VLAN  | примечание       |
| 172.17.81.0                                  | /24 | 2000:AAAD:1:621::                                                    | /64 | VLAN81 | PHONE - Floor1   |
| 172.17.82.0                                  | /24 | 2000:AAAD:1:622::                                                    | /64 | VLAN82 | PHONE - Floor2   |
| 172.17.83.0                                  | /24 | 2000:AAAD:1:623::                                                    | /64 | VLAN83 | PHONE - Floor3   |
| 172.17.84.0                                  | /24 | 2000:AAAD:1:624::                                                    | /64 | VLAN84 | PHONE - Floor4   |
| 172.17.85.0                                  | /24 | 2000:AAAD:1:625::                                                    | /64 | VLAN85 | PHONE - Floor5   |
| 172.17.86.0                                  | /24 | …                                                                    | /64 | VLAN86 | PHONE - REZERVED |
| 172.17.87.0                                  | /24 | …                                                                    | /64 | VLAN87 | PHONE - REZERVED |
| 172.17.88.0                                  | /24 | …                                                                    | /64 | VLAN88 | PHONE - REZERVED |
| 172.17.89.0                                  | /24 | 2000:AAAD:1:629::                                                    | /64 | VLAN89 | PHONE - REZERVED |
| 172.17.80.0                                  | /24 | …                                                                    | /64 | VLAN80 | PHONE - REZERVED |
| ACCESS Wi-Fi 172.17.90-99.0 /24              |     | ACCESS Wi-Fi 15 networks 2000:AAAD:1:630::/64 - 2000:AAAD:1:63f::/64 |     |        |                  |
| PREFIX                                       | MASK | PREFIX                                                              | MASK | VLAN   | примечание       |
| 172.17.91.0                                  | /24 | 2000:AAAD:1:631::                                                    | /64 | VLAN91 | Wi-Fi - Floor1   |
| 172.17.92.0                                  | /24 | 2000:AAAD:1:632::                                                    | /64 | VLAN92 | Wi-Fi - Floor2   |
| 172.17.93.0                                  | /24 | 2000:AAAD:1:633::                                                    | /64 | VLAN93 | Wi-Fi - Floor3   |
| 172.17.94.0                                  | /24 | 2000:AAAD:1:634::                                                    | /64 | VLAN94 | Wi-Fi - Floor4   |
| 172.17.95.0                                  | /24 | 2000:AAAD:1:635::                                                    | /64 | VLAN95 | Wi-Fi - Floor5   |
| 172.17.96.0                                  | /24 | …                                                                    | /64 | VLAN96 | PHONE - REZERVED |
| 172.17.97.0                                  | /24 | …                                                                    | /64 | VLAN97 | PHONE - REZERVED |
| 172.17.98.0                                  | /24 | …                                                                    | /64 | VLAN98 | PHONE - REZERVED |
| 172.17.99.0                                  | /24 | 2000:AAAD:1:629::                                                    | /64 | VLAN99 | PHONE - REZERVED |

</details>


___Санкт-Петербург___

<details>
<summary>Санкт-Петербург </summary>

|     Офис   |   |       IPv4     |      IPv6          |  Устройства  |
|------------|---|----------------|--------------------|--------------|
|     Москва-summary    |   | 172.17.0.0 /16 |  2000:AAAD:1::/32  |       |
|     Санкт-Петербург-summary    |   | 172.18.0.0 /16 |  2000:AAAD:2::/32  |       |
| Чокурдах-summary   |   | 172.19.0.0 /16 |  2000:AAAD:3::/32  |       |
| Лабытнанги-summary |   | 172.20.0.0 /16 |  2000:AAAD:4::/32  |       |
</details>

<details>
<summary>Чокурдах </summary>

|     Офис   |   |       IPv4     |      IPv6          |  Устройства  |
|------------|---|----------------|--------------------|--------------|
|     Москва-summary    |   | 172.17.0.0 /16 |  2000:AAAD:1::/32  |       |
|     Санкт-Петербург-summary    |   | 172.18.0.0 /16 |  2000:AAAD:2::/32  |       |
| Чокурдах-summary   |   | 172.19.0.0 /16 |  2000:AAAD:3::/32  |       |
| Лабытнанги-summary |   | 172.20.0.0 /16 |  2000:AAAD:4::/32  |       |
</details>

<details>
<summary>Лабытнанги </summary>

|     Офис   |   |       IPv4     |      IPv6          |  Устройства  |
|------------|---|----------------|--------------------|--------------|
|     Москва-summary    |   | 172.17.0.0 /16 |  2000:AAAD:1::/32  |       |
|     Санкт-Петербург-summary    |   | 172.18.0.0 /16 |  2000:AAAD:2::/32  |       |
| Чокурдах-summary   |   | 172.19.0.0 /16 |  2000:AAAD:3::/32  |       |
| Лабытнанги-summary |   | 172.20.0.0 /16 |  2000:AAAD:4::/32  |       |
</details>



##  Задание 2: настроить адреса (ipv4 и ipv6) на каждом активном порту
##  Задание 3: настроить VLAN управления для сетевых устройств
##  Задание 4: настроить сети офисов так, чтобы не возникало broadcast штормов, а использование линков было максимально оптимизировано
Всего перед нами 4 сегмента распределенной сети предприятия:
1. ЦО/ЦОД - Москва
2. Бранч СПб
3. Бранч Чокурдах
4. Бранч Лабытнанги

Исходя из количества оборудования и предполагая запас на рост предприятия, выбираем сеть класса B 172.16.0.0 /12. Данную подсеть легко разбить на нужные сегменты.
| Офис  | Диапазон подсетей  | 
|-------|--------------------|
| ЦО/ЦОД - Москва  | 172.17.0.0/16 - 172.17.255.255/16  |
| Бранч СПб  | 172.18.0.0/16 - 172.18.255.255/16 |
| Бранч Чокурдах  | 172.19.0.0/16 - 172.19.255.255/16 | 
| Бранч Лабытнанги  | 172.20.0.0/16 - 172.20.255.255/16 |

Для визуализации разбиения используем представление адресного пространства в виде квадрата, где цвет соответствует занятому диапазону. Далее будем использовать аналогичный способ:

![](/LECTURES/MODULE02/Lecture10/pictures/32.jpg)

Каждую из выделенных подсетей также легко разбить на нужные сегменты, при этом будут соблюдены принципы последующей суммаризации сегментов, отвечающих за тот или иной участок, например: серверный сегмент,  сегменты принтеров, поэтажные пользовательские сегменты  и т.д.

![](/LECTURES/MODULE02/Lecture10/pictures/33.jpg)

Настройки WAN представлены в pdf-файле

[AddressSpace20210528.pdf](/LECTURES/MODULE02/Lecture10/labs/AddressSpace20210528.pdf)

Настройки оборудования, в том числе для подсети управления пока выполнены для ipv4.

[01-ISP1](/LECTURES/MODULE02/Lecture10/labs/01-ISP1.txt)
[02-ISP2](/LECTURES/MODULE02/Lecture10/labs/02-ISP2.txt)
[03-01-EDGE1](/LECTURES/MODULE02/Lecture10/labs/03-01-EDGE1.txt)
[03-01-EDGE2](/LECTURES/MODULE02/Lecture10/labs/03-01-EDGE2.txt)
[03-01-EDGEOSPF1](/LECTURES/MODULE02/Lecture10/labs/03-01-EDGEOSPF1.txt)
[03-02-DSWWAN1](/LECTURES/MODULE02/Lecture10/labs/03-02-DSWWAN1.txt)
[03-02-DSWWAN2](/LECTURES/MODULE02/Lecture10/labs/03-02-DSWWAN2.txt)
[03-03-CORE1](/LECTURES/MODULE02/Lecture10/labs/03-03-CORE1.txt)
[03-03-CORE2](/LECTURES/MODULE02/Lecture10/labs/03-03-CORE2.txt)
[03-04-AGGRSWDC1](/LECTURES/MODULE02/Lecture10/labs/03-04-AGGRSWDC1.txt)
[03-04-AGGRSWDC2](/LECTURES/MODULE02/Lecture10/labs/03-04-AGGRSWDC2.txt)
[03-05-DSWACC1](/LECTURES/MODULE02/Lecture10/labs/03-05-DSWACC1.txt)
[03-05-DSWACC2](/LECTURES/MODULE02/Lecture10/labs/03-05-DSWACC2.txt)
[03-10-ASW1](/LECTURES/MODULE02/Lecture10/labs/03-10-ASW1.txt)
[03-10-ASW2](/LECTURES/MODULE02/Lecture10/labs/03-10-ASW2.txt)
[03-11-DCSW1](/LECTURES/MODULE02/Lecture10/labs/03-11-DCSW1.txt)
[03-11-DCSW2](/LECTURES/MODULE02/Lecture10/labs/03-11-DCSW2.txt)
[04-R23](/LECTURES/MODULE02/Lecture10/labs/04-R23.txt)
[04-R24](/LECTURES/MODULE02/Lecture10/labs/04-R24.txt)
[04-R25](/LECTURES/MODULE02/Lecture10/labs/04-R25.txt)
[04-R26](/LECTURES/MODULE02/Lecture10/labs/04-R26.txt)
[05-1-EDGE-R31](/LECTURES/MODULE02/Lecture10/labs/05-1-EDGE-R31.txt)
[05-1-EDGEEIGRP-R32](/LECTURES/MODULE02/Lecture10/labs/05-1-EDGEEIGRP-R32.txt)
[05-2-DSWCOLCORE16](/LECTURES/MODULE02/Lecture10/labs/05-2-DSWCOLCORE16.txt)
[05-2-DSWCOLCORE17](/LECTURES/MODULE02/Lecture10/labs/05-2-DSWCOLCORE17.txt)
[05-5-ASW3](/LECTURES/MODULE02/Lecture10/labs/05-5-ASW3.txt)
[05-5-ASW4](/LECTURES/MODULE02/Lecture10/labs/05-5-ASW4.txt)
[06-1-EDGE-R28](/LECTURES/MODULE02/Lecture10/labs/06-1-EDGE-R28.txt)
[06-5-ASW29](/LECTURES/MODULE02/Lecture10/labs/06-5-ASW29.txt)
[07-1-EDGE-R27](/LECTURES/MODULE02/Lecture10/labs/07-1-EDGE-R27.txt)
