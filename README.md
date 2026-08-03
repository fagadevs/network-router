# Network Router

Imagen Ubuntu creada para laboratorios de redes con Docker y Containerlab.

## Componentes incluidos

- FRRouting
- dnsmasq
- nftables
- iproute2
- ping
- traceroute
- tcpdump
- herramientas básicas de diagnóstico

## Descargar la imagen

```bash
docker pull ghcr.io/fagadevs/network-router:1.0.0
```

## Construir la imagen localmente

```bash
git clone https://github.com/fagadevs/network-router.git
cd network-router

docker build -t network-router:local .
```

## Uso en containerlab

```yaml
topology:
  defaults:
    kind: linux
    image: ghcr.io/fagadevs/network-router:1.0.0
    binds:
      - ./config/__clabNodeName__:/config:ro
```

La imagen inicia los servicios según los archivos encontrados en /config:

```text
frr.conf: inicia FRRouting.
dnsmasq.conf: inicia dnsmasq.
nftables.conf: carga las reglas de nftables.
startup.sh: ejecuta comandos particulares del nodo, si existen.
```

Se puede omitir los archivos, no son obligatorios.