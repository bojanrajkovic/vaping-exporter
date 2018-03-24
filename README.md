# vaping-exporter

A Prometheus exporter for https://github.com/20c/vaping.

## How do I use it?

```bash
docker pull brajkovic/vaping-exporter:<tag>
docker run -p <port> -v /path/to/vaping/config.yml:/vaping/config.yml vaping-exporter:<tag>
```

You can also modify the image to your needs, push it to your
own repository, and adjust the pull/run commands above as
needed.

## Sample vaping.yml

```yaml
probes:
  - name: latency
    type: std_fping
    output:
      - prometheus
    public_dns:
      hosts:
        - host: 8.8.8.8
          name: Google
        - host: 4.2.2.1
          name: Level(3)
        - host: 208.67.222.222
          name: OpenDNS
plugins:
  - name: std_fping
    type: fping
    count: 10
    interval: 3s
    output:
      - prometheus
  - name: prometheus
    type: prometheus
    port: [choose a port, 9099 will be used if omitted]
```
