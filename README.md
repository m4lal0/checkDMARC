# checkDMARC

![checkDMARC-Help-Panel](./images/Help-Panel.png)

<h4 align="center">Script que comprueba un dominio o una lista de dominios desde un archivo que puedan ser suplantados en base a los registros DMARC.</h4>
<br> 

[![GitHub top language](https://img.shields.io/github/languages/top/m4lal0/checkDMARC?logo=gnu-bash&style=for-the-badge)](#)
[![GitHub repo size](https://img.shields.io/github/repo-size/m4lal0/checkDMARC?logo=webpack&style=for-the-badge)](#)
[![Kali Supported](https://img.shields.io/badge/Kali-Supported-blue?style=for-the-badge&logo=kali-linux)](#)
[![MacOS Supported](https://img.shields.io/badge/MacOS-Supported-blue?style=for-the-badge&logo=macos)](#)
[![Version](https://img.shields.io/badge/Version-1.0.1-blue?style=for-the-badge)](#)
[![By](https://img.shields.io/badge/By-m4lal0-green?style=for-the-badge&logo=github)](#)

---

## Instalación

```bash
git clone https://github.com/m4lal0/checkDMARC
cd checkDMARC; chmod +x checkDMARC.sh && mv checkDMARC.sh /usr/local/bin/checkDMARC
```

## ¿Cómo ejecuto la herramienta?

Para el funcionamiento, es necesario especificar el dominio usando el parámetro ***`-d`*** ó ***`--domain`***:

```bash
./checkDMARC -d [DOMAIN]
o
./checkDMARC --domain [DOMAIN]
```

![checkDMARC-Domain](./images/Check-Domain.png)

Si cuenta con un archivo que tiene un listado de dominios puede usar el parámetro ***`-f`*** ó ***`--file`*** :

```bash
./checkDMARC -f [DOMAIN_LIST]
o
./checkDMARC --file [DOMAIN_LIST]
```

![checkDMARC-Domain-List](./images/Check-Domain-List.png)

## Actualizar la herramienta

Para poder actualizar la herramienta es necesario ejecutarla con el parámetro ***`-u`*** ó ***`--update`***, con ello verifica si existe una nueva versión y si la acepta, se iniciará la actualización completa.

```bash
./checkDMARC --update
```