# Разбиение адресного пространства #

Цель:
- разработать и задокументировать адресное пространство (ipv4 и ipv6) для лабораторного стенда.
- настроить ipv4 и ipv6-адреса на каждом активном порту
- настроить каждый VPC в каждом офисе в своем VLAN.
- настроить VLAN управления для сетевых устройств
- настроить сети офисов так, чтобы не возникало broadcast штормов, а использование линков было максимально оптимизировано

Cхема сети ipv4, ipv6

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

##  Задание 1: разработать и задокументировать адресное пространство (ipv4 и ipv6) для лабораторного стенда

### 1.1 Адреса WAN, AS

![](/LECTURES/MODULE02/Lecture10/pictures/34.jpg)
<details>
<summary>ISP: ASN, Summary</summary>

|     Офис   |   ASN  |  Подсети IPv4 |   Подсети IPv6  |  Устройства  |
|------------|--------|---------------|-----------------|--------------|
| WAN TRIADA | AS520  | 50.0.56.0/24  | 2000:AAAA::/32  | R23, R24, R25, R26|
| WAN KITORN | AS101  | 100.1.1.0/24  | 2000:AAAB::/32  | R-ISP1  |
| WAN LIMAS  | AS301  | 30.1.35.0/24  | 2000:AAAC::/32  | R-ISP2  |
</details>

<details>
<summary>TRIADA</summary>

| ISP-TRIADA                     |     | ISP-TRIADA: 2000:AAAA::0 / 48                            |      |                                    |                                 |
|--------------------------------|-----|----------------------------------------------------------|------|------------------------------------|---------------------------------|
| TRIADA INSIDE: 52.0.56.0/26    |     | TRIADA INSIDE:  2000:AAAA:0::/48                         |      |                                    |                                 |
| NET Address                    | NET | NET Address                                              | NET  | Description                        | примечание                      |
| 52.0.56.0                      | /29 | 2000:AAAA::0                                             | /126 | R23 (Gi0/1) - R24 (Gi0/1)          | TRIADAR23-TO-TRIADAR24          |
| 52.0.56.8                      | /29 | 2000:AAAA::8                                             | /126 | R23 (Gi0/2) - R25 (Gi0/2)          | TRIADAR23-TO-TRIADAR25          |
| 52.0.56.16                     | /29 | 2000:AAAA::10                                            | /126 | R24 (Gi0/2) - R26 (Gi0/2)          | TRIADAR24-TO-TRIADAR26          |
| 52.0.56.24                     | /29 | 2000:AAAA::18                                            | /126 | R25 (Gi0/1) - R26 (Gi0/1)          | TRIADAR25-TO-TRIADAR26          |
| 52.0.56.32                     | /29 | 2000:AAAA::20                                            | /126 | REZERVED                           |                                 |
| 52.0.56.40                     | /29 | 2000:AAAA::28                                            | /126 | REZERVED                           |                                 |
| 52.0.56.48                     | /29 | 2000:AAAA::30                                            | /126 | REZERVED                           |                                 |
| 52.0.56.56                     | /29 | 2000:AAAA::38                                            | /126 | REZERVED                           |                                 |
|                                |     | …                                                        |      |                                    |                                 |
| TRIADA OUTSIDE1: 52.0.56.64/26 |     | TRIADA OUTSIDE1: 2000:AAAA:1::/48                        |      |                                    |                                 |
| NET Address                    | NET | NET Address                                              | NET  | Description                        | примечание                      |
| 52.0.56.64                     | /30 | 2000:AAAA:1:1::0                                         | /64  | R23 (Gi0/0) - ISP1 (Gi0/0)         | TRIADA-TO-KITORN_ISP1           |
| 52.0.56.68                     | /30 | 2000:AAAA:1:2::0                                         | /64  | R24 (Gi0/0) - ISP2 (Gi0/0)         | TRIADA-TO-LAMAS_ISP2            |
|                                |     | TRIADA OUTSIDE2: 2000:AAAA:400::0-2000:AAAA:АААА::0 / 64 |      |                                    |                                 |
| 52.0.56.72                     | /30 | 2000:AAAA:400::0                                         | /64  | R24 (Gi0/3) - EDGE-R31 (Gi0/0)     | TRIADA-TO-SPB-1                 |
| 52.0.56.76                     | /30 | 2000:AAAA:401::0                                         | /64  | R26 (Gi0/3) - EDGE-R31 (Gi0/1)     | TRIADA-TO-SPB-2                 |
| 52.0.56.80                     | /30 | 2000:AAAA:402::0                                         | /64  | R26 (Gi0/0) - EDGE-R28 (Gi0/0.110) | TRIADA-TO-CHOKURDAKHR_EDGE-28-1 |
| 52.0.56.84                     | /30 | 2000:AAAA:403::0                                         | /64  | R25 (Gi0/0) - EDGE-R28 (Gi0/0.120) | TRIADA-TO-CHOKURDAKH_EDGE-R28-2 |
| 52.0.56.88                     | /30 | 2000:AAAA:404::0                                         | /64  | R25 (Gi0/3) - EDGE-R27 (Gi0/0)     | TRIADA-TO-LABYTNANGI_EDGE-R27   |
| 52.0.56.92                     | /30 | 2000:AAAA:405::0                                         | /64  | REZERVED                           |                                 |
| …                              | …   | …                                                        | …    |                                    |                                 |
| 52.0.56.124                    | /30 | 2000:AAAA:FFFF::FFFF                                     | /30  | REZERVED                           |                                 |

</details>

<details>
<summary>КИТОРН</summary>

| ISP-KITORN                      |     | WAN KITORN AS101 2000:AAAB::/32                          |     |                              |                       |
|---------------------------------|-----|----------------------------------------------------------|-----|------------------------------|-----------------------|
| ISP-KITORN to ISP-TRIADA        |     | ISP-KITORN to ISP-TRIADA                                 |     |                              |                       |
| NET Address                     | NET | NET Address                                              | NET | Description                  | примечание            |
| 52.0.56.64                      | /30 | 2000:AAAA:1:1::0                                         | /64 | R23 (Gi0/0) - ISP1 (Gi0/0)   | KITORN_ISP1-TO-TRIADA |
|                                 |     |                                                          |     |                              |                       |
| KITORN INSIDE: 100.1.1.0 /26    |     | KITORN INSIDE:  2000:AAAB:0::/48                         |     |                              |                       |
| NET Address                     | NET | NET Address                                              | NET | Description                  | примечание            |
| 100.1.1.0                       | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.8                       | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.16                      | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.24                      | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.32                      | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.40                      | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.48                      | /29 |                                                          |     | REZERVED                     |                       |
| 100.1.1.56                      | /29 |                                                          |     | REZERVED                     |                       |
|                                 |     |                                                          |     |                              |                       |
| KITORN OUTSIDE1: 100.1.1.64 /27 |     | KITORN OUTSIDE1: 2000:AAAB:1::/48                        |     |                              |                       |
| NET Address                     | NET | NET Address                                              | NET | Description                  | примечание            |
| 100.1.1.64                      | /30 | 2000:AAAB:1:1::0                                         | /64 | EDGE1 (Gi0/1) - ISP1 (Gi0/1) | KITORN_ISP1-TO-LIMAS_ISP2 |
| …                               | /30 |                                                          |     |                              |                       |
| 100.1.1.95                      | /30 |                                                          |     | REZERVED                     |                       |
| KITORN OUTSIDE2: 100.1.1.96 /27 |     | KITORN OUTSIDE2: 2000:AAAB:400::0 / 64                   |     |                              |                       |
| NET Address                     | NET | NET Address                                              | NET | Description                  | примечание            |
| 100.1.1.96                      | /30 | 2000:AAAB:400::0                                         | /64 | EDGE1 (Gi0/1) - ISP1 (Gi0/1) | KITORN_ISP1-TO-EDGE1  |
| …                               | /30 | …                                                        |     |                              |                       |
| 100.1.1.127                     | /30 | 2000:AAAB:АААА::0                                        | /64 | REZERVED                     |                       |
</details>

