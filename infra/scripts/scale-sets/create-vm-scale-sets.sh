#!/bin/bash

echo '--------------------------------------------------------'
echo '             VM Setup Script Started'
echo '--------------------------------------------------------'

# Create a Resource group
RgName=$(az group create --name proj-scalesets-rg --location australiaeast --tags type=project resource=vm --query name -o tsv)
echo 'The resource group is' "$RgName"

date

# Create a Virtual Machine Scale Set
echo '------------------------------------------'
echo 'Creating a Virtual Machine scale set'
echo '------------------------------------------'
az vmss create \
    --resource-group $RgName \
    --name proj-scalesets-vm \
    --image Ubuntu2204 \
    --vm-sku Standard_B1s \
    --upgrade-policy-mode automatic \
    --custom-data cloud-init.yaml \
    --admin-username azureuser \
    --generate-ssh-keys

echo '------------------------------------------'
echo 'Retrieving NSG details'
echo '------------------------------------------'
# Get the NSG name
nsgName=$(az network nsg list -g proj-scalesets-rg --query "[0].name" -o tsv)
echo 'The Network Security group name is' "$nsgName"

echo '------------------------------------------'
echo 'Retrieving key LB details'
echo '------------------------------------------'
# Get the load balancer name
lbName=$(az network lb list --resource-group $RgName --query "[0].name" -o tsv)
echo "Load balancer name: $lbName"

# Get the back end pool name
bePoolName=$(az network lb list --resource-group proj-scalesets-rg --query "[0].backendAddressPools[0].name" -o tsv)
echo "Back end pool name: $bePoolName"

# Get the front end ip name
fontEndIPName=$(az network lb list --resource-group proj-scalesets-rg --query "[0].frontendIPConfigurations[0].name" -o tsv)
echo "Front end ip name: $fontEndIPName"

# Get the load balancing rule name
lbRuleName=$(az network lb list --resource-group proj-scalesets-rg --query "[0].loadBalancingRules[0].name" -o tsv)
echo "Load balancing rule name is: $lbRuleName"

#   Add a health probe
echo '------------------------------------------'
echo 'Adding a health probe to the LB'
echo '------------------------------------------'
az network lb probe create --lb-name $lbName \
    --resource-group $RgName \
    --name webServerHealth \
    --port 80 \
    --protocol Http \
    --path /

#   Update the LB rule
echo '------------------------------------------'
echo 'Adding the LB rule'
echo '------------------------------------------'
az network lb rule update \
    --resource-group $RgName \
    --name $lbRuleName \
    --lb-name $lbName \
    --probe-name webServerHealth \
    --protocol tcp

    # Add inbound rule on port 80
echo '------------------------------------------'
echo 'Allowing access on port 80'
az network nsg rule create \
    --resource-group $RgName \
    --nsg-name $nsgName \
    --name Allow-80-Inbound \
    --priority 110 \
    --source-address-prefixes '*' \
    --source-port-ranges '*' \
    --destination-address-prefixes '*' \
    --destination-port-ranges 80 \
    --access Allow \
    --protocol Tcp \
    --direction Inbound \
    --description "Allow inbound on port 80."

# Done
echo '--------------------------------------------------------'
echo '             VM Setup Script Completed'
echo '--------------------------------------------------------'
