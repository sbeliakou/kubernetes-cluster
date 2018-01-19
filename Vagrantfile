load 'config.rb'

def workerIP(num)
  return "192.168.56.#{num+150}"
end

image = 'sbeliakou/centos'

Vagrant.configure("2") do |config|
    # Master VM Box
    config.vm.define "master" do |master|
        ip = "#{workerIP(0)}"

        master.vm.box = image
        master.vm.hostname = "k8s-master"
        master.vm.network :private_network, ip: ip

        master.vm.provider :virtualbox do |vb|
            vb.name = "k8s-master"
            vb.memory = $master_memory
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{70/($worker_count+1)}"]
        end

        master.vm.provision 'shell' do |shell|
            shell.inline = 'bash /vagrant/install.sh $1 $2 $3'
            shell.args = ["master", ip, $token]
        end
    end

    # Workers Nodes
    (1..$worker_count).each do |index|
        config.vm.define "k8s-worker-%d" % index do |nodeconfig|
            ip = "#{workerIP(index)}"

            nodeconfig.vm.box = image
            nodeconfig.vm.hostname = "k8s-worker-#{index}"
            nodeconfig.vm.network :private_network, ip: "#{workerIP(index)}"

            nodeconfig.vm.provider :virtualbox do |vb|
                vb.name = "k8s-worker-#{index}"
                vb.memory = $worker_memory
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{70/($worker_count+1)}"]
            end

            nodeconfig.vm.provision 'shell' do |shell|
                shell.inline = 'bash /vagrant/install.sh $1 $2 $3'
                shell.args = ["worker", ip, $token]
            end
        end
    end
end