<details>
<summary>ЛИМАС</summary>

| WAN LIMAS AS301 30.1.35.0 /24  |     | WAN LIMAS AS301 2000:AAAC::/32                          |      |                              |                           |
|--------------------------------|-----|---------------------------------------------------------|------|------------------------------|---------------------------|
| ISP-LIMAS to ISP-TRIADA        |     | ISP-LIMAS to ISP-TRIADA                                 |      |                              |                           |
| NET Address                    | NET | NET Address                                             | NET  | Description                  | примечание                |
| 52.0.56.68                     | /30 | 2000:AAAA:1:2::0                                        | /64  | R24 (Gi0/0) - ISP2 (Gi0/0)   | LIMAS_ISP2-TO-TRIADA      |
|                                |     |                                                         |      |                              |                           |
| ISP-LIMAS to ISP KITORN        |     | ISP-LIMAS to ISP-KITORN                                 |      |                              |                           |
| NET Address                    | NET | NET Address                                             | NET  | Description                  | примечание                |
| 100.1.1.64                     | /30 | 2000:AAAB:1:1::0                                        | /64  | ISP1 (Gi0/2) - ISP2 (Gi0/2)  | KITORN_ISP1-TO-LIMAS_ISP2 |
|                                |     |                                                         |      |                              |                           |
| LIMAS INSIDE: 30.1.35.0 /26    |     | LIMAS INSIDE:  2000:AAAC:0::/48                         |      |                              |                           |
| NET Address                    | NET | NET Address                                             | NET  | Description                  | примечание                |
| 30.1.35.0                      | /29 | 2000:AAAC::0                                            | /126 | REZERVED                     |                           |
| 30.1.35.8                      | /29 | 2000:AAAC::8                                            | /126 | REZERVED                     |                           |
| 30.1.35.16                     | /29 | 2000:AAAC::10                                           | /126 | REZERVED                     |                           |
| 30.1.35.24                     | /29 | 2000:AAAC::18                                           | /126 | REZERVED                     |                           |
| ...                            | /29 |                                                         |      | REZERVED                     |                           |
| 30.1.35.56                     | /29 |                                                         |      | REZERVED                     |                           |
|                                |     |                                                         |      |                              |                           |
| LIMAS OUTSIDE1: 30.1.35.64 /27 |     | LIMAS OUTSIDE1: 2000:AAAC:1::/48                        |      |                              |                           |
| NET Address                    | NET | NET Address                                             | NET  | Description                  | примечание                |
| 30.1.35.64                     | /30 | 2000:AAAC:1:1::0                                        | /64  | REZERVED                     |                           |
| ...                            | /30 | ...                                                     |      | REZERVED                     |                           |
| 30.1.35.92                     | /30 | 2000:AAAC:1:399::0                                      | /64  | REZERVED                     |                           |
|                                |     |                                                         |      |                              |                           |
| LIMAS OUTSIDE2: 100.1.1.64 /26 |     | LIMAS OUTSIDE2: 2000:AAAC:400::0-2000:AAAC:АААА::0 / 64 |      |                              |                           |
| NET Address                    | NET | NET Address                                             | NET  | Description                  | примечание                |
| 30.1.35.96                     | /30 | 2000:AAAC:400::0                                        | /64  | EDGE2 (Gi0/1) - ISP2 (Gi0/1) | LIMAS_ISP2-TO-EDGE2       |
| ...                            | /30 | ...                                                     |      | REZERVED                     |                           |
| 30.1.35.127                    | /30 | 2000:AAAC:АААА::0                                       | /64  |                              |                           |
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

| PREFIX                                  | MASK| PREFIX                                  | MASK| Description/Device(port) |
|:-----------------------------------------|-|---------------------------------------|-----|--------------------------|
| AREA0 IPv4 172.17.0.0 /28 = 31x172.17.0.0 /29     || AREA0 IPv6 2000:AAAD:1:100::/56 = 256 /64  |||
| PREFIX                                  | MASK| PREFIX                                  | MASK| Description/Device(port) |
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

![](/LECTURES/MODULE02/Lecture10/pictures/36.jpg)
<details>
<summary>EIGRP </summary>

| SUMMARY 172.18.0.0 /20                  |     | SUMMARY 2000:AAAD:2::/48 = 256x256/56|     |                             |
|-----------------------------------------|-----|--------------------------------------|-----|-----------------------------|
| AS100 172.18.0.0 /28: 31x172.18.0.0 /29 |     | AS100 2000:AAAD:2:100::/56 = 256 /64 |     |                             |
| NET Address                             | NET | NET Address                          | NET | Description/Device(port)    |
| 172.18.0.0                              | /29 | 2000:AAAD:2:100::                    | /64 | EDGE-R31<->DSWWAN17         |
| 172.18.0.8                              | /29 | 2000:AAAD:2:101::                    | /64 | EDGE-R31<->DSWWAN16         |
| 172.18.0.16                             | /29 | 2000:AAAD:2:102::                    | /64 | EDGEEIGRP-R32<->DSWWAN17    |
| 172.18.0.24                             | /29 | 2000:AAAD:2:103::                    | /64 | EDGEEIGRP-R32<->DSWWAN16    |
| 172.18.0.32                             | /29 | 2000:AAAD:2:104::                    | /64 | REZERVED                    |
| 172.18.0.40                             | /29 | 2000:AAAD:2:105::                    | /64 | REZERVED                    |
| 172.18.0.48                             | /29 | 2000:AAAD:2:106::                    | /64 | DSWCOLCORE17<->DSWCOLCORE16 |
| 172.18.0.56                             | /29 | 2000:AAAD:2:107::                    | /64 | DSWCOLCORE17<->ASW3         |
| 172.18.0.64                             | /29 | 2000:AAAD:2:108::                    | /64 | DSWCOLCORE17<->ASW4         |
| 172.18.0.72                             | /29 | 2000:AAAD:2:109::                    | /64 | DSWCOLCORE16<->ASW1         |
| 172.18.0.80                             | /29 | 2000:AAAD:2:10a::                    | /64 | DSWCOLCORE16<->ASW2         |
| 172.18.0.88                             | /29 | 2000:AAAD:2:10b::                    | /64 | REZERVED                    |
| …                                       | …   | …                                    | …   | REZERVED                    |
| 172.18.0.248                            | /29 | 2000:AAAD:2:1ff::                    | /64 | REZERVED                    |
|                                         |     |                                      |     |                             |
| AS101 172.18.1.0 /28: 31x172.18.1.0 /29 |     | AS101 2000:AAAD:2:200::/56 = 256 /64 |     |                             |
| 172.18.1.0                              | /29 | 2000:AAAD:2:201::                    | /64 | EDGEEIGRP-R32<->Lo0         |
| 172.18.1.8                              | /29 | 2000:AAAD:2:2ff::                    | /29 | REZERVED                    |
</details>

<details>
<summary>Сервера </summary>
Под сервера зарезервирован диапазон 172.18.16.0 /20
</details>

<details>
<summary>Клиентские сети </summary>


