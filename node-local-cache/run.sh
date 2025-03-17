eksctl create nodegroup \
  --cluster test-cluster \
  --region eu-west-3 \
  --name my-mng \
  --node-ami-family AmazonLinux2 \
  --node-type m5.large \
  --nodes 3 \
  --nodes-min 2 \
  --nodes-max 4 \
  --ssh-access \
  --ssh-public-key tomberek

eksctl utils write-kubeconfig --cluster=basic-cluster --region eu-west-3

kubectl create namespace eks-sample-app
kubectl apply -f eks-sample-service.yaml
kubectl apply -f eks-sample-deployment.yaml

kubectl logs -n eks-sample-app -f deployment.apps/eks-sample-linux-deployment -f=true --prefix=true
