require './foreach.rb'

experiment 'Montage' do
	foreach [ 'instance 2'], safely do |instance|
		on instance do
			# before 'install prerequisites' do
			# 	`curl -O http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz;
			# 	tar zxvf Montage_v3.3_patched_4.tar.gz; 
			# 	cd Montage_v3.3_patched_4; 
			# 	make;
			# 	cd ..;
			# 	git clone https://github.com/dice-cyfronet/hyperflow.git --depth 1 -b develop;
			# 	cd hyperflow;
			# 	npm install;
			# 	curl -O https://dl.dropboxusercontent.com/u/81819/hyperflow-amqp-executor.gem;
			# 	echo mamrchckten | sudo -S gem2.0 install --no-ri --no-rdoc hyperflow-amqp-executor.gem`
			# end
			foreach [2, 4, 8] do |cores|
				hyperflow_deamon = -100;
				before 'init amqp' do
					`echo  "amqp_url: amqp://localhost\nstorage: local\nthreads: <%= Executor::cpu_count %>" > executor_config.yml`
				end
				before "deamon", asynchronously do 
					hyperflow_deamon = fork do
					  exec "hyperflow-amqp-executor executor_config.yml"
					end
					Process.detach(hyperflow_deamon)
				end
				before "bootstrap script", asynchronously do 
					# `mkdir data; 
					# cd data;
					# wget https://gist.github.com/kfigiela/9075623/raw/dacb862176e9d576c1b23f6a243f9fa318c74bce/bootstrap.sh;
					# chmod +x bootstrap.sh` 
				end
				foreach [0.25] do |param|
					before do
						puts 'prepare data'
						`./data/bootstrap.sh #{param}` 
					end
					execute do
						puts 'exec'
						puts `nodejs ~/Pulpit/cloud-experiment/treeBuilding/hyperflow/scripts/runwf.js -f  ~/Pulpit/cloud-experiment/treeBuilding/data/#{param}/workdir/dag.json -s`
					end
					after do
						`cp  -r ./#{param}/input ./output`
						`rm -rf ./#{param}`
					end
				end
				after do 
					 Process.kill("HUP", hyperflow_deamon)
					 # `rm -rf data`
				end
			end
		end
	end			
end