| ACCESS 172.18.64.0 /18                       |     | ACCESS 2000:AAAD:2:600::/56 = 256 /64                                 |     |        |                  |
|----------------------------------------------|-----|-----------------------------------------------------------------------|-----|--------|------------------|
| ACCESS PC 172.18.64-69.0 /24                 |     | ACCESS PC: 15 networks 2000:AAAD:2:600::/64 - 2000:AAAD:1:60f::/64    |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.18.64.0                                  | /24 | 2000:AAAD:2:601::                                                     | /64 | VLAN61 | PC - Floor1      |
| 172.18.65.0                                  | /24 | 2000:AAAD:2:602::                                                     | /64 | VLAN62 | PC - Floor2      |
| 172.18.66.0                                  | /24 | …                                                                     | …   | VLAN63 | PC - REZERVED    |
| 172.18.69.0                                  | /24 | 2000:AAAD:2:609::                                                     | /64 | VLAN69 | PC - REZERVED    |
| ACCESS PRN 172.18.70.0 /24: 4x172.18.70.0/26 |     | ACCESS PRN: 15 networks 2000:AAAD:2:610::/64 - 2000:AAAD:2:61f::/64   |     |        |                  |
| ACCESS PRN 172.18.71.0 /24: 4x172.18.71.0/26 |     |                                                                       |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.18.70.0                                  | /26 | 2000:AAAD:2:611::                                                     | /64 | VLAN71 | PRN - Floor1     |
| 172.18.70.64                                 | /26 | 2000:AAAD:2:612::                                                     | /64 | VLAN72 | PRN - Floor2     |
| 172.18.70.128                                | /26 | …                                                                     | …   | VLAN73 | PRN - REZERVED   |
| 172.18.70.192                                | /26 | 2000:AAAD:2:619::                                                     | /64 | VLAN79 | PRN - REZERVED   |
| ACCESS PHONE 172.18.80-89.0 /24              |     | ACCESS PHONE: 15 networks 2000:AAAD:2:630::/64 - 2000:AAAD:2:63f::/64 |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.18.81.0                                  | /24 | 2000:AAAD:2:621::                                                     | /64 | VLAN81 | PHONE - Floor1   |
| 172.18.82.0                                  | /24 | 2000:AAAD:2:622::                                                     | /64 | VLAN82 | PHONE - REZERVED |
| 172.18.84.0                                  | /24 | …                                                                     | …   | VLAN84 | PHONE - REZERVED |
| 172.18.89.0                                  | /24 | 2000:AAAD:2:629::                                                     | /64 | VLAN89 | PHONE - REZERVED |
| ACCESS Wi-Fi 172.18.90-99.0 /24              |     | ACCESS Wi-Fi: 15 networks 2000:AAAD:2:640::/64 - 2000:AAAD:2:64f::/64 |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.18.91.0                                  | /24 | 2000:AAAD:2:631::                                                     | /64 | VLAN91 | Wi-Fi - Floor1   |
| 172.18.92.0                                  | /24 | 2000:AAAD:2:632::                                                     | /64 | VLAN92 | W-Fi - REZERVED  |
| 172.18.94.0                                  | /24 | …                                                                     | …   | VLAN94 | W-Fi - REZERVED  |
| 172.18.99.0                                  | /24 | 2000:AAAD:2:639::                                                     | /64 | VLAN99 | W-Fi - REZERVED  |

</details>

___Чокурдах___

![](/LECTURES/MODULE02/Lecture10/pictures/37.jpg)

<details>
<summary>Сетевое оборудование </summary>

| LAN 172.19.0.0 /16: 31x172.19.0.0 /29  |     | LAN 2000:AAAD:3::/48 = 256x256/56    |     |                          |
|----------------------------------------|-----|--------------------------------------|-----|--------------------------|
| LAN0 172.19.0.0 /24: 31x172.19.0.0 /29 |     | LAN0: 2000:AAAD:3:100::/56 = 256 /64 |     |                          |
| NET Address                            | NET | NET Address                          | NET | Description/Device(port) |
| 172.19.0.0                             | /29 | 2000:AAAD:3:100::                    | /64 | EDGE-R28<->ASW29         |
| 172.19.0.8                             | /29 | 2000:AAAD:3:101::                    | /64 | REZERVED                 |
| …                                      | …   | …                                    | …   |                          |
| 172.19.0.248                           | /28 | 2000:AAAD:3:1ff::                    | /64 | REZERVED                 |

</details>

<details>
<summary>Сервера </summary>
Под сервера зарезервирован диапазон 172.19.16.0 /20
</details>

<details>
<summary>Клиентские сети  </summary>

| ACCESS 172.19.64-127.0 /18                   |     | ACCESS  2000:AAAD:3:600::/56 = 256 /64                                |     |        |                  |
|----------------------------------------------|-----|-----------------------------------------------------------------------|-----|--------|------------------|
| ACCESS PC 172.19.64-69.0 /24                 |     | ACCESS PC  15 networks 2000:AAAD:3:600::/64 - 2000:AAAD:3:60f::/64    |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.19.64.0                                  | /24 | 2000:AAAD:3:601::                                                     | /64 | VLAN61 | PC - Floor1      |
| 172.19.65.0                                  | /24 | …                                                                     | …   | VLAN62 | PC - REZERVED    |
| ACCESS PRN 172.19.70.0 /24: 4x172.19.70.0/26 |     | ACCESS PRN 15 networks 2000:AAAD:3:610::/64 - 2000:AAAD:3:61f::/64    |     |        |                  |
| ACCESS PRN 172.19.71.0 /24: 4x172.19.71.0/26 |     | …                                                                     | …   |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.19.70.0                                  | /26 | 2000:AAAD:3:610::                                                     | /64 | VLAN71 | PRN - Floor1     |
| 172.19.70.64                                 | /26 | …                                                                     | …   | VLAN72 | PRN - REZERVED   |
| 172.19.70.128                                | /26 | 2000:AAAD:3:618::                                                     | /64 | VLAN778 | PRN - REZERVED   |
| ACCESS PHONE 172.19.80-89.0 /24              |     | ACCESS PHONE 15 networks 2000:AAAD:3:620::/64 - 2000:AAAD:3:62f::/64  |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.19.81.0                                  | /24 | 2000:AAAD:3:620::                                                     | /64 | VLAN81 | PHONE - Floor1   |
| 172.19.82.0                                  | /24 | …                                                                     | …   | VLAN82 | PHONE - REZERVED |
| 172.19.89.0                                  | /24 | 2000:AAAD:3:629::                                                     | /64 | VLAN89 | PHONE - REZERVED |
| ACCESS Wi-Fi 172.19.90-99.0 /24              |     | ACCESS Wi-Fi  15 networks 2000:AAAD:3:630::/64 - 2000:AAAD:3:63f::/64 |     |        |                  |
| NET Address                                  | NET | NET Address                                                           | NET | VLAN   | примечание       |
| 172.19.91.0                                  | /24 | 2000:AAAD:3:630::                                                     | /64 | VLAN91 | Wi-Fi - Floor1   |
| 172.19.92.0                                  | /24 | …                                                                     | …   | VLAN92 | W-Fi - REZERVED  |
| 172.19.99.0                                  | /24 | 2000:AAAD:3:639::                                                     | /64 | VLAN99 | W-Fi - REZERVED  |

</details>

___Лабытнанги___

![](/LECTURES/MODULE02/Lecture10/pictures/38.jpg)

Выделять отдельных подсетей не стал, все устройства работают в 0 сегменте
<details>
<summary>Устройства </summary>

