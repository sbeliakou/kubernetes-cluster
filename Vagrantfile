load 'config.rb'

def workerIP(num)
  return "192.168.56.#{num+150}"
end

Vagrant.configure("2") do |config|
    config.vm.provision "Basic OS Provisioning", type: "shell", 
        inline: "bash /vagrant/scripts/base.sh"

    (0..$worker_count).each do |index|
        node_name = (index == 0) ? "k8s-master" : "k8s-worker-%d" % index

        config.vm.define node_name do |node|
            node.vm.box = $image
            node.vm.hostname = node_name
            node.vm.network :private_network, ip: workerIP(index)

            node.vm.provider :virtualbox do |vb|
                vb.name = node_name
                vb.memory = (index == 0) ? $master_memory : $worker_memory
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{70/($worker_count+1)}"]
            end

            # Master/Worker Provisioning
            node.vm.provision "Kubernetes Provisioning", type: "shell" do |shell|
                shell.inline = "bash /vagrant/scripts/k8s-#{(index == 0) ? 'master' : 'worker'}.sh $1 $2"
                shell.args = [workerIP(0), $token]
            end

            # Provision all services once the last worker is done
            if (index == $worker_count) then
                node.vm.provision "Master Isolation", type: "shell",  
                    inline: "bash /vagrant/scripts/k8s-master-isolation.sh" if ($worker_count == 0)

                node.vm.provision "Kubernetes Dashboard", type: "shell",
                    inline: "bash /vagrant/scripts/k8s-dashboard.sh"

                node.vm.provision "Ngix Ingress Controller", type: "shell",
                    inline: "bash /vagrant/scripts/k8s-ingress.sh %s" % workerIP(0) if ($ingress_controller)

                node.vm.provision "Grafana + InfluxDB Monitoring", type: "shell",
                    inline: "bash /vagrant/scripts/k8s-grafana.sh %s" % workerIP(0) if ($grafana)

                node.vm.provision "Prometheus Monitoring", type: "shell",
                    inline: "bash /vagrant/scripts/k8s-prometheus.sh %s" % $domain if ($prometheus)

                node.vm.provision "Cluster Info", type: "shell", 
                    inline: "sleep 5; kubectl cluster-info", run: "always"
            end
        end
    end
end