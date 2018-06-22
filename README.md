# DevOpsMilestone3

## Team Members:
+ Nupur Pradeep Sakhalkar (nsakhal)
+ Neha Pradeep Sakhalkar (nsakhal2)
+ Cherukeshi Machan (cmachan)
+ Divyapuja Vitonde (davitond)

#### Note:<br/>
Environment used is ubuntu 14.04 based VCL machine
#### 1. Deployment
+ For Deployment follow these steps:
- `git clone https://github.ncsu.edu/DevOpsProjectMilestone3.git`
- Also make sure you copy the [config](config) file inside the ~/.ssh/ folder of your ansible server machine. (location :`~/.ssh/config`).
- Update credentials.ini with your credentials such as mysql_pass, mongo_pass and aws credentials
- `cd DevOpsProjectMilestone3`
- `sh installAnsible.sh` (For ansible installation)
- Edit the [id_rsa]
placed at location (https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/roles/SetupJenkins/tasks/id_rsa)
- Edit the [configureGit.yml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/roles/SetupJenkins/tasks/configureGit.yml) file present inside DevOpsProjectMilestone2//roles/SetupJenkins/tasks folder with your ncsu github username (e.g. nsakhal) and ncsu email id (e.g. nsakhal@ncsu.edu)
- Run the following commands now:
```
- ansible-playbook -i inventory main.yml
```
#### Steps for deployment through git hook
**Jenkins server** - {JenkinsIP}:8008  
**Checkbox server** - {checkboxIp}  
**iTrust server** - {iTrustIP}:8080/iTrust2  

Checking deployment of iTrust App through pre-push git hook present inside the .git/hooks folder of iTrust2-v2 folder on Jenkins Server
1. ssh to Jenkins server (ssh -i aws-m1-key.pem ubuntu@<{JenkinsIP})
2. cd iTrust2-v2 repo
2. Make changes in the iTrust2-v2 folder and then commit those changes
3. Push those changes --> git push origin production
4. Build should be triggered and you can see it on the Jenkins dashboard

Checking deployment of checkbox App through pre-push git hook present inside the .git/hooks folder of checkboxio folder on Jenkins Server
1. ssh to Jenkins server (ssh -i aws-m1-key.pem ubuntu@<{JenkinsIP})
2. cd checkboxio repo
2. Make changes in the checkbox folder and then commit those changes
3. Push those changes --> git push origin production
4. Build should be triggered and you can see it on the Jenkins dashboard

