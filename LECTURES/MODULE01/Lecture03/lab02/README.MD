
# Lab - Развертывание коммутируемой сети с резервными каналами

## Задание: [docx](3.1.2.12_Lab___Building_a_Switched_Network_with_Redundant_Links.docx)

##  Задание:
1. Создание сети, настройка основных параметров устройств
2. Выбор корневого моста
3. Наблюдение за процессом выбора протокола STP порта, исходя из стоимости портов
4. Наблюдение за процессом выбора протокола STP порта, исходя из приоритета портов

###  Решение:
1. Графическая схема до начал работы, с нанесенной информацией о текущем приоритете и MAC-адресе коммутатора
![](/LECTURES/MODULE01/Lecture03/pictures/22.jpg)
### Просмотр приоритета и MAC адреса свича
```
show lacp sys-id 
```

2. Выбор ROOT 
До настройки VLAN3, 8, 7 - S1 являлся root для STP VLAN001 (все порты DESG/FWD)

![](/LECTURES/MODULE01/Lecture03/pictures/19.jpg)

![](/LECTURES/MODULE01/Lecture03/pictures/20.jpg)

![](/LECTURES/MODULE01/Lecture03/pictures/21.jpg)

Настройка SW выполнена в соответствии с описанием в файлах
- [S1](config/S1), 
- [S2](config/S2), 
- [S3](config/S3).

Во время настроек мелькают проблемы с native vlan, которые обязательно пройдут после того как trunk будет настроен правильно с 2 сторон:

![](/LECTURES/MODULE01/Lecture03/pictures/23.jpg)

![](/LECTURES/MODULE01/Lecture03/pictures/24.jpg)


Состояние STP после отключения избыточных интерфейсов Gi0/1, Gi1/1, Gi0/2

![](/LECTURES/MODULE01/Lecture03/pictures/26.jpg)

### Просмотр состояния STP S1
```
S1#show spanning-tree
```
Из вывода команды, видно, что по-умолчанию включен протокол PVST+ (а значит перестроение будет долгим), S1 является ROOT для обоих VLAN, приоритет не менялся, стоимость портов не менялась, все порты в состоянии DESIGNATED, что характерно для ROOT коммутатора. 
```
S1#show span

VLAN0003
  Spanning tree enabled protocol ieee
  Root ID    Priority    32771
             Address     0c09.c5ce.5300
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32771  (priority 32768 sys-id-ext 3)
             Address     0c09.c5ce.5300
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Gi0/0               Desg FWD 4         128.1    P2p 
Gi1/0               Desg FWD 4         128.5    P2p 


          
VLAN0008
  Spanning tree enabled protocol ieee
  Root ID    Priority    32776
             Address     0c09.c5ce.5300
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32776  (priority 32768 sys-id-ext 8)
             Address     0c09.c5ce.5300
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Gi0/0               Desg FWD 4         128.1    P2p 
Gi1/0               Desg FWD 4         128.5    P2p 
```

### Просмотр состояния STP S2, S3
Из вывода видно что:
- S2: порт Gi1/0 является RP (состояние FWD) за оба VLAN, порт Gi0/3 - DSG/FWD.
- S3: порт Gi0/0 является RP (состояние FWD) за оба VLAN, порт Gi0/3 - ALTN/BLCK (BLOCKED).

Такое состояние портов получается в результате анализа на S3 BPDU от S2: Вектор STP, пршедший с порта Gi 0/3 S2 - меньше вектора на S3, порт Gi0/3. Поэтому:
- S3 - Gi0/3 -  блокируется, 
- S2 - Gi0/3 - DSG/FWD

```
S2#show span

VLAN0003
  Spanning tree enabled protocol ieee
  Root ID    Priority    32771
             Address     0c09.c5ce.5300
             Cost        4
             Port        5 (GigabitEthernet1/0)
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32771  (priority 32768 sys-id-ext 3)
             Address     0c09.c5e4.6900
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Gi0/3               Desg FWD 4         128.4    P2p 
Gi1/0               Root FWD 4         128.5    P2p 
Gi3/3               Desg FWD 4         128.16   P2p 


          
VLAN0008
  Spanning tree enabled protocol ieee
  Root ID    Priority    32776
             Address     0c09.c5ce.5300
             Cost        4
             Port        5 (GigabitEthernet1/0)
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32776  (priority 32768 sys-id-ext 8)
             Address     0c09.c5e4.6900
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  300 sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Gi0/3               Desg FWD 4         128.4    P2p 
Gi1/0               Root FWD 4         128.5    P2p 
Gi3/3               Desg FWD 4         128.16   P2p 
```

Вторая часть задания состоит из отключения избыточных связей между коммутаторами и изменение стоимости одного из линков. Иллюстрация к второй части задания представлена ниже. 
![](/LECTURES/MODULE01/Lecture03/pictures/27.jpg)

