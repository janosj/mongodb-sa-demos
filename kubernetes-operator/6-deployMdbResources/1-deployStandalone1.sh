echo
echo "Creating Config Map ..."

cat <<EOF | kubectl apply -n mongodb -f -
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: cm-standalone1
data:
  projectName: Kubernetes Standalone 1
  baseUrl: http://ip-172-31-48-13.ec2.internal:8080
  orgId: 60873c4dc6f0c14e32c8e363
EOF

echo
echo VERIFY ConfigMap:
kubectl get configmap cm-standalone1 -o yaml --namespace=mongodb
echo
echo
echo "Deploying Standalone 1..."

cat <<EOF | kubectl apply -n mongodb -f -
#
# This is a minimal config. To see all the options available, refer to the
# "extended" directory
#
---
apiVersion: mongodb.com/v1
kind: MongoDB
metadata:
  name: mdb-standalone-1
spec:
  version: 4.2.5-ent
  type: Standalone
  # Before you create this object, you'll need to create a project ConfigMap and a
  # credentials Secret. For instructions on how to do this, please refer to our
  # documentation, here:
  # https://docs.opsmanager.mongodb.com/current/tutorial/install-k8s-operator
  opsManager:
    configMapRef:
      name: cm-standalone1
  credentials: opsmgr-credentials

  # This flag allows the creation of pods without persistent volumes. This is for
  # testing only, and must not be used in production. 'false' will disable
  # Persistent Volume Claims. The default is 'true'
  persistent: false
EOF

echo
echo "To DELETE: kubectl delete mdb mdb-standalone-1 -n mongodb"
echo
echo "Status:"
kubectl get pods -n mongodb -w

