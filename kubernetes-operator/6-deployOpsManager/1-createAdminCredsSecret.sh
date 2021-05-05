kubectl create secret generic ops-manager-admin-secret  --from-literal=Username="user.name@example.com" --from-literal=Password="Passw0rd."  --from-literal=FirstName="User" --from-literal=LastName="Name" -n mongodb

# Optionally, you can also create a password for the Ops Manager database user.
# See here: https://docs.mongodb.com/kubernetes-operator/stable/tutorial/plan-om-resource/#prerequisites
# kubectl create secret generic <om-db-user-secret-name> --from-literal=password="<om-db-user-password>"
# One additional secret is required for backing up snapshots to S3.

