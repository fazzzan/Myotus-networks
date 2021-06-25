# OTUS 20210625

# DMVPN #

![](pictures/01.jpg)

![](pictures/02.jpg)

Фаза 3 - улучшена суммаризация маршрутов.

Каждый протокол маршрутизации имеет особенности  при работе в Фазе 2
- EIGRP
- OSPF
- BGP

проверка работы DMVPN

``` sh dmvpn```

Особенности работы EIGRP 

![](pictures/04.jpg)
![](pictures/05.jpg)

Обязательно отключаем split-horizon 

![](pictures/06.jpg)

все пакеты через HUB. Картинка ниже - иллюстрация особенности EIGRP - он заменяет SRC через ```next-hop self``` и это поведение надо отключить

![](pictures/07.jpg)

![](pictures/08.jpg)

![](pictures/09.jpg)

![](pictures/10.jpg)

![](pictures/11.jpg)

Особенности работы OSPF

Надо разбить на AREA
- AREA 0 - в нее все туннели
- Подсети споуков - в AREA 

Включаем OSPF на всех RRR
![](pictures/13.jpg)

И по-умолчанию получаем ошибку. Это происходит потому что Tunnel - канал p-t-p и он офигивает от того, что у него постоянно меняется сосед. Надо поменять тип туннеля на HUB и spoke. Рекомендуется через Broadcast
![](pictures/14.jpg)

![](pictures/15.jpg)

И опять все через HUB, потому чот задавали p-t-multipoint

![](pictures/16.jpg)

![](pictures/17.jpg)

Также на HQ надо настроить DR

![](pictures/18.jpg)

Пример с BGP

Для iBGP  Все пиры -  в одну зону
![](pictures/20.jpg)

Для eBGP лучше так
![](pictures/19.jpg)
![](pictures/21.jpg)

## Phase 3 ##

Фаза 3 учитывает:

![](pictures/22.jpg)

Как и ранее, на фазе 2, - пакет Resolution Request от филиал 10 сначала заглядывает в филиал HQ и только потом перенаправляется в 224. (изначально в таблице маршрутизации только 0.0.0.0 0.0.0.0 HQ)

![](pictures/23.jpg)

NHRP Resolution Request дойдет доHQ и будет перенаправлен в филиал
![](pictures/25.jpg)

Филиал уже ответит NHRP Response. В конце концов туннель построится. И таблица маршрутизации наполнится соседями.

![](pictures/24.jpg)

![](pictures/26.jpg)

Дополняется фаза 2
![](pictures/27.jpg)

Итого

![](pictures/28.jpg)

![](pictures/29.jpg)

преимущество фазы 3 - суммирование маршрутов

![](pictures/30.jpg)


EIGRP

Рекомендуется для маленьких сетей
![](pictures/31.jpg)


OSPF

не очень рекомендуется к использованию, LS-протокол, все должны знать всех

![](pictures/32.jpg)

BGP

Можно сделать через peer-группы

![](pictures/33.jpg)

![](pictures/34.jpg)

Варианты дизайна

![](pictures/35.jpg)

![](pictures/36.jpg)

![](pictures/37.jpg)

![](pictures/38.jpg)

![](pictures/39.jpg)

DMVPN - legacy, но много кто ее использует. Cisco доработала, сделала iWAN, еще развитие = SDWAN.