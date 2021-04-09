echo
echo Creating 3-node replica set...

kubectl apply -f ./jj-replica-set.yaml --namespace=mongodb

echo
echo VERIFY:
#kubectl get mdb jj-replica-set -n mongodb -o yaml
kubectl get mdb jj-replica-set -n mongodb -w

