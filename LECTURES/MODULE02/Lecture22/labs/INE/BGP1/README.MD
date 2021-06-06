___Небольшая л/р BGP IPv4/IPv6___

![](/LECTURES/MODULE02/Lecture22/pictures/70.jpg)

```
router bgp 64501
 bgp router-id 2.2.2.1
 bgp log-neighbor-changes
 no bgp default ipv4-unicast
 neighbor 2001:1111::2 remote-as 64502
 neighbor 2001:1111::2 update-source GigabitEthernet0/2
 neighbor 101.0.0.2 remote-as 64500
 neighbor 101.0.0.6 remote-as 64502
 neighbor 101.0.0.10 remote-as 64503
 !
 address-family ipv4
  network 104.0.0.0 mask 255.255.240.0
  neighbor 101.0.0.2 activate
  neighbor 101.0.0.6 activate
  neighbor 101.0.0.10 activate
 exit-address-family
 !
 address-family ipv6
  network 2001:AAAA::1/128
  neighbor 2001:1111::2 activate
 exit-address-family
```