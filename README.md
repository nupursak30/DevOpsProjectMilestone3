# Redis Feature Flag

### 
We have created redis master-slave topology. We have used 3 AWS EC2 instances. One as a master and other two as slaves. The Feature flags will be set on the master server and slave will get these flags on their servers. 

For demonstrating the feature flag, we have used the route /api/design/survey in server.js of checkbox.io application.

Once the flag "marqdownFlag" is set false, Marqdown Feature will be disabled on both slave servers.<br /> When the flag "marqdownFlag" is set true, Marqdown Feature will be enabled .

Redis roles are present in: [./post_build/roles/redisServer/](https://github.ncsu.edu/cmachan/RedisFeatureFlag/tree/master/post_build/roles/redisServer)
<br /> Checkbox.io that was used for redis feature is [checkbox.io](https://github.com/cmachan/checkbox.io

Steps: 

1. Git clone this repo.
2. Also make sure you copy the config file inside the ~/.ssh/ folder of your ansible server machine.
3. Update credentials.ini with your credentials.
4. Edit the [id_rsa] placed at location ./roles/SetupJenkins/tasks/id_rsa)
5. Edit the ssh_config.j2 file present inside roles/SetupJenkins/templates folder with your  github username and  email id 
6. Run the following commands now:
- ansible-playbook -i inventory main.yml

### Screencast Link 
[https://youtu.be/MFT6s1E90YM](https://youtu.be/MFT6s1E90YM)
 
