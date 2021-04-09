echo
echo Installing MongoDB Enterprise Kubernetes Operator...

kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml

echo Verify:
#kubectl get pods --all-namespaces
#output=wide tells you where the pod is running (i.e. which node)
kubectl get pods --namespace=mongodb --output=wide

