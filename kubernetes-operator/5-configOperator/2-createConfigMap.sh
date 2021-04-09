echo
echo "Creating Kubernetes Config Map (config settings)..."

kubectl apply -f my-project.yaml --namespace=mongodb

echo
echo VERIFY:
kubectl get configmap my-project -o yaml --namespace=mongodb