| LAN0 172.20.0.0 /24: 31x172.20.0.0 /29 |     | LAN0 2000:AAAD:4:100::/56 = 256 /64   |     |                 |                          |
|----------------------------------------|-----|---------------------------------------|-----|-----------------|--------------------------|
| NET Address                            | NET | NET Address                           | NET | Net Mask        | Description/Device(port) |
| 172.20.0.0                             | /29 | 2000:AAAD:4:101::                     | /64 | 255.255.255.248 | VLAN10                   |
| 172.20.0.8                             | /29 | 2000:AAAD:4:102::                     | /64 | 255.255.255.248 | VLAN 20                  |
| 172.20.0.16                            | /29 | …                                     | …   | 255.255.255.248 | REZERVED                 |
| 172.20.0.248                           | /29 | 2000:AAAD:4:1ff::                     | /64 | 255.255.255.248 | REZERVED                 |
</details>



##  Задание 2: настроить адреса (ipv4 и ipv6) на каждом активном порту
<details>
<summary>ISP Triada </summary>

| WAN TRIADA AS520 52.0.56.0/24  |     | WAN TRIADA AS520 2000:AAAA::/32                          |      |                                    |                                 |
|--------------------------------|-----|----------------------------------------------------------|------|------------------------------------|---------------------------------|
| ISP-TRIADA                     |     | ISP-TRIADA: 2000:AAAA::0 / 48                            |      |                                    |                                 |
| TRIADA INSIDE: 52.0.56.0/26    |     | TRIADA INSIDE:  2000:AAAA:0::/48                         |      |                                    |                                 |
| NET Address                    | NET |                                                          |      | Description                        | примечание                      |
| 52.0.56.0                      | /29 | 2000:AAAA::0                                             | /126 | R23 (Gi0/1) - R24 (Gi0/1)          | TRIADAR23-TO-TRIADAR24          |
| 52.0.56.1                      | /29 | 2000:AAAA::1                                             | /126 | R23 (Gi0/1)                        |                                 |
| 52.0.56.2                      | /29 | 2000:AAAA::2                                             | /126 | R24 (Gi0/1)                        |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.8                      | /29 | 2000:AAAA::8                                             | /126 | R23 (Gi0/2) - R25 (Gi0/2)          | TRIADAR23-TO-TRIADAR25          |
| 52.0.56.9                      | /29 | 2000:AAAA::9                                             | /126 | R23 (Gi0/2)                        |                                 |
| 52.0.56.10                     | /29 | 2000:AAAA::a                                             | /126 | R25 (Gi0/2)                        |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.16                     | /29 | 2000:AAAA::10                                            | /126 | R24 (Gi0/2) - R26 (Gi0/2)          | TRIADAR24-TO-TRIADAR26          |
| 52.0.56.17                     | /29 | 2000:AAAA::11                                            | /126 | R24 (Gi0/2)                        |                                 |
| 52.0.56.18                     | /29 | 2000:AAAA::12                                            | /126 | R26 (Gi0/2)                        |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.24                     | /29 | 2000:AAAA::18                                            | /126 | R25 (Gi0/1) - R26 (Gi0/1)          | TRIADAR25-TO-TRIADAR26          |
| 52.0.56.25                     | /29 | 2000:AAAA::19                                            | /126 | R25 (Gi0/1)                        |                                 |
| 52.0.56.26                     | /29 | 2000:AAAA::1A                                            | /126 | R26 (Gi0/1)                        |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.56                     | /29 |                                                          |      | REZERVED                           |                                 |
|                                |     |                                                          |      |                                    |                                 |
| TRIADA OUTSIDE1: 52.0.56.64/27 |     | TRIADA OUTSIDE1: 2000:AAAA:1::/48                        |      |                                    |                                 |
| NET Address                    | NET | NET Address                                              | NET  | Description                        | примечание                      |
| 52.0.56.64                     | /30 | 2000:AAAA:1:1::0                                         | /64  | R23 (Gi0/0) - ISP1 (Gi0/0)         | TRIADA-TO-KITORN_ISP1           |
| 52.0.56.65                     | /30 | 2000:AAAA:1:1::1                                         | /64  | R23 (Gi0/0)                        |                                 |
| 52.0.56.66                     | /30 | 2000:AAAA:1:1::2                                         | /64  | ISP1 (Gi0/0)                       |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.68                     | /30 | 2000:AAAA:1:2::0                                         | /64  | R24 (Gi0/0) - ISP2 (Gi0/0)         | TRIADA-TO-LAMAS_ISP2            |
| 52.0.56.69                     | /30 | 2000:AAAA:1:2::1                                         | /64  | R24 (Gi0/0)                        |                                 |
| 52.0.56.70                     | /30 | 2000:AAAA:1:2::2                                         | /64  | ISP2 (Gi0/0)                       |                                 |
| 52.0.56.91                     | /30 |                                                          |      |                                    |                                 |
|                                |     |                                                          |      |                                    |                                 |
| TRIADA OUTSIDE2: 52.0.56.92/27 |     | TRIADA OUTSIDE2: 2000:AAAA:400::0-2000:AAAA:АААА::0 / 64 |      |                                    |                                 |
| NET Address                    | NET | NET Address                                              | NET  | Description                        | примечание                      |
| 52.0.56.92                     | /30 | 2000:AAAA:400::0                                         | /64  | R24 (Gi0/3) - EDGE-R31 (Gi0/0)     | TRIADA-TO-SPB-1                 |
| 52.0.56.93                     | /30 | 2000:AAAA:400::1                                         | /64  | R24 (Gi0/3)                        |                                 |
| 52.0.56.94                     | /30 | 2000:AAAA:400::2                                         | /64  | EDGE-R31 (Gi0/0)                   |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.96                     | /30 | 2000:AAAA:401::0                                         | /64  | R26 (Gi0/3) - EDGE-R31 (Gi0/1)     | TRIADA-TO-SPB-2                 |
| 52.0.56.97                     | /30 | 2000:AAAA:401::1                                         | /64  | R26 (Gi0/3)                        |                                 |
| 52.0.56.98                     | /30 | 2000:AAAA:401::2                                         | /64  | EDGE-R31 (Gi0/1)                   |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.100                    | /30 | 2000:AAAA:402::0                                         | /64  | R26 (Gi0/0) - EDGE-R28 (Gi0/0.110) | TRIADA-TO-CHOKURDAKHR_EDGE-28-1 |
| 52.0.56.101                    | /30 | 2000:AAAA:402::1                                         | /64  | R26 (Gi0/0)                        |                                 |
| 52.0.56.102                    | /30 | 2000:AAAA:402::2                                         | /64  | EDGE-R28 (Gi0/0.110)               |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.104                    | /30 | 2000:AAAA:403::0                                         | /64  | R25 (Gi0/0) - EDGE-R28 (Gi0/0.120) | TRIADA-TO-CHOKURDAKH_EDGE-R28-2 |
| 52.0.56.105                    | /30 | 2000:AAAA:403::1                                         | /64  | R25 (Gi0/0)                        |                                 |
| 52.0.56.106                    | /30 | 2000:AAAA:403::2                                         | /64  | EDGE-R28 (Gi0/0.120)               |                                 |
| …                              | …   |                                                          |      | …                                  |                                 |
| 52.0.56.108                    | /30 | 2000:AAAA:404::0                                         | /64  | R25 (Gi0/3) - EDGE-R27 (Gi0/0)     | TRIADA-TO-LABYTNANGI_EDGE-R27   |
| 52.0.56.109                    | /30 | 2000:AAAA:404::1                                         | /64  | R25 (Gi0/3)                        |                                 |
| 52.0.56.110                    | /30 | 2000:AAAA:404::2                                         | /64  | EDGE-R27 (Gi0/0)                   |                                 |

</details>

<details>
<summary>ISP Kitorn </summary>