**Screencast Link:** [Deployment]( https://youtu.be/CEsmAjbBy7Q)

## Kubernetes Cluster Creation and Checkbox.io app deployment

+ Edit the [credentials](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/credentials) file with your AWS Credentials
+ Edit the [docker-compose.yaml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/docker-compose.yaml) with the necessary credentials
+ The following commands need to be executed for 3-node Kubernetes cluster creation and app deployment on the cluster:
```
git clone https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3.git
cd Kubernetes
chmod +x dockerComposeSetup.sh && chmod +x KubeSetupFinal.sh
. dockerComposeSetup.sh 
Logout and log back in for the docker setup to get completed
cd Kubernetes
. KubeSetupFinal.sh
```
+ For deploying app on the Kubernetes cluster, [deploy.yaml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/deploy.yaml) file is used. The docker image `nehasak30/cbtest6` used in this file has already been built using [docker-compose.yaml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/docker-compose.yaml) and pushed to the docker hub registry. The `name` used for `checkbox` image in the `docker-compose.yaml` file should be same as the `name` used for `checkbox6` container in the [deploy.yaml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/deploy.yaml) file.   
+ NOTE: Please make sure to log out and then log back in after running the `. dockerComposeSetup.sh ` command
+ [KubeSetupFinal.sh](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/KubeSetupFinal.sh) is the script used for automated kubernetes cluster creation and checkbox.io app deployment
+ [dockerComposeSetup.sh](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/dockerComposeSetup.sh) is the script for setup and installation of docker and docker-compose
+ [deploy.yaml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/deploy.yaml) is the file used for deploying the checkbox app on Kubernetes
+ [docker-compose.yaml](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/blob/master/Kubernetes/docker-compose.yaml) is used for building the docker image
+ The steps required to build an image using docker-compose can be found [here](https://docs.docker.com/compose/gettingstarted/)

**Screencast Link:** [Kubernetes Cluster](https://youtu.be/7kKn3MURnP8)

## Redis Feature Flag

### 
We have created redis master-slave topology. We have used 3 AWS EC2 instances. One as a master and other two as slaves. The Feature flags will be set on the master server and slave will get these flags on their servers. 

For demonstrating the feature flag, we have used the route /api/design/survey in server.js of checkbox.io application.

Once the flag "marqdownFlag" is set false, Marqdown Feature will be disabled on both slave servers.<br /> When the flag "marqdownFlag" is set true, Marqdown Feature will be enabled .

Redis roles are present in: [./post_build/roles/redisServer/](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/tree/RedisFeatureFlag/post_build/roles/redisServer)
<br /> Checkbox.io that was used for redis feature is [checkbox.io](https://github.com/cmachan/checkbox.io)


### Screencast Link 
[https://youtu.be/MFT6s1E90YM](https://youtu.be/MFT6s1E90YM)


## Canary Release

In this task we have to implement canary release for checkbox.io . We have created 3 AWS Ec2 servers for checkbox.io .

1. Stable server 
2. Newly staged version server
3. Loadbalancer server. 

The load balancer routes a percentage of  traffic to stable and remaining to newly staged version.
In order to stop the routing traffic to canary the load balancer server also has redis server installed. The feature flag "canaryFlag" will enable/disable the canary release feature.

We have created only once instance of mongoDB at loadbalancer server and both checkbox.io servers uses that db instance.

The files for load balancer are at [./post_build/roles/canaryRelease](https://github.ncsu.edu/nsakhal/DevOpsProjectMilestone3/tree/CanaryRelease/post_build/roles/canaryRelease)



### Screencast Link 
[https://youtu.be/fcVkiOa0WRU](https://youtu.be/fcVkiOa0WRU)

## Rolling Updates
Rolling update is basically an extension to normal deployment that we did in this milestone. We used mysql database on the same ec2 instance as on the jenkins-server. We need sql server in jenkins and sql client in all the instances of iTrust and ports at server should be open and accessible to all the instances. For this purpose we have added 3306 in inbound and All in outbound while creating security group in aws. Also the bind-address is made 0.0.0.0 in mycnf.d . For rolling updates we have used ansible module as script which is a recommended module for rolling updates and it will deploy the itrust just one at a time. In iTrust instances, after cloning the iTrust repository and making the mysql changes as above, we also changed hibernate properties and db properties. For monitoring part, we have used socket.io. The socket is listening on port 3000 and 8888. All the iTrust instances ips are fetched using replacec module. Also to detect the changes on dashboard we are stopping the jetty process one by one.

The complete code is present here :
https://github.ncsu.edu/davitond/DevOpsProjectMilestone3_DeploychangesGetUpdated.git

### Contributions
1. Neha Pradeep Sakhalkar (nsakhal2) - Kubernetes cluster and dockerized container for checkbox.io
2. Nupur Pradeep Sakhalkar(nsakhal) - Deployment of iTrust and checkboxio through pre-push hooks and ansible
3. Cherukeshi Machan (cmachan) - Redis Feature Flag and Canary Release
4. Divyapuja Vitonde (davitond) - Rolling update for iTrust


### References
+ https://redis.io/
+ https://www.npmjs.com/package/http-proxy
+ [docker-compose](https://docs.google.com/presentation/d/1RVy4W1RQPyFiB2ANEDHo2XnwCyGkl4DSFYcBv2g1s_8/edit#slide=id.g36b7be103b_1_77)
+ [Docker Compose: Getting Started](https://docs.docker.com/compose/gettingstarted/)
+ [mongodb](https://hub.docker.com/r/frodenas/mongodb/)
+ [Kubernetes Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
