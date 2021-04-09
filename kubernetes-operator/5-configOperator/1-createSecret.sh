echo
echo Creating secret...

# Set user to the public key, something like "user=PWOMWMVO"
# Set publicApiKey to the private key, something like "publicApiKey=d7a664e8-b6b6-45fe-845a-ee4fd35c9636"

kubectl -n mongodb create secret generic my-credentials --from-literal="user=FQJSOONK" --from-literal="publicApiKey=d3557b5e-db31-4f64-81e1-c22177903082"

echo
echo VERIFY:
kubectl get secrets --namespace=mongodb

