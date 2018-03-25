# vaping-exporter

[![Build Status](https://travis-ci.org/bojanrajkovic/vaping-exporter.svg?branch=master)](https://travis-ci.org/bojanrajkovic/vaping-exporter)

A Prometheus exporter for [vaping](https://github.com/20c/vaping).

## How do I use it

### Via Docker

```bash
docker pull brajkovic/vaping-exporter:<tag>
docker run -p <port> -v /path/to/vaping/config.yml:/vaping/config.yml vaping-exporter:<tag>
```

You can also modify the image to your needs, push it to your own repository, and
adjust the pull/run commands above as needed.

### Via Kubernetes

You can use the example manifest(s) in [`kubernetes-example.yml`][kube] to
deploy vaping and the Prometheus exporter on Kubernetes. The default example
runs vaping configured to ping 8.8.8.8 10 times every 3 seconds, and listens on
port 9099. If you run Prometheus inside your cluster, you can scrape it with the
following configuration:

```yaml
scrape_configs:
  - job_name: "vaping"
    scrape_interval: "3m"
    metrics_path: ""
    static_configs:
      - targets: [ "vaping.default.svc.cluster.local:9099" ]
```

Be aware that if you change the namespace for the deployment, you'll need to
adjust the target as well. If you run Prometheus outside your cluster, you'll
want to expose the exporter somehow&mdash;either by adjusting the `Service` to
use `NodePort`, `LoadBalancer`, or `externalIPs`, or using an `Ingress` pointed
at the service.

### Standalone/with an existing vaping setup

Put `prometheus.py` in the `plugins` directory of your vaping config directory,
and then adapt the configuration from the sample config.yml below to introduce
the Prometheus exporter to your existing vaping configuration.

## Sample config.yml

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

## Sample Grafana dashboard

A sample Grafana dashboard is available in [`vaping-dashboard.json`][dash]. It
assumes that you've configured Prometheus as a datasource called `Prometheus
(vaping)`, and little else. It's parameterized based on the "host" label, so
you'll be able to choose which host you want to see stats from among all the
hosts you're monitoring. It looks like this:

![Grafana Dashboard](https://volley.coderinserepeat.com/brajkovic/vaping-grafana.png)

[kube]: ./kubernetes-example.yaml
[dash]: ./vaping-dashboard.json
