# Разбиение адресного пространства #

Итак, изначально схема была в EVE-NG:

![](/LECTURES/MODULE02/Lecture10/pictures/16.jpg)

Но я решил ее переделать под GNS3: cхему буду постепенно обновлять

![](/LECTURES/MODULE02/Lecture10/pictures/17.jpg)

все оформление веду в DRAW.IO - очень удобно, название оборудования соответствует настройкам представленным ниже

![](/LECTURES/MODULE02/Lecture10/pictures/31.jpg)

##  Задание:
1. Разбиение адресного пространства

###  Решение:
Всего перед нами 4 сегмента большой распределенной сети предприятия:
1. ЦО/ЦОД - Москва
2. Бранчи СПб
3. Бранч Чокурдах
4. Бранч Лабытнанги

Исходя из количества оборудования и предполагая запас на рост предприятия, выбираем сеть класса B 172.16.0.0 /12. Данную подсеть легко разбить на нужные сегменты:

![](/LECTURES/MODULE02/Lecture10/pictures/32.jpg)


| Офис  | Диапазон подсетей  | 
|---|---|
| ЦО/ЦОД - Москва  | 172.17.0.0/16 - 172.17.255.255/16  |
| Бранч СПб  | 172.18.0.0/16 - 172.18.255.255/16 |
| Бранч Чокурдах  | 172.19.0.0/16 - 172.19.255.255/16 | 
| Бранч Лабытнанги  | 172.20.0.0/16 - 172.20.255.255/16 |

Каждую из выделенных подсетей также легко разбить на нужные сегменты, при этом будут соблюдены принципы последующей суммаризации сегментов, отвечающих за тот или иной участок: например, серверный сегмент или сегменты принтеров и т.д.

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
