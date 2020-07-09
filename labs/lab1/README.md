Lab - Configure Router-on-a-Stick Inter-VLAN Routing

Задание:
    Настроить Router-on-a-Stick Inter-VLAN Routing;
    На маршрутизаторе R1 необходимо настроить SubIF's 3, 4 с инкапсуляцией Dot1Q, для обработки трафика с VLAN3, 4 - соответственно;
    На коммутаторах S1, S2 настроить management VLAN 3 для обучпечения доступа к оборудованию не по дефолтному VLAN
    На коммутаторах S1, S2 настроить VLAN's 3, 4, 7, 8 для обеспечения работоспособности соответствующих access и trunk-портов;
    Обеспечить синхронизацию времени на оборудовании
    Разобраться в технологии ROS, IVR
    Разобраться в базовых элементах защиты коммутаторов от НСД и атаки native-vlan, путем задания конкретных разрешенных VLAN и переопределения NATIVE VLAN на trunk-портах
    
Решение:
    1. Базовая настройка оборудования
        - banner, secret, no ip domain lookup, hostname
        - line con 0
        - line vty 0 4
        - включени ешифрования паролей в конфигах
        - timezone, clock set 
        ПРОВЕРКА: "show run"
    2. Настройка всех портов Switch1,2 командой range
        - отключение автосогласование на портах
        - перевод портов в access
        - выключение всех портов командой shut 
        ПРОВЕРКА: "show ip int br", "show run | in interfa|switch"
    3. Специфичная настройка Switches:
        - Создание базы VLAN
        - Настройка MGM vlan3, 
        - Настройка trunk портов на свичах с указанием разрешенных VLAN и переопределением native
        - Переопределение конкретных access портов на свичах в соответствующие VLAN
        ПРОВЕРКА: "show vlan", "show int trunk"
    5. Специфичная настройка Router:
        - Создание SubIF, назначение соответствующих тэгов и ip-адресов
        ПРОВЕРКА: "show ip int br", "show ip route", "do ping 192.168.3.11 / 12"
    6. Назначение ip адресов рабочим станциям    
    7. проверка работоспособности
        ПРОВЕРКА: "ping 192.168.3.1", "ping 192.168.3.3", "ping 192.168.4.3"
Графическая схема:
https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/LAB1.jpg
Фйлы с конфигурациями оборудования:
R1: https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/R1
S1: https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/S1
S2: https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/S2

Выводы:
Задание выполнено. Достигнута ip-связность узлов сети как внутри vlan, так и между VLAN-ами
Дополнительно рекомендуется проработка методов фильтрации трафика, чтобы сотрудники VLAN 4 не могли иметь доступ к VLAN3 (management VLAN)
        
    
