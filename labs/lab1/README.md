Lab - Configure Router-on-a-Stick Inter-VLAN Routing

<div class="preview__inner-2" style="padding: 10px 25px 343px;"><div class="cl-preview-section"><p><strong>Lab - Configure Router-on-a-Stick Inter-VLAN Routing</strong></p>
</div><div class="cl-preview-section"><p><strong>Задание:</strong></p>
</div><div class="cl-preview-section"><ol>
<li>Настроить Router-on-a-Stick Inter-VLAN Routing;</li>
<li>На маршрутизаторе R1 необходимо настроить SubIF’s 3, 4 с инкапсуляцией Dot1Q, для обработки трафика с VLAN3, 4 - соответственно;</li>
<li>На коммутаторах S1, S2 настроить management VLAN 3 для обучпечения доступа к оборудованию не по дефолтному VLAN</li>
<li>На коммутаторах S1, S2 настроить VLAN’s 3, 4, 7, 8 для обеспечения работоспособности соответствующих access и trunk-портов;</li>
<li>Обеспечить синхронизацию времени на оборудовании</li>
<li>Разобраться в технологии ROS, IVR</li>
<li>Разобраться в базовых элементах защиты коммутаторов от НСД и атаки native-vlan, путем задания конкретных разрешенных VLAN и переопределения NATIVE VLAN на trunk-портах</li>
</ol>
</div><div class="cl-preview-section"><p><strong>Решение:</strong><br>
<em>1. Базовая настройка оборудования</em><br>
- banner, secret, no ip domain lookup, hostname<br>
- line con 0<br>
- line vty 0 4<br>
- включени ешифрования паролей в конфигах<br>
- timezone, clock set<br>
ПРОВЕРКА: “show run”<br>
<em>2. Настройка всех портов Switch1,2 командой range</em><br>
- отключение автосогласование на портах<br>
- перевод портов в access<br>
- выключение всех портов командой shut<br>
ПРОВЕРКА: “show ip int br”, “show run | in interfa|switch”<br>
<em>3. Специфичная настройка Switches:</em><br>
- Создание базы VLAN<br>
- Настройка MGM vlan3,<br>
- Настройка trunk портов на свичах с указанием разрешенных VLAN и переопределением native<br>
- Переопределение конкретных access портов на свичах в соответствующие VLAN<br>
ПРОВЕРКА: “show vlan”, “show int trunk”<br>
<em>4. Специфичная настройка Router:</em><br>
- Создание SubIF, назначение соответствующих тэгов и ip-адресов<br>
ПРОВЕРКА: “show ip int br”, “show ip route”, “do ping 192.168.3.11 / 12”<br>
<em>5. Назначение ip адресов рабочим станциям</em><br>
<em>6. проверка работоспособности</em><br>
ПРОВЕРКА: “ping 192.168.3.1”, “ping 192.168.3.3”, “ping 192.168.4.3”</p>
</div><div class="cl-preview-section"><p><strong>Графическая схема:</strong><br>
<a href="https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/LAB1.jpg">https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/LAB1.jpg</a><br>
Фйлы с конфигурациями оборудования:<br>
R1: <a href="https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/R1">https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/R1</a><br>
S1: <a href="https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/S1">https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/S1</a><br>
S2: <a href="https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/S2">https://github.com/fazzzan/-otus-networks/blob/master/labs/lab1/S2</a></p>
</div><div class="cl-preview-section"><p><strong>Выводы:</strong><br>
Задание выполнено. Достигнута ip-связность узлов сети как внутри vlan, так и между VLAN-ами<br>
Дополнительно рекомендуется проработка методов фильтрации трафика, чтобы сотрудники VLAN 4 не могли иметь доступ к VLAN3 (management VLAN)</p>
</div></div>
