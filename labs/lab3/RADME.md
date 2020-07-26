# Развертывание DHCPv4

###  Задание:
1. Построить сеть и произвести базовые настройки оборудования
2. Сконфигурировать DHCPv4 сервера для подсетей на R1
3. Сконфигурировать и проверить функционал DHCP relay на R2

###  Решение:
1. Графическая схема до начал работы, с нанесенной информацией о ионетфейсах и настраиваемых VLAN
![](DHCPv4_start.png)
### Этапы работы п.п.1
Для расчета адресного пространства используем метод квадрата, которые дает наглядность используепмых адресов 
![](BOX_Visual_NW.jpg)
Таблица назначения адресов, согласно ТЗ представлена ниже:

| Device  | Interface  | IP Address     | Subnet Mask       | def GW   | Description   |
|---------|------------|----------------|-------------------|----------|---------------|
| R1      | Gi0/0      | 10.0.0.1       | 255.255.255.252   | 10.0.0.2 | IF to R2      |
|         | Gi0/1      | N/A            | N/A               | N/A      |               |
|         | Gi0/1.100  | 192.168.1.1    | 255.255.255.192   |          | VLAN100       |
|         | Gi0/1.200  | 192.168.1.65   | 255.255.255.224   |          | VLAN200       |
|         | Gi0/1.1000 | N/A            | N/A               |          | VLAN1000      |
| R2      | Gi0/0      | 10.0.0.2       | 255.255.255.252   | 10.0.0.2 | IF to R1      |
|         | Gi0/1      | 192.168.1.97   | 255.255.255.240   |          |               |
| S1      | VLAN100    | 192.168.1.2    | 255.255.255.192   |          | IF to R2      |
|         | VLAN200    | 192.168.1.66   | 255.255.255.224   |          | PC1           |
| S2      | VLAN1      | 192.168.1.98   | 255.255.255.240   |          | PC2           |
| PC1     | NIC        | DHCP           | DHCP              | DHCP     | SUBNETA       |
| PC2     | NIC        | DHCP           | DHCP              | DHCP     | SUBNETC       |

Произведем настройку IF согласно таблице адресного пространства
```
show ip int br
```
```
S1(config)#do sho ip int br
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0     unassigned      YES unset  up                    up      
GigabitEthernet0/1     unassigned      YES unset  administratively down down    
...
GigabitEthernet1/3     unassigned      YES unset  administratively down down    
Vlan100                192.168.1.2     YES manual up                    up      
Vlan200                192.168.1.66    YES manual up                    up      

S2(config)#do sho ip int br
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0     unassigned      YES unset  up                    up      
GigabitEthernet0/1     unassigned      YES unset  administratively down down    
...
GigabitEthernet1/3     unassigned      YES unset  administratively down down    
Vlan1                  192.168.1.98    YES manual up                    up      

R1(config-subif)#do sho ip int br
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.0.0.1        YES manual up                    up      
GigabitEthernet0/1         unassigned      YES unset  up                    up      
GigabitEthernet0/1.100     192.168.1.1     YES manual up                    up      
GigabitEthernet0/1.200     192.168.1.65    YES manual up                    up      
GigabitEthernet0/1.1000    unassigned      YES unset  up                    up      
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
...
R2(config-if)#do sho ip int br
Interface                  IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0         10.0.0.2        YES manual up                    up      
GigabitEthernet0/1         192.168.1.97    YES manual up                    up      
GigabitEthernet0/2         unassigned      YES unset  administratively down down    
```

Объяснение результатов
Из вывода команды, видно, что по-умолчанию ....

Базовые настройки оборудования представлены по ссылкам [S1](config/S1), [S2](config/S2), [S3](config/S3).

2. Этап. Настройка ... 
После того как было настроено....
### Просмотр состояния на узле...
```
X# show ...
```
Демонстрация вывода команды представлена ниже...
```
.....
```
На основании представленной информации можно сделать вывод, что ....

### Ответы на вопросы Л/р:
- ...
- ...

Вторая часть задания состоит настройке .... Иллюстрация к второй части задания представлена ниже. 
![](XXX2.jpg)

1. Изменение стоимости порта
Изменена стоимость порта Gi0/3 на S2. Включив debug span event, мы видим следующие результаты:
```
### S2
....
```
Из дебага можно понять, что 

Иллюстрация к изменившейся топологии приведена ниже:
![](XXX3.jpg)
Ответом на вопрос задания является то, что ...

4. После удаления стоимости порта, видим обратную картину, порты вернулись в предварительное состояние
```
...
```
дебаг процесса представлен ниже
```
...
```

5. Включим все порты на S1, S2, S3. После прохождения 30 секунд топология будет соответствовать иллюстрации
![](STP4.jpg)
Ответы на вопросы:
- На каждом не корневом           
