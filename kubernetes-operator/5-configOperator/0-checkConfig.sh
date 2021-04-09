echo Checking for required config settings...

if grep -q REPLACE "./jj-configmap.yaml"; then
  echo "BaseURL and/or orgID not provided in jj-configmap.yaml". 
  exit 1
fi

if grep -q REPLACE "./1-createSecret.sh"; then
  echo "Public and/or Private API keys haven't been provided in 1-createSecret.sh."
  exit 1
fi

echo "Everything looks good!"

