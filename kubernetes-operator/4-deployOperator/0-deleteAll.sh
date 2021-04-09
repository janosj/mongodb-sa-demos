# Remember: kubectl delete -f <file> reverses the apply

echo Deleting MongoDB resources...
kubectl delete mdb --all -n monogdb

echo Deleting entire MongoDB namespace...
kubectl delete namespace mongodb

echo Deleting deployment...
kubectl delete deployment mongodb-enterprise-operator -n mongodb

echo Deleting CRD..
kubectl delete crd opsmanagers.mongodb.com

