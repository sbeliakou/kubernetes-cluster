load 'config.rb'

def workerIP(num)
  return "192.168.56.#{num+150}"
end

image = 'sbeliakou/centos'

Vagrant.configure("2") do |config|
    # Master VM Box
    config.vm.define "k8s-master" do |master|
        master.vm.box = image
        master.vm.hostname = "k8s-master"
        master.vm.network :private_network, ip: workerIP(0)

        master.vm.provider :virtualbox do |vb|
            vb.name = "k8s-master"
            vb.memory = $master_memory
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
            vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{70/($worker_count+1)}"]
        end

        master.vm.provision 'shell' do |shell|
            shell.inline = 'bash /vagrant/install.sh $1 $2 $3'
            shell.args = ["master", workerIP(0), $token]
        end
    end

    # Workers Nodes
    (1..$worker_count).each do |index|
        config.vm.define "k8s-worker-%d" % index do |worker|
            worker.vm.box = image
            worker.vm.hostname = "k8s-worker-#{index}"
            worker.vm.network :private_network, ip: "#{workerIP(index)}"

            worker.vm.provider :virtualbox do |vb|
                vb.name = "k8s-worker-#{index}"
                vb.memory = $worker_memory
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{70/($worker_count+1)}"]
            end

            worker.vm.provision 'shell' do |shell|
                shell.inline = 'bash /vagrant/install.sh $1 $2 $3'
                shell.args = ["worker", workerIP(0), $token]
            end
        end
    end
end