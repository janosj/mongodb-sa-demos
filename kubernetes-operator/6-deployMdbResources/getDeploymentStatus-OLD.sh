# Retrieves status of test deployment (my-replica-set).

echo "Should list 'mdb' as a resource:"
set -x
kubectl api-resources | grep mongodb
set +x

echo
echo

echo "Should list 'my-replica-set' as a resource:"
set -x
kubectl get mdb my-replica-set -n mongodb
set +x

echo
echo

echo From the docs, should show status of RS deployment.
echo May have to wait a few seconds for there to be content.
set -x
kubectl get mdb my-replica-set -n mongodb -o yaml
set +x

echo
echo

echo Should show replica set pods running on 3 nodes.
set -x
kubectl get pods --namespace=mongodb --output=wide
set +x

echo
echo

echo "To delete the resource, fix the problem, and try again:"
echo "> kubectl delete mdb --all -n mongodb"

