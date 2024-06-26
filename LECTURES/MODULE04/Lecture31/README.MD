# OTUS 20210615
# Безопасность, ААА

![](pictures/01.jpg)

## Authentication ##

- Односторонняя - проверяет одна сторона (проверка сертификата сайта), сам сайт нас не проверяет
- Двухсторонняя - проверяют обе стороны (клиент проверяет сервер, сервер - проверяет клиента по логину/паролю или сертификату)

Элементы системы аутентификации (1-е 4 термина)
- Субъект - кто проходит
- характеристика субъекта - их отличительная черта
- хозяин системы аутентификаии - кто несет ответственность и контроллирует работу
- механизм аутентификации - принцип работы системы
- механизм управления доступом, предоставляет какие-то права  субъекту в системе

В переводе на образы:

![](pictures/02.jpg)

Используемые системы АУ
![](pictures/03.jpg)

- Электронные
- Биометрические
   - Статич - отпечатки, роговица
   - динамич - походка, голос
- Комбинированые (смесь предыдущих видов)
- Разовые пароли

![](pictures/04.jpg)

- PAP (логин+пасс)

Для устройств можно использовать вторую часть

Идентификация - процесс сопоставления некоего набора информации (факторов аутентификации) с зарегистрирванными в системе идентификаторами. Аутентификация - процесс подтверждения

![](pictures/05.jpg)

## Авторизация ##

Назначение прав доступа к ресурсам или системам, настройка вплоть до разрешений на выполнение каждой команды

![](pictures/06.jpg)

DAC

![](pictures/07.jpg)

MAC

![](pictures/08.jpg)

RBAC

![](pictures/09.jpg)

## Accounting ##

Помогает отслеживать действие пользователя

![](pictures/10.jpg)

![](pictures/11.jpg)

Без AAA
![](pictures/12.jpg)
речь про Line, не забываем пароль на enable
   - vty -> login local
   - console -> login local

```
configure terminal
no ip domain lookup
hostname <Name>
enable secret <class>
line con 0
password <cisco>
exit
line vty 0 15
password <cisco>
login
exit
```
или так:
![](pictures/15.jpg)


С ААА ```aaa new-model```

aaa - очень гибкая структура, на основании списков, на каждую линию - свой список аутентификаций 
- локальная база
- RADIUS сервер

![](pictures/13.jpg)

![](pictures/14.jpg)

![](pictures/16.jpg)

![](pictures/17.jpg)

методы
- Local - локальная БД, через Username
- Local-case, чувствительный к регистру при вводе логина Локальная БД
- Enable - ввод пароля при входе в #
- Line - ввод пароля при входе в линию и пользовательский режим
- None - аутентификации не требуется
- Group - использование сервисов AAA
   - TACACS
   - RADIUS

![](pictures/18.jpg)

Если RADIUS сервер доступен, то в Local мы не попадем

![](pictures/19.jpg)

строчка ```key X YYY``` - каждый раз происходит отправка этой строчки при аутентификации железки на RADUIS (можно настроить для группы, индивидуально для железки и т.п.). RADIUS обмен идет в открытом или частично зашифрованном виде

Включение Авторизации:
![](pictures/20.jpg)


Дальше - только при использовании TACACS+
![](pictures/21.jpg)

Accounting - вся информация по входу, вводимым командам, перезагрузкам, системная информация о железке. Еще раз: работает только с TACACS+ (платный)
![](pictures/22.jpg)

![](pictures/23.jpg)

Типы логирования: их всего 3. Сервис - IPSEC, BGP, OSPF, STP и любой другой протокол
![](pictures/24.jpg)

![](pictures/25.jpg)

Рекомендации
![](pictures/26.jpg)

Примеры настроек
![](pictures/27.jpg)

Неудачные входы можно также логгировать 
![](pictures/28.jpg)

Если нет TACACS+
- нарезать пользователей с определенным уровнем привилегий
- задать уровень привилегий

![](pictures/29.jpg)

Пример
 
![](pictures/30.jpg)