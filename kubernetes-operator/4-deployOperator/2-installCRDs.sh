echo
echo Creating MongoDB CustomResourceDefinitions...
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml

echo Verifying:
kubectl get crd
#kubectl describe crd <crd-name>
#kubectl delete cdr <crd-name>