### Ответы на вопросы Л/р:
- Root - S1
- S1 - ROOT, так как у него минимальный MAC-адрес и минимальный Priority Vector
- RP: S2 - Gi1/0; S3 - Gi0/0
- DP: S1 - все порты (по природе ROOT бриджа); S3 - Gi0/3
- ALTN: S3 - Gi0/3 (порт был заблокирован, так как BPDU от S2 - superior, т.е. BPDU с лучшим Bridge ID)

3. Изменение стоимости порта
Изменена стоимость RP порта Gi1/0 на S2. Включив debug span event, мы видим следующие результаты:
```
### S2
S2(config-if)#spanning-tree vlan 3 cost 10
S2(config-if)#spanning-tree vlan 8 cost 10

Mar 30 00:08:43.922: STP: VLAN0003 new root port Gi0/3, cost 8
Mar 30 00:08:43.923: STP: VLAN0003 sent Topology Change Notice on Gi0/3
Mar 30 00:08:43.923: STP[3]: Generating TC trap for port GigabitEthernet1/0
Mar 30 00:08:43.924: STP: VLAN0003 Gi1/0 -> blocking           
...
Mar 30 00:10:28.363: STP: VLAN0008 new root port Gi0/3, cost 8
Mar 30 00:10:28.364: STP: VLAN0008 sent Topology Change Notice on Gi0/3
Mar 30 00:10:28.364: STP[8]: Generating TC trap for port GigabitEthernet1/0
Mar 30 00:10:28.365: STP: VLAN0008 Gi1/0 -> blocking

### S1
S1#
Mar 29 21:08:34.598: STP: VLAN0003 Topology Change rcvd on Gi0/0
Mar 29 21:09:03.582: STP: VLAN0003 Topology Change rcvd on Gi0/0
Mar 29 21:10:19.095: STP: VLAN0008 Topology Change rcvd on Gi0/0
Mar 29 21:10:48.109: STP: VLAN0008 Topology Change rcvd on Gi0/0

### S3
Mar 29 21:08:46.679: STP: VLAN0003 Gi0/3 -> listening
Mar 29 21:08:47.704: STP: VLAN0003 Topology Change rcvd on Gi0/3
Mar 29 21:08:47.706: STP: VLAN0003 sent Topology Change Notice on Gi0/0
Mar 29 21:09:01.679: STP: VLAN0003 Gi0/3 -> learning
Mar 29 21:09:16.679: STP[3]: Generating TC trap for port GigabitEthernet0/3
Mar 29 21:09:16.681: STP: VLAN0003 sent Topology Change Notice on Gi0/0
Mar 29 21:09:16.681: STP: VLAN0003 Gi0/3 -> forwarding
Mar 29 21:10:31.115: STP: VLAN0008 Gi0/3 -> listening
Mar 29 21:10:32.130: STP: VLAN0008 Topology Change rcvd on Gi0/3
Mar 29 21:10:32.132: STP: VLAN0008 sent Topology Change Notice on Gi0/0
Mar 29 21:10:46.116: STP: VLAN0008 Gi0/3 -> learning
Mar 29 21:11:01.116: STP[8]: Generating TC trap for port GigabitEthernet0/3
Mar 29 21:11:01.118: STP: VLAN0008 sent Topology Change Notice on Gi0/0
Mar 29 21:11:01.118: STP: VLAN0008 Gi0/3 -> forwarding
```
Из дебага можно понять, что после смены стоимости линка S2-S1, произошла смена топологии, в результате чего:
- ROOT  не поменялся, так как BID остались прежними
- стоимость линка S1-S2 увеличилась и стала больше чем суммарная стоимость до ROOT S2-S3-S1, поэтому S2 переводит порт Gi1/0 в состояние ALTN/BLK
- Стоимость линка S1-S3 не исзменилась, состояние порта осталось RP/FWD
- Так как стоимость линка S2-S1 Увеличилась, то конкуренция между S3 и S2 за ROOT - пропала. S3 - Gi0/3 разблокировался DP/FWD


Иллюстрация к изменившейся топологии приведена выше.

Ответом на вопрос Шаг 3 задания я вляется то, что S2 сравнивает пришедшую от S3 BPDU с информацией которая есть на нем и признает, что путь, который предлагает  от S3 является лучшим. Значит надо заблокировать порт Gi1/0, а порт Gi0/3 сделать DP/FWD.

4. После удаления стоимости порта, видим обратную картину, порты вернулись в предварительное состояние
```
S2(config-if)#do sho span | in VLAN|Interf|Gi
VLAN0003
             Port        5 (GigabitEthernet1/0)
Interface           Role Sts Cost      Prio.Nbr Type
Gi0/3               Desg FWD 4         128.4    P2p 
Gi1/0               Root FWD 4         128.5    P2p 
Gi3/3               Desg FWD 4         128.16   P2p 

VLAN0008
             Port        5 (GigabitEthernet1/0)
Interface           Role Sts Cost      Prio.Nbr Type
Gi0/3               Desg FWD 4         128.4    P2p 
Gi1/0               Root FWD 4         128.5    P2p 
Gi3/3               Desg FWD 4         128.16   P2p 
```
5. Включим все порты на S1, S2, S3. 

