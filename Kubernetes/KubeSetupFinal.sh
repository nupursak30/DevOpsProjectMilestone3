#!/bin/bash 
#Make sure there aws credentials and aws config and names.txt file is present in the current directory. Make sure to make the bash script executable.

echo "--------------- Installing dependencies ------------------"
sleep 2s
sudo apt-get update && sudo apt-get install -y python-pip
pip install awscli

#Installs kubectl
sudo snap install kubectl --classic

#Installs kops
wget -O kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x ./kops
sudo mv ./kops /usr/local/bin/

echo "---------------------- Creating SSH key ------------------------------"
sleep 1s
ssh-keygen -t rsa -N ''

echo "--------------------- Copying AWS credentials to $HOME/.aws folder ------------------------"
sleep 2s
#Copy aws credentials and config to ~/.aws/config and ~/.aws/credentials. Initial credentials will be set to original access keys
mkdir -p $HOME/.aws && cp ./credentials $HOME/.aws/credentials && cp ./config $HOME/.aws/config

export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

echo "--------------------- Create IAM user, group and user access key ------------------------"
sleep 2s
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops

aws iam create-user --user-name kops

aws iam add-user-to-group --user-name kops --group-name kops
aws iam create-access-key --user-name kops > ./kops_credentials.json

echo "--------------------- Setting new AWS credentials for kops ----------------------------"
sleep 2s
kops_secretAccessKey=$(awk '/SecretAccessKey/{gsub(/[",]/,"",$2);printf $2}' kops_credentials.json)
kops_accessKeyID=$(awk '/AccessKeyId/{gsub(/[",]/,"",$2);printf $2}' kops_credentials.json)

export AWS_ACCESS_KEY_ID=$kops_accessKeyID
export AWS_SECRET_ACCESS_KEY=$kops_secretAccessKey

#echo $AWS_ACCESS_KEY_ID
#echo $AWS_SECRET_ACCESS_KEY

sed -i "s|aws_access_key_id.*|aws_access_key_id = ${AWS_ACCESS_KEY_ID}|" $HOME/.aws/credentials
sed -i "s|aws_secret_access_key.*|aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}|" $HOME/.aws/credentials

#echo "----------------- NEW AWS CREDENTIALS file ------------------------"
#cat $HOME/.aws/credentials
#sleep 2s

echo "--------------------- Reading cluster and bucket name from names.txt ------------------------"
CLUSTER_NAME=$(awk '/ClusterName/{gsub(/"/,"",$2);printf $2}' names.txt)
BUCKET_NAME=$(awk '/S3_bucket_name/{gsub(/"/,"",$2);printf $2}' names.txt)

#BUCKET_NAME=neta-example-com-state-store
echo "S3 bucket name ${BUCKET_NAME}"
echo "Cluster name ${CLUSTER_NAME}"

sleep 5s

echo "----------------------- Creating a S3 bucket ----------------------------------"
sleep 2s
aws s3api create-bucket --bucket ${BUCKET_NAME} --region us-east-1
#aws s3api create-bucket --bucket tintin31-example-com-state-store --region us-east-1
aws s3api put-bucket-versioning --bucket $BUCKET_NAME  --versioning-configuration Status=Enabled

echo "---------------------- List S3 bucket ------------------------------"
aws s3api list-buckets
sleep 2s

echo "---------------------------- Create cluster --------------------------"
sleep 1s
export NAME=$CLUSTER_NAME
export KOPS_STATE_STORE=s3://$BUCKET_NAME

kops create cluster --name=${CLUSTER_NAME} --zones=us-east-2b --master-size="t2.micro" --node-size="t2.micro" --node-count="3" --ssh-public-key="~/.ssh/id_rsa.pub"
kops update cluster ${NAME} --yes

echo "--------------------------- Waiting till the cluster is ready(for 5 min) ---------------------------"
sleep 5m

echo "----------------------------- Validate if the cluster is ready -----------------------------"
sleep 2s
kops validate cluster

until kops validate cluster | grep 'local is ready'; do
   echo "Cluster is still being created!! Waiting for few more minutes"
   sleep 2m	
done

echo "--------------------------------- Deploying app on cluster -----------------------------------"
sleep 1s

echo "---------------------------- Deploy the app ---------------------------------"
#Assuming docker-compose.yaml file is in the same directory as the one in which this script runs
kubectl create -f deploy.yaml

echo "---------------------------Waiting for app deployment-------------------------------------"
sleep 2m

echo "------------------------------ Get the deployed app details -------------------------------"
sleep 1s
kubectl get pods,svc,deployments
sleep 5s

echo "------------------------------ Expose the deployment --------------------------------------"
sleep 1s
kubectl expose deployment checkbox-deployment --type=LoadBalancer --name=service6
sleep 2m

echo ""
echo ""
echo "------------------------ Get service details ---------------------------------------"
sleep 1s
kubectl describe services service6


