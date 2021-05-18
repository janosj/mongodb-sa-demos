PUBLIC_KEY=ZPWPLAHL
PRIVATE_KEY=d3a53874-7956-4c17-a6a2-6192b5ecbd97

echo
echo Creating secret...

# Set user to the public key, something like "user=CJXFACBV"
# Set publicApiKey to the private key, something like "publicApiKey=d7a664e8-b6b6-45fe-845a-ee4fd35c9636"

kubectl -n mongodb create secret generic opsmgr-credentials --from-literal="user=$PUBLIC_KEY" --from-literal="publicApiKey=$PRIVATE_KEY"

echo
echo VERIFY:
kubectl get secrets --namespace=mongodb

# To DELETE:
# kubectl delete secret opsmgr-credentials -n mongodb

