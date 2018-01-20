load 'config.rb'

def workerIP(num)
  return "192.168.56.#{num+150}"
end

image = 'sbeliakou/centos'

Vagrant.configure("2") do |config|
    (0..$worker_count).each do |index|
        node_name = (index == 0) ? "k8s-master" : "k8s-worker-%d" % index

        config.vm.define node_name do |node|
            node.vm.box = image
            node.vm.hostname = node_name
            node.vm.network :private_network, ip: "#{workerIP(index)}"

            node.vm.provider :virtualbox do |vb|
                vb.name = node_name
                vb.memory = $worker_memory
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{70/($worker_count+1)}"]
            end

            node.vm.provision 'shell' do |shell|
                shell.inline = "bash /vagrant/scripts/k8s-#{(index == 0) ? 'master' : 'worker'}.sh $1 $2"
                shell.args = [workerIP(0), $token]
            end

            if (index == $worker_count and index > 0) then
                node.vm.provision "shell", inline: "bash /vagrant/scripts/k8s-dashboard.sh"
            end
        end
    end

    config.vm.provision "shell", inline: "bash /vagrant/scripts/base.sh"
end