| ISP-KITORN                      |     |                                                          |      |                              |                           |
|---------------------------------|-----|----------------------------------------------------------|------|------------------------------|---------------------------|
| ISP-KITORN to ISP-TRIADA        |     |                                                          |      |                              |                           |
| NET Address                     | NET | NET Address                                              | NET  | Description                  | примечание                |
| 52.0.56.64                      | /30 | 2000:AAAA:1:1::0                                         | /64  | R23 (Gi0/0) - ISP1 (Gi0/0)   | KITORN_ISP1-TO-TRIADA     |
| 52.0.56.65                      | /30 | 2000:AAAA:1:1::1                                         | /64  | R23 (Gi0/0)                  |                           |
| 52.0.56.66                      | /30 | 2000:AAAA:1:1::2                                         | /64  | ISP1 (Gi0/0)                 |                           |
|                                 |     |                                                          |      |                              |                           |
| KITORN INSIDE: 100.1.1.0 /26    |     | KITORN INSIDE:  2000:AAAB:0::/48                         |      |                              |                           |
| NET Address                     | NET | NET Address                                              | NET  | Description                  | примечание                |
| 100.1.1.0                       | /29 | 2000:AAAB::0                                             | /126 | REZERVED                     |                           |
| 100.1.1.8                       | /29 | 2000:AAAB::8                                             | /126 | REZERVED                     |                           |
| 100.1.1.16                      | /29 | 2000:AAAB::10                                            | /126 | REZERVED                     |                           |
| 100.1.1.24                      | /29 | 2000:AAAB::18                                            | /126 | REZERVED                     |                           |
| ...                             |     |                                                          |      |                              |                           |
| KITORN OUTSIDE1: 100.1.1.64 /27 |     | KITORN OUTSIDE1: 2000:AAAB:1::/48                        |      |                              |                           |
| NET Address                     | NET | NET Address                                              | NET  | Description                  | примечание                |
| 100.1.1.64                      | /30 | 2000:AAAB:1:1::0                                         | /64  | ISP1 (Gi0/2) - ISP2 (Gi0/2)  | KITORN_ISP1-TO-LIMAS_ISP2 |
| 100.1.1.65                      | /30 | 2000:AAAA:1:1::1                                         | /64  | ISP1 (Gi0/2)                 |                           |
| 100.1.1.66                      | /30 | 2000:AAAA:1:1::2                                         | /64  | ISP2 (Gi0/2)                 |                           |
| ...                             |     |                                                          |      |                              |                           |
| 100.1.1.95                      | /30 |                                                          |      | REZERVED                     |                           |
|                                 |     |                                                          |      |                              |                           |
| KITORN OUTSIDE2: 100.1.1.96 /27 |     | KITORN OUTSIDE2: 2000:AAAB:400::0-2000:AAAB:АААА::0 / 64 |      |                              |                           |
| NET Address                     | NET | NET Address                                              | NET  | Description                  | примечание                |
| 100.1.1.96                      | /30 | 2000:AAAB:400::0                                         | /64  | EDGE1 (Gi0/1) - ISP1 (Gi0/1) | KITORN_ISP1-TO-EDGE1      |
| 100.1.1.97                      | /30 | 2000:AAAB:400::1                                         | /64  | ISP1 (Gi0/1)                 |                           |
| 100.1.1.98                      | /30 | 2000:AAAB:400::2                                         | /64  | EDGE1 (Gi0/1)                |                           |
| ...                             |     |                                                          |      |                              |                           |
| 100.1.1.128                     | /30 |                                                          |      | REZERVED                     |                           |

</details>

<details>
<summary>ISP Limas </summary>

| WAN LIMAS AS301 30.1.35.0 /24  |     | WAN LIMAS AS301 2000:AAAC::/32                          |     |                              |                           |
|--------------------------------|-----|---------------------------------------------------------|-----|------------------------------|---------------------------|
| ISP-LIMAS                      |     |                                                         |     |                              |                           |
| ISP-LIMAS to ISP-TRIADA        |     |                                                         |     |                              |                           |
| NET Address                    | NET |                                                         |     | Description                  | примечание                |
| 52.0.56.68                     | /30 | 2000:AAAA:1:2::0                                        | /64 | R24 (Gi0/0) - ISP2 (Gi0/0)   | LIMAS_ISP2-TO-TRIADA      |
| 52.0.56.69                     | /30 | 2000:AAAA:1:2::1                                        | /64 | R24 (Gi0/0)                  |                           |
| 52.0.56.70                     | /30 | 2000:AAAA:1:2::2                                        | /64 | ISP2 (Gi0/0)                 |                           |
|                                |     |                                                         |     |                              |                           |
| ISP-LIMAS to ISP KITORN        |     |                                                         |     |                              |                           |
| NET Address                    | NET |                                                         |     | Description                  | примечание                |
| 100.1.1.64                     | /30 | 2000:AAAB:1:1::0                                        | /64 | ISP1 (Gi0/2) - ISP2 (Gi0/2)  | KITORN_ISP1-TO-LIMAS_ISP2 |
| 100.1.1.65                     | /30 | 2000:AAAB:1:1::1                                        | /64 | ISP1 (Gi0/2)                 |                           |
| 100.1.1.66                     | /30 | 2000:AAAB:1:1::2                                        | /64 | ISP2 (Gi0/2)                 |                           |
|                                |     |                                                         |     |                              |                           |
| LIMAS INSIDE: 30.1.35.0 /26    |     | LIMAS INSIDE:  2000:AAAC:0::/48                         |     |                              |                           |
| NET Address                    | NET |                                                         |     | Description                  | примечание                |
| 30.1.35.0                      | /29 |                                                         |     | REZERVED                     |                           |
| ...                            |     |                                                         |     | REZERVED                     |                           |
| 30.1.35.56                     | /29 |                                                         |     | REZERVED                     |                           |
|                                |     |                                                         |     |                              |                           |
| LIMAS OUTSIDE1: 30.1.35.64 /27 |     | LIMAS OUTSIDE1: 2000:AAAC:1::/48                        |     |                              |                           |
| NET Address                    | NET |                                                         |     | Description                  | примечание                |
| 30.1.35.64                     | /30 |                                                         |     | REZERVED                     |                           |
| ...                            |     |                                                         |     | REZERVED                     |                           |
| 30.1.35.91                     | /30 |                                                         |     |                              |                           |
|                                |     |                                                         |     |                              |                           |
| LIMAS OUTSIDE2: 100.1.1.92 /27 |     | LIMAS OUTSIDE2: 2000:AAAC:400::0-2000:AAAC:АААА::0 / 64 |     |                              |                           |
| NET Address                    | NET |                                                         |     | Description                  | примечание                |
| 30.1.35.92                     | /30 |                                                         |     | EDGE2 (Gi0/1) - ISP2 (Gi0/1) | LIMAS_ISP2-TO-EDGE2       |
| 30.1.35.93                     | /30 |                                                         |     | ISP2 (Gi0/1)                 |                           |
| 30.1.35.94                     | /30 |                                                         |     | EDGE2 (Gi0/1)                |                           |
| ...                            |     |                                                         |     | REZERVED                     |                           |

</details>


<details>
<summary>Москва</summary>

