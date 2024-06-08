# PBR - маршрутизация - OTUS 20210406

![](GIT/Myotus-networks/LECTURES/MODULE02/Lecture11/pictures/01.jpg)

В некоторых случаях маршрутизация надо строить не дефолтным способом, а каким-то другим
- Для неоптимальных маршрутов
- для резервирования (нескольких ISP)
- Оптимизация пути трафика приложений
- Распределение нагрузки (балансировка)

![](GIT/Myotus-networks/LECTURES/MODULE02/Lecture11/pictures/02.jpg)

PBR - позволяет повлиять на работу перекладывания пакетов, вне зависимости от таблицы маршрутов

![](GIT/Myotus-networks/LECTURES/MODULE02/Lecture11/pictures/04.jpg)

![](GIT/Myotus-networks/LECTURES/MODULE02/Lecture11/pictures/03.jpg)

![](pictures/05.jpg)

## Route-map

![](pictures/06.jpg)

Особенности Route-map
- Это список инструкция, как и ACL
- также обрабатывается, как ACL 
   - прерывается после попадания
   - разделяется на пункты (clause) с порядковым номером
   - последний пункт - неявный запрещающий
   - route-map может использровать ACL

![](pictures/07.jpg)

___Настройка___

![](pictures/08.jpg)
![](pictures/09.jpg)

4-е правило - обязательно, без него в этот route-map попадет только ACL-ONE, ACL-THREE

![](pictures/10.jpg)

![](pictures/11.jpg)

Также матчим по следующим параметрам:

![](pictures/12.jpg)

![](pictures/13.jpg)



![](pictures/14.jpg)

continue - продолжение, переход к следующему шагу

![](pictures/15.jpg)

![](pictures/16.jpg)

что делаем с IP SLA:

![](pictures/17.jpg)

![](pictures/18.jpg)

![](pictures/19.jpg)

Пример:

![](pictures/20.jpg)

![](pictures/21.jpg)

Проверка:

![](pictures/22.jpg)

Информацию из диагностики сети можно использовать для:
- подмены маршрута в таблице маршрутизации

Пример на VIRL/CML2

![](pictures/23.jpg)

![](pictures/24.jpg)

https://github.com/fazzzan/DarkMycal/tree/master/Part1/L19_3

![](pictures/25.jpg)

Route -map для матчинга telnet трафика
```
ip access-li extended TELNET
permit tc 10.10.20.0 0.0.0.255 host 8.8.8.8 eq 23

route-map TELNET
   match ip add TELNET
      set ip next-hop 192.168.20.2
exit

int gi0/2.20
ip policy route-map TELNET
exit

```

## Лабораторка
Настройка PBR для сегмента