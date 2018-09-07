# If you change, Keep the structure with the dot. [0-9 a-f]
$token = "abcdef.0123456789abcdef"

# Total memory of master
$master_memory = 2560

# Increment to have more nodes
$worker_count = 0

# Total memory of nodes
$worker_memory = 1536

# Add Grafana with InfluxDB (work with heapster)
$grafana = false

# Deploy Ingress Controller
$ingress_controller = true

# Deploy Prometheus
$prometheus = true
$prometheus_fqdn = "prometheus.example.com"
$grafana_fqdn = "grafana.example.com"