| БЦ Москва, MOW.FZ.LOCAL, Netw 172.17.0.0 /16 |     |                                       |     |                          |
|----------------------------------------------|-----|---------------------------------------|-----|--------------------------|
| OSPF: 172.17.0-15.0/24                       |     | OSPF: 2000:AAAD:1::/48 = 256x256/56   |     |                          |
| OSPF0 172.17.0.0 /24: 31x172.17.0.0 /29      |     | OSPF0  2000:AAAD:1:100::/56 = 256 /64 |     |                          |
| NET Address                                  | NET | NET Address                           | NET | Description/Device(port) |
| 172.17.0.0                                   | /29 | 2000:AAAD:1:100::                     | /64 | EDGE1<->DSWWAN1          |
| 172.17.0.1                                   | /29 | 2000:AAAD:1:100::1                    | /64 | EDGE1(Gi0/2)             |
| 172.17.0.2                                   | /29 | 2000:AAAD:1:100::2                    | /64 | DSWWAN1(Gi0/2)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.8                                   | /29 | 2000:AAAD:1:101::                     | /64 | EDGE2<->DSWWAN2          |
| 172.17.0.9                                   | /29 | 2000:AAAD:1:101::1                    | /64 | EDGE2(Gi0/2)             |
| 172.17.0.10                                  | /29 | 2000:AAAD:1:101::2                    | /64 | DSWWAN2(Gi0/2)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.48                                  | /29 | 2000:AAAD:1:110::                     | /64 | DSWWAN1<->DSWWAN2        |
| 172.17.0.49                                  | /29 | 2000:AAAD:1:110::1                    | /64 | DSWWAN1(Po1)             |
| 172.17.0.50                                  | /29 | 2000:AAAD:1:110::2                    | /64 | DSWWAN2(Po1)             |
| ...                                          |     |                                       |     |                          |
| 172.17.0.56                                  | /29 | 2000:AAAD:1:111::                     | /64 | DSWWAN1<->CORE1          |
| 172.17.0.57                                  | /29 | 2000:AAAD:1:111::1                    | /64 | DSWWAN1(Gi2/1)           |
| 172.17.0.58                                  | /29 | 2000:AAAD:1:111::2                    | /64 | CORE1(Gi0/1)             |
| ...                                          |     |                                       |     |                          |
| 172.17.0.64                                  | /29 | 2000:AAAD:1:112::                     | /64 | DSWWAN1<->CORE2          |
| 172.17.0.65                                  | /29 | 2000:AAAD:1:112::1                    | /64 | DSWWAN1(Gi2/0)           |
| 172.17.0.66                                  | /29 | 2000:AAAD:1:112::2                    | /64 | CORE2(Gi0/0)             |
| ...                                          |     |                                       |     |                          |
| 172.17.0.72                                  | /29 | 2000:AAAD:1:113::                     | /64 | DSWWAN2<->CORE1          |
| 172.17.0.73                                  | /29 | 2000:AAAD:1:113::1                    | /64 | DSWWAN2(Gi2/0)           |
| 172.17.0.74                                  | /29 | 2000:AAAD:1:113::2                    | /64 | CORE1(Gi0/0)             |
| ...                                          |     |                                       |     |                          |
| 172.17.0.80                                  | /29 | 2000:AAAD:1:114::                     | /64 | DSWWAN2<->CORE2          |
| 172.17.0.81                                  | /29 | 2000:AAAD:1:114::1                    | /64 | DSWWAN2(Gi2/1)           |
| 172.17.0.82                                  | /29 | 2000:AAAD:1:114::2                    | /64 | CORE2(Gi0/1)             |
| ...                                          |     |                                       |     |                          |
| 172.17.0.88                                  | /29 | 2000:AAAD:1:115::                     | /64 | CORE1<->CORE2            |
| 172.17.0.89                                  | /29 | 2000:AAAD:1:115::1                    | /64 | CORE1(Po1)               |
| 172.17.0.90                                  | /29 | 2000:AAAD:1:115::2                    | /64 | CORE2(Po1)               |
| ...                                          |     |                                       |     |                          |
| 172.17.0.96                                  | /29 | 2000:AAAD:1:116::                     | /64 | CORE1<->DSWACC1          |
| 172.17.0.97                                  | /29 | 2000:AAAD:1:116::1                    | /64 | CORE1(Gi2/0)             |
| 172.17.0.98                                  | /29 | 2000:AAAD:1:116::2                    | /64 | DSWACC1(Gi0/0)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.104                                 | /29 | 2000:AAAD:1:117::                     | /64 | CORE1<->DSWACC2          |
| 172.17.0.105                                 | /29 | 2000:AAAD:1:117::1                    | /64 | CORE1(Gi2/1)             |
| 172.17.0.106                                 | /29 | 2000:AAAD:1:117::2                    | /64 | DSWACC2(Gi0/1)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.112                                 | /29 | 2000:AAAD:1:118::                     | /64 | CORE2<->DSWACC1          |
| 172.17.0.113                                 | /29 | 2000:AAAD:1:118::1                    | /64 | CORE2(Gi2/1)             |
| 172.17.0.114                                 | /29 | 2000:AAAD:1:118::2                    | /64 | DSWACC1(Gi0/1)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.120                                 | /29 | 2000:AAAD:1:119::                     | /64 | CORE2<->DSWACC2          |
| 172.17.0.121                                 | /29 | 2000:AAAD:1:119::1                    | /64 | CORE2(Gi2/0)             |
| 172.17.0.122                                 | /29 | 2000:AAAD:1:119::2                    | /64 | DSWACC2(Gi0/0)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.136                                 | /29 | 2000:AAAD:1:120::                     | /64 | DSWACC1<->DSWACC2        |
| 172.17.0.137                                 | /29 | 2000:AAAD:1:120::1                    | /64 | DSWACC1(Po1)             |
| 172.17.0.138                                 | /29 | 2000:AAAD:1:120::2                    | /64 | DSWACC2(Po1)             |
| ...                                          |     |                                       |     |                          |
| 172.17.0.144                                 | /29 | 2000:AAAD:1:121::                     | /64 | CORE1<->AGGRSWDC1        |
| 172.17.0.145                                 | /29 | 2000:AAAD:1:121::1                    | /64 | CORE1(Gi2/2)             |
| 172.17.0.146                                 | /29 | 2000:AAAD:1:121::2                    | /64 | AGGRSWDC1(Gi0/0)         |
| ...                                          |     |                                       |     |                          |
| 172.17.0.152                                 | /29 | 2000:AAAD:1:122::                     | /64 | CORE1<->AGGRSWDC2        |
| 172.17.0.153                                 | /29 | 2000:AAAD:1:122::1                    | /64 | CORE1(Gi2/3)             |
| 172.17.0.154                                 | /29 | 2000:AAAD:1:122::2                    | /64 | AGGRSWDC2(Gi0/0)         |
| ...                                          |     |                                       |     |                          |
| 172.17.0.160                                 | /29 | 2000:AAAD:1:123::                     | /64 | CORE2<->AGGRSWDC1        |
| 172.17.0.161                                 | /29 | 2000:AAAD:1:123::1                    | /64 | CORE2(Gi2/2)             |
| 172.17.0.162                                 | /29 | 2000:AAAD:1:123::2                    | /64 | AGGRSWDC1(Gi0/1)         |
| ...                                          |     |                                       |     |                          |
| 172.17.0.168                                 | /29 | 2000:AAAD:1:124::                     | /64 | CORE2<->AGGRSWDC2        |
| 172.17.0.169                                 | /29 | 2000:AAAD:1:124::1                    | /64 | CORE2(Gi2/3)             |
| 172.17.0.170                                 | /29 | 2000:AAAD:1:124::2                    | /64 | AGGRSWDC2(Gi0/1)         |
| ...                                          |     |                                       |     |                          |
| 172.17.0.176                                 | /29 | 2000:AAAD:1:125::                     | /64 | AGGRSWDC1<->AGGRSWDC2    |
| 172.17.0.177                                 | /29 | 2000:AAAD:1:125::1                    | /64 | AGGRSWDC1(Po1)           |
| 172.17.0.178                                 | /29 | 2000:AAAD:1:125::2                    | /64 | AGGRSWDC2(Po1)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.192                                 | /29 | 2000:AAAD:1:130::                     | /64 | MOWOSPF1<->DSWWAN1       |
| 172.17.0.193                                 | /29 | 2000:AAAD:1:130::1                    | /64 | MOWOSPF1(Gi0/1)          |
| 172.17.0.194                                 | /29 | 2000:AAAD:1:130::2                    | /64 | DSWWAN1(Gi0/3)           |
| ...                                          |     |                                       |     |                          |
| 172.17.0.200                                 | /29 | 2000:AAAD:1:131::                     | /64 | MOWOSPF1<->DSWWAN2       |
| 172.17.0.201                                 | /29 | 2000:AAAD:1:131::1                    | /64 | MOWOSPF1(Gi0/0)          |
| 172.17.0.202                                 | /29 | 2000:AAAD:1:131::2                    | /64 | DSWWAN2(Gi0/3)           |
| ...                                          |     |                                       |     |                          |
|                                              |     |                                       |     |                          |
| OSPF1 172.17.1.0 /24: 31x172.17.1.0 /29      |     | OSPF1 2000:AAAD:1:200::/56 = 256 /64  |     |                          |
| NET Address                                  | NET | NET Address                           | NET | Description/Device(port) |
| 172.17.1.0                                   | /29 | 2000:AAAD:1:200::                     | /64 | MOWOSPF1<->Lo0           |
| 172.17.1.1                                   | /29 | 2000:AAAD:1:200::1                    | /64 | MOWOSPF1(Lo0)            |
| ...                                          |     |                                       |     |                          |
| OSPF2 172.17.2.0 /24: 31x172.17.2.0 /29      |     | OSPF2 2000:AAAD:1:300::/56 = 256 /64  |     |                          |
| NET Address                                  | NET | NET Address                           | NET | Description/Device(port) |
| 172.17.2.0                                   | /29 | 2000:AAAD:1:300::                     | /64 | AGGRSWDC1<->DCSW1        |
| 172.17.2.1                                   | /29 | 2000:AAAD:1:300::1                    | /64 | AGGRSWDC1(Gi2/0)         |
| 172.17.2.2                                   | /29 | 2000:AAAD:1:300::2                    | /64 | DCSW1(Gi0/0)             |
| ...                                          |     |                                       |     |                          |
| 172.17.2.8                                   | /29 | 2000:AAAD:1:301::                     | /64 | AGGRSWDC1<->DCSW2        |
| 172.17.2.9                                   | /29 | 2000:AAAD:1:301::1                    | /64 | AGGRSWDC1(Gi2/1)         |
| 172.17.2.10                                  | /29 | 2000:AAAD:1:301::2                    | /64 | DCSW2(Gi0/0)             |
| ...                                          |     |                                       |     |                          |
| 172.17.2.16                                  | /29 | 2000:AAAD:1:302::                     | /64 | AGGRSWDC2<->DCSW1        |
| 172.17.2.17                                  | /29 | 2000:AAAD:1:302::1                    | /64 | AGGRSWDC2(Gi2/0)         |
| 172.17.2.18                                  | /29 | 2000:AAAD:1:302::2                    | /64 | DCSW1(Gi0/1)             |
| ...                                          |     |                                       |     |                          |
| 172.17.2.24                                  | /29 | 2000:AAAD:1:303::                     | /64 | AGGRSWDC2<->DCSW2        |
| 172.17.2.25                                  | /29 | 2000:AAAD:1:303::1                    | /64 | AGGRSWDC2(Gi2/1)         |
| 172.17.2.26                                  | /29 | 2000:AAAD:1:303::2                    | /64 | DCSW2(Gi0/1)             |
| ...                                          |     |                                       |     |                          |
| OSPF3 172.17.3.0 /24: 31x172.17.3.0 /29      |     | OSPF3 2000:AAAD:1:400::/56 = 256 /64  |     |                          |
| NET Address                                  | NET | NET Address                           | NET | Description/Device(port) |
| 172.17.3.0                                   | /29 | 2000:AAAD:1:400::                     | /64 | DSWACC1<->ASW1           |
| 172.17.3.1                                   | /29 | 2000:AAAD:1:400::1                    | /64 | DSWACC1(Gi2/0)           |
| 172.17.3.2                                   | /29 | 2000:AAAD:1:400::2                    | /64 | ASW1(Gi0/0)              |
| ...                                          |     |                                       |     |                          |
| 172.17.3.8                                   | /29 | 2000:AAAD:1:401::                     | /64 | DSWACC1<->ASW2           |
| 172.17.3.9                                   | /29 | 2000:AAAD:1:401::1                    | /64 | DSWACC1(Gi2/1)           |
| 172.17.3.10                                  | /29 | 2000:AAAD:1:401::2                    | /64 | ASW2(Gi0/0)              |
| ...                                          |     |                                       |     |                          |
| 172.17.3.16                                  | /29 | 2000:AAAD:1:402::                     | /64 | DSWACC2<->ASW1           |
| 172.17.3.17                                  | /29 | 2000:AAAD:1:402::1                    | /64 | DSWACC2(Gi2/0)           |
| 172.17.3.18                                  | /29 | 2000:AAAD:1:402::2                    | /64 | ASW1(Gi0/1)              |
| ...                                          |     |                                       |     |                          |
| 172.17.3.24                                  | /29 | 2000:AAAD:1:403::                     | /64 | DSWACC2<->ASW2           |
| 172.17.3.25                                  | /29 | 2000:AAAD:1:403::1                    | /64 | DSWACC2(Gi2/1)           |
| 172.17.3.26                                  | /29 | 2000:AAAD:1:403::2                    | /64 | ASW2(Gi0/1)              |
| ...                                          |     |                                       |     |                          |
| SERVER 172.17.16-31.0 /24                    |     | SERVER 2000:AAAD:1:500::/56 = 256 /64 |     |                          |
| NET Address                                  | NET | NET Address                           | NET | Description/Device(port) |
| 172.17.16.0                                  | /24 | 2000:AAAD:1:500::                     | /64 | SRV_NET1                 |
| 172.17.16.1                                  | /24 | 2000:AAAD:1:500::1                    | /64 | DHCP1 (Gi0/0)            |
| 172.17.16.2                                  | /24 | 2000:AAAD:1:500::2                    | /64 |                          |
| 172.17.16.3                                  | /24 |                                       |     |                          |
| 172.17.16.4                                  | /24 |                                       |     |                          |
| …                                            | …   |                                       |     |                          |
| 172.17.16.254                                | /24 | 2000:AAAD:1:500::1ffff:ffff:ffff:ffff | /64 | GW                       |
| 172.17.17.0                                  | /24 | 2000:AAAD:1:501::                     | /64 | SRV_NET2                 |
| 172.17.17.1                                  | /24 | 2000:AAAD:1:501::1                    | /64 | DHCP1 (Gi0/1)            |
| 172.17.17.2                                  | /24 | 2000:AAAD:1:501::2                    | /64 |                          |
| 172.17.17.3                                  | /24 |                                       |     |                          |
| 172.17.17.4                                  | /24 |                                       |     |                          |
| …                                            | …   |                                       |     |                          |
| 172.17.17.254                                | /24 | 2000:AAAD:1:501::1ffff:ffff:ffff:ffff | /64 | GW                       |
</details>