Дебаг показывает, что S1 остается ROOT за оба VLAN
```
S1(config-if-range)#
Mar 29 21:36:26.926: STP: VLAN0003 Topology Change rcvd on Gi1/0
Mar 29 21:36:26.928: STP: VLAN0008 Topology Change rcvd on Gi1/0
Mar 29 21:36:29.032: %LINK-3-UPDOWN: Interface GigabitEthernet0/1, changed state to up
Mar 29 21:36:29.195: %LINK-3-UPDOWN: Interface GigabitEthernet1/1, changed state to up
Mar 29 21:36:30.032: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/1, changed state to up
Mar 29 21:36:30.195: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet1/1, changed state to up
Mar 29 21:36:30.357: set portid: VLAN0003 Gi0/1: new port id 8002
Mar 29 21:36:30.357: STP: VLAN0003 Gi0/1 -> listening
Mar 29 21:36:30.358: set portid: VLAN0008 Gi0/1: new port id 8002
Mar 29 21:36:30.358: STP: VLAN0008 Gi0/1 -> listening
Mar 29 21:36:30.359: set portid: VLAN0003 Gi1/1: new port id 8006
Mar 29 21:36:30.359: STP: VLAN0003 Gi1/1 -> listening
Mar 29 21:36:30.359: set portid: VLAN0008 Gi1/1: new port id 8006
Mar 29 21:36:30.359: STP: VLAN0008 Gi1/1 -> listening
Mar 29 21:36:31.382: STP: VLAN0003 Topology Change rcvd on Gi1/0
Mar 29 21:36:31.573: STP: VLAN0008 Topology Change rcvd on Gi1/0
Mar 29 21:36:45.358: STP: VLAN0003 Gi0/1 -> learning
Mar 29 21:36:45.358: STP: VLAN0008 Gi0/1 -> learning
Mar 29 21:36:45.359: STP: VLAN0003 Gi1/1 -> learning
Mar 29 21:36:45.360: STP: VLAN0008 Gi1/1 -> learning
Mar 29 21:37:00.363: STP[3]: Generating TC trap for port GigabitEthernet0/1
Mar 29 21:37:00.364: STP: VLAN0003 Gi0/1 -> forwarding
Mar 29 21:37:00.364: STP[8]: Generating TC trap for port GigabitEthernet0/1
Mar 29 21:37:00.364: STP: VLAN0008 Gi0/1 -> forwarding
Mar 29 21:37:00.365: STP[3]: Generating TC trap for port GigabitEthernet1/1
Mar 29 21:37:00.365: STP: VLAN0003 Gi1/1 -> forwarding
Mar 29 21:37:00.365: STP[8]: Generating TC trap for port GigabitEthernet1/1
Mar 29 21:37:00.366: STP: VLAN0008 Gi1/1 -> f        g

S1(config-if-range)#do sho span

VLAN0003
  Spanning tree enabled protocol ieee
  Root ID    Priority    32771
             Address     0c09.c5ce.5300
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32771  (priority 32768 sys-id-ext 3)
             Address     0c09.c5ce.5300
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  15  sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Gi0/0               Desg FWD 4         128.1    P2p 
Gi0/1               Desg FWD 4         128.2    P2p 
Gi1/0               Desg FWD 4         128.5    P2p 
Gi1/1               Desg FWD 4         128.6    P2p 


 --More-- 
VLAN0008
  Spanning tree enabled protocol ieee
  Root ID    Priority    32776
             Address     0c09.c5ce.5300
             This bridge is the root
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec

  Bridge ID  Priority    32776  (priority 32768 sys-id-ext 8)
             Address     0c09.c5ce.5300
             Hello Time   2 sec  Max Age 20 sec  Forward Delay 15 sec
             Aging Time  15  sec

Interface           Role Sts Cost      Prio.Nbr Type
------------------- ---- --- --------- -------- --------------------------------
Gi0/0               Desg FWD 4         128.1    P2p 
Gi0/1               Desg FWD 4         128.2    P2p 
Gi1/0               Desg FWD 4         128.5    P2p 
Gi1/1               Desg FWD 4         128.6    P2p 
```

После прохождения 30 секунд топология будет соответствовать иллюстрации
![](STP4.jpg)
Ответы на вопросы:
- На каждом не корневом SW, RP выбран порт соединенный с портом, облажающим минимальным SenderPortID. При прочих равных условиях BPDU оценивается именно по этому параметру.

После перехода на всех 3 SW на RSTP - время сходимости уменьшилось до 30 секунд:
```
Mar 30 00:57:23.761: RSTP(3): updt roles, non-tracked event
Mar 30 00:57:23.762: RSTP(3): Gi1/0 is now root port
Mar 30 00:57:23.762: RSTP(3): Gi1/1 blocked by re-root
...
Mar 30 00:57:52.413: RSTP(8): transmitting a proposal on Gi3/3
Mar 30 00:57:53.764: RSTP(3): Gi3/3 fdwhile Expired
Mar 30 00:57:53.766: RSTP(8): Gi3/3 fdwhile Expired
```
Осталось попробовть:
- DHCP Snooping
- Dynamic ARP Inspection
