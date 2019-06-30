# If you change, Keep the structure with the dot. [0-9 a-f]
$token = "abcdef.0123456789abcdef"

# Total memory of master
$master_memory = 6000

# Worker Nodes, 0 = Master Isolation
$worker_count = 2

# Total memory of nodes
$worker_memory = 1536

# Kubernetes Version
$k8s_version = "1.13.7"

# Cluster IP Addresses
$cluster_ips = "192.168.56.224/28"
$metallb_ips = "192.168.56.240/28"

# Deploy Metal LB
$metallb = true

# Deploy Ingress Controller
$ingress_controller = "nginx"

# Deploy Prometheus
$prometheus = false

# Grafana with InfluxDB (work with heapster)
$grafana = false