<details>
<summary>СПб</summary>

| БЦ СПб, SPb.FZ.LOCAL, Net 172.18.0.0 /16 255.255.0.0 |     |                                      |     |                              |
|------------------------------------------------------|-----|--------------------------------------|-----|------------------------------|
| EIGRP 172.18.0.0 /20                                 |     | EIGRP 2000:AAAD:2::/48 = 256x256/56  |     |                              |
| AS100 172.18.0.0 /28: 31x172.18.0.0 /29              |     | AS100 2000:AAAD:2:100::/56 = 256 /64 |     |                              |
| NET Address                                          | NET | NET Address                          | NET | Description/Device(port)     |
| 172.18.0.0                                           | /29 | 2000:AAAD:2:100::                    | /64 | EDGE-R31<->DSWCOLCORE17      |
| 172.18.0.1                                           | /29 | 2000:AAAD:2:100::1                   | /64 | EDGE-R31(Gi0/1)              |
| 172.18.0.2                                           | /29 | 2000:AAAD:2:100::2                   | /64 | DSWCOLCORE17(Gi0/2)          |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.8                                           | /29 | 2000:AAAD:2:101::                    | /64 | EDGE-R31<->DSWCOLCORE16      |
| 172.18.0.9                                           | /29 | 2000:AAAD:2:101::1                   | /64 | EDGE-R31(Gi0/2)              |
| 172.18.0.10                                          | /29 | 2000:AAAD:2:101::2                   | /64 | DSWCOLCORE16(Gi0/2)          |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.16                                          | /29 | 2000:AAAD:2:102::                    | /64 | EDGEEIGRP-R32<->DSWCOLCORE17 |
| 172.18.0.17                                          | /29 | 2000:AAAD:2:102::1                   | /64 | EDGEEIGRP-R32(Gi0/0)         |
| 172.18.0.18                                          | /29 | 2000:AAAD:2:102::2                   | /64 | DSWCOLCORE17(Gi0/3)          |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.24                                          | /29 | 2000:AAAD:2:103::                    | /64 | EDGEEIGRP-R32<->DSWCOLCORE16 |
| 172.18.0.25                                          | /29 | 2000:AAAD:2:103::1                   | /64 | EDGEEIGRP-R32(Gi1/0)         |
| 172.18.0.26                                          | /29 | 2000:AAAD:2:103::2                   | /64 | DSWCOLCORE16(Gi0/3)          |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.48                                          | /29 | 2000:AAAD:2:106::                    | /64 | DSWCOLCORE17<->DSWCOLCORE16  |
| 172.18.0.49                                          | /29 | 2000:AAAD:2:106::1                   | /64 | DSWCOLCORE17(Po1)            |
| 172.18.0.50                                          | /29 | 2000:AAAD:2:106::2                   | /64 | DSWCOLCORE16(Po1)            |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.56                                          | /29 | 2000:AAAD:2:107::                    | /64 | DSWCOLCORE17<->ASW3          |
| 172.18.0.57                                          | /29 | 2000:AAAD:2:107::1                   | /64 | DSWCOLCORE17(Gi2/0)          |
| 172.18.0.58                                          | /29 | 2000:AAAD:2:107::2                   | /64 | ASW3(Gi0/0)                  |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.64                                          | /29 | 2000:AAAD:2:108::                    | /64 | DSWCOLCORE17<->ASW4          |
| 172.18.0.65                                          | /29 | 2000:AAAD:2:108::1                   | /64 | DSWCOLCORE17(Gi2/1)          |
| 172.18.0.66                                          | /29 | 2000:AAAD:2:108::2                   | /64 | ASW4(Gi0/0)                  |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.72                                          | /29 | 2000:AAAD:2:109::                    | /64 | DSWCOLCORE16<->ASW3          |
| 172.18.0.73                                          | /29 | 2000:AAAD:2:109::1                   | /64 | DSWCOLCORE16(Gi2/0)          |
| 172.18.0.74                                          | /29 | 2000:AAAD:2:109::2                   | /64 | ASW3(Gi0/1)                  |
| ...                                                  |     |                                      |     |                              |
| 172.18.0.80                                          | /29 | 2000:AAAD:2:10a::                    | /64 | DSWCOLCORE16<->ASW4          |
| 172.18.0.81                                          | /29 | 2000:AAAD:2:10a::1                   | /64 | DSWCOLCORE16(Gi2/1)          |
| 172.18.0.82                                          | /29 | 2000:AAAD:2:10a::2                   | /64 | ASW4(Gi0/1)                  |
| ...                                                  |     |                                      |     |                              |
| AS101 172.18.1.0 /28: 31x172.18.1.0 /29              |     | AS101 2000:AAAD:2:200::/56 = 256 /64 |     |                              |
| 172.18.1.0                                           | /29 | 2000:AAAD:2:201::                    | /64 | EDGEEIGRP-R32<->Lo0          |
| 172.18.1.1                                           | /29 | 2000:AAAD:2:201::1                   | /64 | EDGEEIGRP-R32(Lo0)           |

