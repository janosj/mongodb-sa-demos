# Your AWS key is required to access the instances.
read -p "Name of AWS keyfile (no extension): " KEYFILE

echo "Pulling cert from opsmgr-aws..."
scp -i $HOME/Keys/$KEYFILE.pem ec2-user@opsmgr-aws:./opsmgrCA.pem ~/Downloads/

echo "Server cert successfully pulled into Downloads directory."
echo "Import it via Keychain Access (Mac utility, drag and drop into login section)"
echo "Double-click on it, switch Trust to 'Always Trust'"


