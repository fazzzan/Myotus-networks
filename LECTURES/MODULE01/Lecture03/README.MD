# OTUS 20210305
# Избыточность локальных сетей. STP

[pdf материалов лекции](OTUS_3_STP-1801_20210309.pdf)

STP - предотвращение петель коммутации, путем построение некой L2 - схемы сети и отключение избыточных линков, с целью предотвращения закольцовывания прохождения пакета. При этом алгоритм работы отслеживает изменение топологии сети и при падении активного линка, активация резервных линков

![](pictures\01.jpg)

L2 - нет TTL, при закольцовке растет загрузка CPU, возникает деградация сервиса.

# BC шторм

# STP алгогритм
![](pictures\02.jpg)

1. Выбираем ROOT

![](pictures\03.jpg)

- BID = Extended System ID + MAC-адрес коммутатора. 
- PRI - 16bit:
   - 0 - 61440, шаг 4096
   - Default 32768
- Extended System ID =  PRI + VLAN
- MAC-адрес необходим, если совпадут Extended System ID на нескольких SW. Победит SW с min MAC. ___ВНИМАНИЕ___: старые железки имеют меньшие MAC, чем современные

Победит SW с min BID 

![](pictures\04.jpg)

2. Высчитываем стоимость линков до ROOT Bridge и на этом основании на каждом SW выбираем ROOT Port (смотрящий на ROOT SW).

Стоимости линков есть старые и новые:
![](pictures\05.jpg)

Чем быстрее линк, тем меньше его стоимость. Но STP не понимает скорости выше 20 Gbit. RSTP - корректирует эту стоимость.

![](pictures\06.jpg)

3. Определяем роли остальных портов:
- на ROOT - все порты DP, FWD
- на конкурирующих SW в сторону ROOT смотрит RP (FWD). Все Access - порты, не смотрящие на root - по-умолчанию DP.
- Если порт не является RP, то он должен либо заблокироваться. Заблокированный порт гасится и становится NDP/BLK

![](pictures\07.jpg)

Как выяснить блокируемы порт? 
Если стоимости до ROOT - одинаковы, то решаем по стоимости BID посылающего. SW с min BID - побеждает и оставляет свой порт включенным DP/FWD. Второй SW - смиряется и гасит свой порт NDP/BLK. При этом SW не отправляет через этот порт никаких пакетов, кроме BPDU.

Если до ROOT 2 линкА с одинаковым BID, то лочится тот порт, на который прилетела BPDU с большим ID порта.


# STP Timers и состояние портов
3 таймера
- Hello timer (интервал между BPDU, def 2 sec, может меняться в диапазоне 1 - 10 sec)
- Forward delay timer: суммарное время нахождения порта в 2 состояниях
   - listening (15 sec)
   - learning (15 sec) 
- Max age timer

![](pictures\08.jpg)

Итого, в худшем случае мы будем простаивать 2(hello timer)+20+15+15 = 52 сек до включения порта в Forwarding.

состояния портов

![](pictures\09.jpg)

# STP Versions

![](pictures\10.jpg)

# RSTP Concepts
```show spann``` - покажет информацию по RSTP, при этом для каждолго VLAN будет запущен собственный экземпляр STP. 

В RSTP другие состояния портов:

![](pictures\11.jpg)


![](pictures\12.jpg)

# Альтернативы STP
Переходить на маршрутизируемые, а не коммутируемые сети.

https://community.cisco.com/t5/%D0%BC%D0%B0%D1%80%D1%88%D1%80%D1%83%D1%82%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F-%D0%B8-%D0%BA%D0%BE%D0%BC%D0%BC%D1%83%D1%82%D0%B0%D1%86%D0%B8%D1%8F-%D0%B2%D0%B8%D0%B4%D0%B5%D0%BE/%D0%B2%D0%B5%D0%B1%D0%B8%D0%BD%D0%B0%D1%80-%D0%BD%D0%B0-%D1%82%D0%B5%D0%BC%D1%83-quot-%D0%B4%D0%B8%D0%B7%D0%B0%D0%B9%D0%BD-%D0%BE%D1%82%D0%BA%D0%B0%D0%B7%D0%BE%D1%83%D1%81%D1%82%D0%BE%D0%B9%D1%87%D0%B8%D0%B2%D1%8B%D1%85-%D0%BB%D0%BE%D0%BA%D0%B0%D0%BB%D1%8C%D0%BD%D1%8B%D1%85-%D1%81%D0%B5%D1%82%D0%B5%D0%B9/ba-p/3103390

![](pictures\13.jpg)

Сеть и линкИ будут работать не только во время отказа. Задействованы будут Все линки, в соответствии стаблицей маршрутизации. Чтобы оптимизировать работу такой сети, надо
- L3 SW (отказываемся от STP, не нужны Etch/STP/FHRP)
- настройить IGP (OSPF/EIGRP/BFD)
- оптимизировать маршруты
- нарезать множество подсетей (каждый линк - отдельная сетка)
- Управлять балансировкой нагрузки чуть ли не в ручном режиме.

Также выход - использование стекируемых коммутаторов
![](pictures\14.jpg)

И еще один выход - применение VSS на свичах (4500/6500).

 Слева - физика, справа - логика. Работает на дорогих 6500, линки до разных модулей ядра справа воспринимаются как дублирующие линки. ЛинкИ между SW - VSL[virtual SW link]
![](pictures\15.jpg)

![](pictures\17.jpg)


Еще один способ - ___Multichassis Etherchannel___

![](pictures\18.jpg)


## ___Лабораторка 2.1___

- [LAB-linc](lab02/README.MD)

Задача: Lab - Развертывание коммутируемой сети с резервными каналами