</details>

<details>
<summary>Чокурдах </summary>

| БЦ Чокурдах, Cho.FZ.LOCAL, Net 172.19.0.0 /16 255.255.0.0 |     |БЦ Чокурдах, Cho.FZ.LOCAL, Net  2000:AAAD:3::/32 |     |                          |
|-----------------------------------------------------------|-----|--------------------------------------|-----|--------------------------|
| NET Address                                               | NET | NET Address                          | NET | Description              |
| LAN 172.19.0.0 /16: 31x172.19.0.0 /29                     |     | LAN 2000:AAAD:3::/48 = 256x256/56    |     |                          |
| LAN0 172.19.0.0 /24: 31x172.19.0.0 /29                    |     | LAN0: 2000:AAAD:3:100::/56 = 256 /64 |     |                          |
| NET Address                                               | NET |                                      |     | Description/Device(port) |
| 172.19.0.0                                                | /29 | 2000:AAAD:3:100::                    | /64 | EDGE-R28<->ASW29         |
| 172.19.0.1                                                | /29 | 2000:AAAD:3:100::1                   | /64 | DSWEDGE-R28(SubIF.10)    |
| 172.19.0.2                                                | /29 | 2000:AAAD:3:100::2                   | /64 | ASW29(SVI10)             |

</details>

<details>
<summary>БЦ Лабытнанги </summary>

| БЦ Лабытнанги, Lab.FZ.LOCAL, Net 172.20.0.0 /16 255.255.0.0 |     | БЦ Лабытнанги, Lab.FZ.LOCAL, Net  2000:AAAD:4::/32 |     |                          |
|-------------------------------------------------------------|-----|----------------------------------------------------|-----|--------------------------|
| NET Address                                                 | NET |                                                    |     | Description              |
| LAN0 172.20.0.0 /24: 31x172.20.0.0 /29                      |     | БЦ Лабытнанги, Lab.FZ.LOCAL, Net  2000:AAAD:4::/32 |     |                          |
| NET Address                                                 | NET |                                                    |     | Description/Device(port) |
| 172.20.0.0                                                  | /29 | 2000:AAAD:4:101::                                  | /64 | VLAN10                   |
| 172.20.0.1                                                  | /29 | 2000:AAAD:4:101::1                                 | /64 | Edge-R27(Gi0/1)          |
| 172.20.0.2                                                  | /29 | 2000:AAAD:4:101::2                                 | /64 | PC11                     |
| 172.20.0.8                                                  | /29 | 2000:AAAD:4:102::                                  | /64 | VLAN 20                  |
| 172.20.0.9                                                  | /29 | 2000:AAAD:4:102::1                                 | /64 | Edge-R27(Gi0/2)          |
| 172.20.0.10                                                 | /29 | 2000:AAAD:4:102::2                                 | /64 | PRN1                     |


</details>



##  Задание 3: настроить VLAN управления для сетевых устройств
##  Задание 4: настроить сети офисов так, чтобы не возникало broadcast штормов, а использование линков было максимально оптимизировано


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
