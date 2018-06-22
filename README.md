# Canary Release


In this task we have to implement canary release for checkbox.io . We have created 3 AWS Ec2 servers for checkbox.io .

1. Stable server 
2. Newly staged version server
3. Loadbalancer server. 

The load balancer routes a percentage of  traffic to stable and remaining to newly staged version.
In order to stop the routing traffic to canary the load balancer server also has redis server installed. The feature flag "canaryFlag" will enable/disable the canary release feature.

We have created only once instance of mongoDB at loadbalancer server and both checkbox.io servers uses that db instance.

The files for load balancer are at [./post_build/roles/canaryRelease](https://github.ncsu.edu/cmachan/CanaryRelease/tree/master/post_build/roles/canaryRelease)



### Screencast Link 
[https://youtu.be/fcVkiOa0WRU](https://youtu.be/fcVkiOa0WRU)
