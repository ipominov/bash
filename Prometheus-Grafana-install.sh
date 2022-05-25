#!/bin/bash

apt update && apt install -y libfontconfig1

useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false node_exporter
mkdir /etc/prometheus && chown prometheus: /etc/prometheus
mkdir /var/lib/prometheus && chown prometheus: /var/lib/prometheus

cat << EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
EOF


#wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz
tar -xzvf prometheus-*
cp prometheus*/prometheus /usr/local/bin/ && cp prometheus*/promtool /usr/local/bin/
chown prometheus: /usr/local/bin/prometheus && chown prometheus: /usr/local/bin/promtool
cp -r prometheus*/consoles /etc/prometheus && cp -r prometheus*/console_libraries /etc/prometheus
chown -R prometheus: /etc/prometheus/consoles && chown -R prometheus: /etc/prometheus/console_libraries
chown prometheus: /etc/prometheus/prometheus.yml

cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/ --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable prometheus

wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xzvf node_exporter-*

cp node_exporter-*/node_exporter /usr/local/bin && chown node_exporter: /usr/local/bin/node_exporter

cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable node_exporter && systemctl start node_exporter && systemctl start prometheus

echo -en "\n\n" && echo -en "\033[1;33m УСТАНОВКА PROMETHEUS И NODE_EXPORTER ВЫПОЛНЕНА \033[0m\n" && sleep 2

#wget https://dl.grafana.com/enterprise/release/grafana-enterprise_8.5.3_amd64.deb
dpkg -i grafana_*.deb
systemctl enable grafana-server && systemctl start grafana-server
