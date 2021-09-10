=========================
Fundamentos de ingenieria
=========================

Puertos y protocolos de red
===========================

192.168.0.20 apunta a localhost Puertos cerrados por defecto: 1 al 1024

Qué es una dirección IP y el protocolo de Internet
==================================================

Las máscaras de red nos indica cuales son los bytes que no pueden
cambiar dentro de una red local.

255.255.0.0.

Este número nos indica que los dos primeros bytes no pueden cambiarse,
puesto que están todos "ocupados" formados por solo "1", mientras que
los dos últimos sí.

El Gateway intercambia información con modem usando NAT (Network Address
Translation), que traduce de direcciones de internet a las redes de la
LAN. Una vez el computador tenga el gateway se puede conectar a
internet.

Qué es un dominio, DNS o Domain Name System
===========================================

El primer paso de un ISP es conectarse a un DNS (Domain Name Server),
este último es una base de datos que relaciona nombres de dominio con
direcciones IP.

Cómo los ISP hacen Quality of Service o QoS
===========================================

QOS: La prioridad que le asignan los ISP a los diferentes tipos de
peticiones para favorecer sus intereses. Para evitar esto se inventaron
los CDN (Content Delivery Networks), que son como replicas (o cache) del
sitio web original.

Cómo funciona la velocidad en internet
======================================

El ping es el tiempo que tarda la conexión en establecerse.

Qué es el Modelo Cliente/Servidor
=================================

Node también puede servir de servidor (Tal cual Nginx y Apache)
