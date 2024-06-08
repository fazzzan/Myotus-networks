посмотреть: https://blog.dtulyakov.ru/2015/06/url-cisco-ios.html

![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture32/pictures/01.jpg)
![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture32/pictures/02.jpg)

Второй вариант настройки, с разнесением ACL по IF - экономнее для ресурсов RR
![](GIT/Myotus-networks/LECTURES/MODULE04/Lecture32/pictures/04.jpg)

## CBAC ##
Промежуточная техника между ACL и ZBPF

![](pictures/05.jpg)

ZBPF взял многое из CBAC

![](pictures/06.jpg)

- Создание списка инспекции на ряд протоколов
- Создаем ACL для блокирования OUT направления
- Вешаем инспекцию в направлении OUT (можно и IN) и Access-group  на OUTSIDE IF

![](pictures/07.jpg)

## ZBPF ##
![](pictures/08.jpg)

сделан чтобы убрать внешние ACL у CBAC.

![](pictures/09.jpg)


Создается таблица DMZ и таблица с LAN и связывает эти зоны между собой.

Класс трафика, с которыми работает ZBPF

![](pictures/10.jpg)

ZBPF поддерживает инспекцию приложений

Пример

![](pictures/11.jpg)

![](pictures/12.jpg)

Внимание, с зоной SELF - нужно быть очень внимательным, туда попадают все IF. Свой IF исключаем из self в последнюю очередь.

___Создаем зоны___

![](pictures/13.jpg)

В данном конфиге мы сразу потеряем железку, так как если MGM loo в SELF, то взаимодействие между зонами не настроено


___Создаем паря зон___

![](pictures/14.jpg)

___Создаем определения трафика (class-map)___ 
- ACL
- class-map связываем с ACL

![](pictures/15.jpg)

Вместо ACL можно задать конкретные протоколы
![](pictures/16.jpg)

___Cоздаем policy-map - действие над трафиком___

![](pictures/17.jpg)

class-defailt надо дропать с логом

inspect и pass - разные вещи.

___Вешаем POLICY на пару зон___

![](pictures/18.jpg)


___Вешаем зоны на IF___

ПРОВЕРКА:

![](pictures/19.jpg)
